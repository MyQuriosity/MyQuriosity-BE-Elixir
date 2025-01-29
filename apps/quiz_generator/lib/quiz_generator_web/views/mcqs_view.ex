defmodule QuizGeneratorWeb.MCQsView do
  use QuizGeneratorWeb, :view

  def render("index.json", %{records: records, meta: meta}) do
    %{
      meta: meta,
      records: render_many(records, __MODULE__, "show.json", as: :question)
    }
  end

  def render("show.json", %{question: question}) do
    %{
      id: question.id,
      title: question.title,
      syllabus_provider_id: question.syllabus_provider_id,
      subject_id: question.subject_id,
      chapter_id: question.chapter_id,
      topic_id: question.topic_id,
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
