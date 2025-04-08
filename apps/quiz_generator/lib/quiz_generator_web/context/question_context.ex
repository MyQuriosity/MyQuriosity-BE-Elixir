defmodule QuizGenerator.QuestionContext do
  @moduledoc """
  This module is used to creates a new MCQ paper with questions and options.
  """

  alias Ecto.Multi
  alias QuizGenerator.Option
  alias QuizGenerator.Question
  alias QuizGenerator.QuestionFilterContext
  alias QuizGenerator.Repo
  alias QuizGenerator.Utils.PaginationUtils
  import Ecto.Query

  def create_quiz_with_questions_and_options(questions, topic_id) do
    current_dt = DateTime.truncate(DateTime.utc_now(), :second) |> DateTime.to_naive()

    multi =
      Multi.new()
      |> Multi.run(:insert_questions, fn _repo, _changes ->
        questions_list =
          Enum.map(questions, fn question ->
            %{
              title: question["title"],
              topic_id: topic_id,
              inserted_at: current_dt,
              updated_at: current_dt
            }
          end)

        case Repo.insert_all(Question, questions_list, on_conflict: :raise, returning: [:id, :title]) do
          {num, inserted_questions} when num > 0 -> {:ok, inserted_questions}
          error -> IO.inspect(error)
           {:error, "Failed to insert questions"}
        end
      end)
      |> Multi.run(:insert_options, fn _repo, %{insert_questions: inserted_questions} ->
        options_list =
          Enum.flat_map(Enum.zip(inserted_questions, questions), fn {inserted_question, question_params} ->
            Enum.map(question_params["options"], fn {key, option_text} ->
              %{
                title: option_text,
                is_correct: Enum.member?(question_params["answers"], key),
                question_id: inserted_question.id,
                inserted_at: current_dt,
                updated_at: current_dt
              }
            end)
          end)

        case Repo.insert_all(Option, options_list, on_conflict: :raise) do
          {num, _} when num > 0 -> {:ok, options_list}
          _ -> {:error, "Failed to insert options"}
        end
      end)

      # Handling Postgrex unique violation error
    try do
      Repo.transaction(multi)
    rescue
      e in Postgrex.Error ->
        handle_error(e)
    end
  end

  def update_question_and_options(question, attrs) do
    options = Map.get(attrs, "options", [])
    question_changeset = Question.changeset(question, Map.drop(attrs, ["options"]))

    Multi.new()
    |> Multi.run(:question, fn _repo, _ ->
      Repo.update(question_changeset)
    end)
    |> Multi.run(:delete_options, fn _repo, %{question: question} ->
      # options_query = (from o in Option, where: o.question_id == ^question.id)
      # Repo.delete_all()
    end)
    |> Mulit.run(:insert_options, fn _repo, %{question: _question} ->
      IO.inspect(options)
    end)
      # Enum.each(options_attrs, fn opt_attrs ->
      #   case Map.get(opt_attrs, "id") do
      #     nil ->
      #       # New option
      #       changeset = Option.changeset(%Option{question_id: question.id}, opt_attrs)
      #       Repo.insert!(changeset)
      #     id ->
      #       # Update existing option
      #       existing_opt = Enum.find(existing_options, &(&1.id == String.to_integer(id)))
      #       changeset = Option.changeset(existing_opt, opt_attrs)
      #       Repo.update!(changeset)
      #   end
      # end)

      {:ok, :options_updated}
    |> Repo.transaction()
  end

  def get_question_by_id(id), do: {:ok, Repo.get(Question, id)}

    def fetch_paginated(params) do
    params
    |> QuestionFilterContext.filtered_query()
    |> PaginationUtils.paginate(params)
  end

  def handle_error(%Postgrex.Error{postgres: %{detail: detail}}), do: {:error, detail}
end
