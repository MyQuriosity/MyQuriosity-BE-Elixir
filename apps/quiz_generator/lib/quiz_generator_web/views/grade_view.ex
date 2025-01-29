defmodule QuizGeneratorWeb.GradeView do
  use QuizGeneratorWeb, :view

  def render("index.json", %{records: records, meta: meta}) do
    %{
      meta: meta,
      records: render_many(records, __MODULE__, "show.json", as: :grade)
    }
  end

  def render("show.json", %{grade: grade}) do
    %{
      id: grade.id,
      title: grade.title,
      description: grade.description,
      syllabus_provider_id: grade.syllabus_provider_id
    }
  end
end
