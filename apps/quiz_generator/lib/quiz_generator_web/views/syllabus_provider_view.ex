defmodule QuizGeneratorWeb.SyllabusProviderView do
  use QuizGeneratorWeb, :view

  def render("index.json", %{records: records, meta: meta}) do
    %{
      meta: meta,
      records: render_many(records, __MODULE__, "show.json", as: :syllabus_provider)
    }
  end

  def render("show.json", %{syllabus_provider: syllabus_provider}) do
    %{
      id: syllabus_provider.id,
      title: syllabus_provider.title,
      description: syllabus_provider.description
    }
  end
end
