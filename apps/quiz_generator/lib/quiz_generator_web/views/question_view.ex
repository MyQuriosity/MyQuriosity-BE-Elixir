defmodule QuizGeneratorWeb.QuestionView do
  alias QuizGeneratorWeb.TopicView
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
      topic_id: question.topic_id,
      deactivated_at: question.deactivated_at,
      topic:
        (Ecto.assoc_loaded?(question.topic) &&
           render_one(question.topic, TopicView, "show.json", as: :topic)) || nil,
      options: render_many(question.options, __MODULE__, "option.json", as: :option)
    }
  end

  def render("option.json", %{option: option}) do
    %{
      id: option.id,
      title: option.title,
      is_correct: option.is_correct,
      key: option.key,
      deactivated_at: option.deactivated_at
    }
  end
end
