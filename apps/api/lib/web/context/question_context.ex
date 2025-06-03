defmodule Api.QuestionContext do
  @moduledoc """
  This module is used to creates a new questions with options.
  """

  alias Api.QuestionFilterContext
  alias Api.Utils.PaginationV2Utils
  alias Data.Option
  alias Data.Question
  alias Data.Repo
  alias Ecto.Multi
  import Ecto.Query

  @spec create_quiz_with_questions_and_options(list(), String.t()) :: any()
  def create_quiz_with_questions_and_options(params_list, topic_id) do
    case check_duplicate_questions(params_list) do
      [] -> insert_questions_transaction(params_list, topic_id)
      errors -> {:error, errors}
    end
  end

  defp insert_questions_transaction(params_list, topic_id) do
    multi = create_question_multi(params_list, topic_id)

    case Repo.transaction(multi) do
      {:ok, result} ->
        {:ok, result}

      {:error, {_type, question_number}, reason, _changes} ->
        {:error, format_error(reason, question_number)}
    end
  end

  defp format_error(%Ecto.Changeset{} = ch, question_number) do
    translate_changeset_errors(ch, question_number)
  end

  defp format_error(msg, question_number) when is_binary(msg) do
    [%{question_number: question_number, error: msg}]
  end

  defp create_question_multi(params_list, topic_id) do
    Enum.reduce(params_list, Multi.new(), fn %{"question_number" => number} = params, multi_acc ->
      question_key = {:question, number}
      options_key = {:options, number}

      params = Map.put(params, "topic_id", topic_id)
      question_changeset = Question.insertion_changeset(%Question{}, params)

      multi_acc
      |> Multi.insert(question_key, question_changeset)
      |> Multi.run(options_key, fn repo, changes ->
        insert_options(repo, changes, question_key, params)
      end)
    end)
  end

  defp insert_options(repo, changes, question_key, %{"options" => options, "answers" => answers}) do
    question = Map.fetch!(changes, question_key)

    options
    |> Enum.map(fn {key, opt} ->
      Option.changeset(%Option{}, %{
        title: opt,
        question_id: question.id,
        is_correct: key in answers,
        key: key
      })
    end)
    |> Enum.reduce_while({:ok, []}, fn changeset, {:ok, acc} ->
      case repo.insert(changeset) do
        {:ok, opt} -> {:cont, {:ok, [opt | acc]}}
        {:error, ch} -> {:halt, {:error, ch}}
      end
    end)
  end

  defp check_duplicate_questions(questions) do
    {_, errors} =
      Enum.reduce(questions, {%{}, []}, fn question, {seen_acc, err_acc} ->
        number = question["question_number"]
        title = question["title"]
        options_map = question["options"] || %{}

        err_acc =
          case validate_options(options_map, number) do
            :ok ->
              err_acc

            {:error, errors} ->
              Enum.concat(err_acc, errors)
          end

        normalized_options = Enum.sort(options_map)
        signature = {title, normalized_options}

        if Map.has_key?(seen_acc, signature) do
          {seen_acc,
           [%{question_number: number, message: "Duplicate question with same options"} | err_acc]}
        else
          {Map.put(seen_acc, signature, true), err_acc}
        end
      end)

    Enum.reverse(errors)
  end

  defp validate_options(options, number) do
    values = Map.values(options)

    errors =
      []
      |> maybe_add_error(Enum.any?(values, &(&1 == "")), %{
        question_number: number,
        message: "Options must not be empty"
      })
      |> maybe_add_error(Enum.uniq(values) != values, %{
        question_number: number,
        message: "Options must be unique"
      })

    if errors == [] do
      :ok
    else
      {:error, errors}
    end
  end

  defp maybe_add_error(errors, true, message), do: [message | errors]
  defp maybe_add_error(errors, false, _), do: errors

  defp translate_changeset_errors(changeset, question_number) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
    |> Enum.flat_map(fn {field, msgs} ->
      Enum.map(msgs, fn msg ->
        %{
          question_number: question_number,
          field: field,
          error: msg
        }
      end)
    end)
  end

  def update_question(question, %{"options" => options, "answers" => answers} = params) do
    multi =
      Multi.new()
      |> Multi.run(:question, fn _repo, _ -> update_question_changeset(question, params) end)
      |> Multi.run(:delete_options, fn _repo, %{question: q} -> delete_existing_options(q) end)
      |> Multi.run(:insert_options, fn _repo, %{question: q} ->
        insert_new_options(q, options, answers)
      end)

    try do
      Repo.transaction(multi)
    rescue
      e in Postgrex.Error -> handle_error(e)
    end
  end

  def update_question(question, params) do
    question
    |> Question.changeset(params)
    |> Repo.update()
  end

  defp update_question_changeset(question, params) do
    question
    |> Question.changeset(params)
    |> Repo.update()
  end

  defp delete_existing_options(question) do
    from(o in Option, where: o.question_id == ^question.id)
    |> Repo.delete_all(returning: [:id])
    |> case do
      {num, deleted_options} when num > 0 -> {:ok, deleted_options}
      _ -> {:error, "Failed to delete options"}
    end
  end

  defp insert_new_options(question, options, answers) do
    case validate_options(options, 1) do
      :ok ->
        options
        |> Enum.map(&build_option_changeset(&1, question.id, answers))
        |> Enum.reduce_while({:ok, []}, &insert_option/2)

      {:error, [%{message: msg} | _]} ->
        {:error, msg}
    end
  end

  defp build_option_changeset({key, title}, question_id, answers) do
    Option.changeset(%Option{}, %{
      title: title,
      question_id: question_id,
      is_correct: key in answers,
      key: key
    })
  end

  defp insert_option(changeset, {:ok, acc}) do
    case Repo.insert(changeset) do
      {:ok, opt} -> {:cont, {:ok, [opt | acc]}}
      {:error, ch} -> {:halt, {:error, ch}}
    end
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
    |> PaginationV2Utils.paginated(params)
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
