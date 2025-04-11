defmodule QuizGenerator.QuestionContext do
  @moduledoc """
  This module is used to creates a new questions with options.
  """

  alias Ecto.Multi
  alias QuizGenerator.Option
  alias QuizGenerator.Question
  alias QuizGenerator.QuestionFilterContext
  alias QuizGenerator.Repo
  alias QuizGenerator.Utils.PaginationUtils
  import Ecto.Query

  @spec create_quiz_with_questions_and_options(list(), String.t()) :: any()
  def create_quiz_with_questions_and_options(questions, topic_id) do
    current_dt = DateTime.truncate(DateTime.utc_now(), :second) |> DateTime.to_naive()

    Multi.new()
    |> Multi.run(:insert_questions, fn _repo, _ ->
      insert_questions(questions, topic_id, current_dt)
    end)
    |> Multi.run(:insert_options, fn _repo, %{insert_questions: inserted_questions} ->
      insert_options(inserted_questions, questions, current_dt)
    end)
    |> run_transaction()
  end

  def update_question(question, %{"options" => options, "answers" => answers} = params) do
    current_dt = DateTime.truncate(DateTime.utc_now(), :second) |> DateTime.to_naive()

    multi =
      Multi.new()
      |> Multi.run(:question, fn _repo, _ ->
        question
        |> Question.changeset(params)
        |> Repo.update()
      end)
      |> Multi.run(:delete_options, fn _repo, %{question: question} ->
        options_query = from o in Option, where: o.question_id == ^question.id

        case Repo.delete_all(options_query, returning: [:id]) do
          {num, deleted_options} when num > 0 -> {:ok, deleted_options}
          _ -> {:error, "Failed to insert options"}
        end
      end)
      |> Multi.run(:insert_options, fn _repo, %{question: question} ->
        options_list =
          Enum.map(options, fn {key, option_text} ->
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

  @spec delete_question(any()) :: any()
  def delete_question(question) do
    multi =
      Multi.new()
      |> Multi.run(:delete_question, fn _repo, _ ->
        question
        |> Question.changeset(%{deactivated_at: DateTime.utc_now()})
        |> Repo.update()
      end)
      |> Multi.run(:delete_options, fn _repo, %{delete_question: question} ->
        options_query = from o in Option, where: o.question_id == ^question.id

        case Repo.update_all(options_query, set: [deactivated_at: DateTime.utc_now()]) do
          {num, deactivated_options} when num > 0 ->
            {:ok, deactivated_options}

          _ ->
            {:error, "Failed to deactivate options"}
        end
      end)

    try do
      Repo.transaction(multi)
    rescue
      e in Postgrex.Error ->
        handle_error(e)
    end
  end

  @spec get_question_by_id(String.t()) :: {:error, :not_found} | {:ok, Question.t()}
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

  defp insert_questions(questions, topic_id, dt) do
    question_payloads =
      Enum.map(questions, fn question ->
        %{
          title: question["title"],
          topic_id: topic_id,
          inserted_at: dt,
          updated_at: dt
        }
      end)

    case Repo.insert_all(Question, question_payloads, returning: [:id, :title]) do
      {num, result} when num > 0 -> {:ok, result}
      _ -> {:error, "Failed to insert questions"}
    end
  end

  defp insert_options(inserted_questions, question_params_list, dt) do
    options_list =
      Enum.flat_map(Enum.zip(inserted_questions, question_params_list), fn {question, q_params} ->
        Enum.map(q_params["options"], fn {key, opt_text} ->
          %{
            title: opt_text,
            is_correct: key in q_params["answers"],
            question_id: question.id,
            inserted_at: dt,
            updated_at: dt
          }
        end)
      end)

    case Repo.insert_all(Option, options_list) do
      {num, _} when num > 0 -> {:ok, options_list}
      _ -> {:error, "Failed to insert options"}
    end
  end

  defp run_transaction(multi) do
    try do
      Repo.transaction(multi)
    rescue
      e in Postgrex.Error -> handle_error(e)
    end
  end

  defp handle_error(%Postgrex.Error{postgres: %{detail: detail}}), do: {:error, detail}

  def validate_quiz_payload?(questions) when is_list(questions) do
    valid? =
      Enum.all?(questions, fn question ->
        Map.has_key?(question, "options") and
          is_map(question["options"]) and map_size(question["options"]) > 0 and
          Map.has_key?(question, "answers") and
          is_list(question["answers"]) and question["answers"] != []
      end)

    if valid?, do: {:ok, true}, else: {:error, "Incomplete parameters for question"}
  end

  def validate_quiz_payload?(_), do: {:error, "Incomplete parameters for question"}
end
