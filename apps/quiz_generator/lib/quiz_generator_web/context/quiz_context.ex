defmodule QuizGenerator.QuizContext do
  @moduledoc """
  This module is used to creates a new MCQ paper with questions and options.
  """

  alias QuizGenerator.Question
  alias QuizGenerator.Option
  alias Ecto.Multi
  alias QuizGenerator.Repo
  alias QuizGenerator.Quiz
  alias QuizGenerator.Utils.PaginationUtils
  alias QuizGenerator.QuizFilterContext

  def create_quiz_with_questions_and_options(questions, additional_info) do
    Multi.new()
    |> Multi.insert(:quiz, Quiz.changeset(%Quiz{}, additional_info))
    |> Multi.run(:questions, fn _repo, %{quiz: quiz} ->
      questions_params =
        Enum.map(questions, fn question ->
          %{
            title: question["title"],
            quiz_id: quiz.id,
            inserted_at: DateTime.truncate(DateTime.utc_now(), :second) |> DateTime.to_naive(),
            updated_at: DateTime.truncate(DateTime.utc_now(), :second) |> DateTime.to_naive()
          }
        end)

      {_, inserted_questions} = Repo.insert_all(Question, questions_params, returning: true)
      {:ok, inserted_questions}
    end)
    |> Multi.run(:options, fn _repo, %{questions: inserted_questions} ->
      options =
        Enum.flat_map(Enum.zip(inserted_questions, questions), fn {inserted_question,
                                                                   question_params} ->
          Enum.map(question_params["options"], fn {key, option_params} ->
            answers = question_params["answers"]

            %{
              title: option_params,
              is_correct: Enum.member?(answers, key),
              question_id: inserted_question.id,
              inserted_at: DateTime.truncate(DateTime.utc_now(), :second) |> DateTime.to_naive(),
              updated_at: DateTime.truncate(DateTime.utc_now(), :second) |> DateTime.to_naive()
            }
          end)
        end)

      {_, inserted_options} = Repo.insert_all(Option, options, returning: true)
      {:ok, inserted_options}
    end)
    |> Repo.transaction()
  end

  def fetch_paginated(params) do
    params
    |> QuizFilterContext.filtered_query()
    |> PaginationUtils.paginate(params)
  end
end
