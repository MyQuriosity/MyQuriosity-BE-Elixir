defmodule QuizGeneratorWeb.QuizView do
  use QuizGeneratorWeb, :view

  def render("index.json", %{records: records, meta: meta}) do
    %{
      meta: meta,
      records: render_many(records, __MODULE__, "show.json", as: :quiz)
    }
  end

  def render("show.json", %{quiz: quiz}) do
    %{
      id: quiz.id,
      title: quiz.title,
      topic_id: quiz.topic_id,
      questions: render_many(quiz.questions, __MODULE__, "question.json", as: :question)
    }
  end

  def render("question.json", %{question: question}) do
    %{
      id: question.id,
      title: question.title,
      options: render_many(question.options, __MODULE__, "option.json", as: :option)
    }
  end

  def render("option.json", %{option: option}) do
    %{
      id: option.id,
      title: option.title,
      is_correct: option.is_correct
    }
  end
end
