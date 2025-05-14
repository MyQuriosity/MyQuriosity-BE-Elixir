defmodule Web.GradeView do
  use MyQuriosityWeb, :view

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
      syllabus_provider_id: grade.syllabus_provider_id,
      syllabus_provider:
        (Ecto.assoc_loaded?(grade.syllabus_provider) &&
           render_one(grade.syllabus_provider, Web.SyllabusProviderView, "show.json",
             as: :syllabus_provider
           )) || nil
    }
  end
end
