defmodule QuizGenerator.MCQs do
  @moduledoc """
  This module is used to creates a new MCQ paper with questions and options.
  """

  alias QuizGenerator.Question
  alias QuizGenerator.Repo
  alias QuizGenerator.Utils.PaginationUtils
  alias QuizGenerator.MCQsFilterContext

  @spec create_mcq_paper(list(map()), map()) ::
          {:ok, :mcqs_paper_created} | {:error, String.t(), Ecto.Changeset.t(), map()}
  def create_mcq_paper(questions_params, additional_info) do
    questions_params
    |> Enum.with_index()
    |> Enum.reduce(Ecto.Multi.new(), &create_question_with_options(&1, &2, additional_info))
    |> Repo.transaction()
    |> case do
      {:ok, _results} ->
        {:ok, :mcqs_paper_created}

      error ->
        error
    end
  end

  defp create_question_with_options(
         {%{
            "question" => question_text,
            "options" => options,
            "answers" => answers
          }, current_entry_no},
         multi,
         additional_info
       ) do
    options_data =
      Enum.map(options, fn {key, text} ->
        %{title: text, is_correct: Enum.member?(answers, key)}
      end)

    question_params = prepare_question_params(additional_info, question_text, options_data)

    question_changeset = Question.changeset(%Question{}, question_params)

    multi_name = "question_#{current_entry_no}"

    Ecto.Multi.insert(multi, multi_name, question_changeset)
  end

  def fetch_paginated(params) do
    params
    |> MCQsFilterContext.filtered_query()
    |> PaginationUtils.paginate(params)
  end

  defp prepare_question_params(additional_info, quesion_title, question_options),
    do: additional_info |> Map.put("title", quesion_title) |> Map.put("options", question_options)
end
