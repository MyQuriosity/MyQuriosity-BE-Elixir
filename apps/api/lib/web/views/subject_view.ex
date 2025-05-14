defmodule Api.SubjectView do
  alias Api.GradeView
  use MyQuriosityWeb, :view

  def render("index.json", %{records: records, meta: meta}) do
    %{
      meta: meta,
      records: render_many(records, __MODULE__, "show.json", as: :subject)
    }
  end

  def render("show.json", %{subject: subject}) do
    %{
      id: subject.id,
      title: subject.title,
      course_code: subject.course_code,
      color: subject.color,
      grade_id: subject.grade_id,
      grade:
        (Ecto.assoc_loaded?(subject.grade) &&
           render_one(subject.grade, GradeView, "show.json", as: :grade)) || nil
    }
  end
end
