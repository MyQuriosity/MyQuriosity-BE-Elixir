defmodule Api.ChapterView do
  use MyQuriosityWeb, :view

  def render("index.json", %{records: records, meta: meta}) do
    %{
      meta: meta,
      records: render_many(records, __MODULE__, "show.json", as: :chapter)
    }
  end

  def render("show.json", %{chapter: chapter}) do
    %{
      id: chapter.id,
      title: chapter.title,
      description: chapter.description,
      number: chapter.number,
      subject_id: chapter.subject_id,
      subject:
        (Ecto.assoc_loaded?(chapter.subject) &&
           render_one(chapter.subject, Api.SubjectView, "show.json", as: :subject)) ||
          nil
    }
  end
end
