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
          _error ->
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

  def update_question(question, %{"options" => options, "answers" => answers} = params) do
    current_dt = DateTime.truncate(DateTime.utc_now(), :second) |> DateTime.to_naive()

    multi = Multi.new()
    |> Multi.run(:question, fn _repo, _ ->
      question
      |> Question.changeset(params)
      |> Repo.update()
    end)
    |> Multi.run(:delete_options, fn _repo, %{question: question} ->
      options_query = (from o in Option, where: o.question_id == ^question.id)

     case Repo.delete_all(options_query, returning: [:id]) do
      {num, deleted_options} when num > 0 -> {:ok, deleted_options}
      _ -> {:error, "Failed to insert options"}
     end
    end)
    |> Multi.run(:insert_options, fn _repo, %{question: question} ->
     options_list = Enum.map(options, fn {key, option_text} ->
        %{
          title: option_text,
          is_correct: Enum.member?(answers, key),
          question_id: question.id,
          inserted_at: current_dt,
          updated_at: current_dt
        }
      end)

      case Repo.insert_all(Option, options_list, on_conflict: :raise) do
        {num, _} when num > 0 -> {:ok, options_list}
        _ -> {:error, "Failed to insert options"}
      end
    end)

    try do
      Repo.transaction(multi)
    rescue
      e in Postgrex.Error ->
        handle_error(e)
    end
  end

  def update_question(question, params) do
    question
    |> Question.changeset(params)
    |> Repo.update()
  end

  def get_question_by_id(id) do
    Question
    |> Repo.get(id)
    |> case do
      nil -> {:error, :not_found}
      question -> {:ok, question}
    end
  end

  def fetch_paginated(params) do
    params
    |> QuestionFilterContext.filtered_query()
    |> PaginationUtils.paginate(params)
  end

  def handle_error(%Postgrex.Error{postgres: %{detail: detail}}), do: {:error, detail}
end
