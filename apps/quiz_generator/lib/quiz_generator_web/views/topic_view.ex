defmodule QuizGeneratorWeb.TopicView do
  use QuizGeneratorWeb, :view

  def render("index.json", %{records: records, meta: meta}) do
    %{
      meta: meta,
      records: render_many(records, __MODULE__, "show.json", as: :topic)
    }
  end

  def render("show.json", %{topic: topic}) do
    %{
      id: topic.id,
      title: topic.title,
      number: topic.number,
      description: topic.description,
      chapter_id: topic.chapter_id,
      chapter:
        (Ecto.assoc_loaded?(topic.chapter) &&
           render_one(topic.chapter, QuizGeneratorWeb.ChapterView, "show.json", as: :chapter)) ||
          nil
    }
  end
end
