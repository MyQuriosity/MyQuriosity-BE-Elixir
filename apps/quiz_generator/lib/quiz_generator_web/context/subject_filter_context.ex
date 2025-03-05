defmodule QuizGenerator.SubjectFilterContext do
  @moduledoc """
  This module provides context functions for filtering Subject.
  """

  alias QuizGenerator.Subject
  alias QuizGeneratorWeb.Filterable.SubjectFilter

  import Ecto.Query

  @spec filtered_query(map()) :: Ecto.Query.t()
  def filtered_query(params) do
    IO.inspect(params)
    dynamics = SubjectFilter.build(params)

    query =
      Subject
      |> preload(grade: :syllabus_provider)
      |> join(:inner, [q], g in QuizGenerator.Grade, on: g.id == q.grade_id, as: :grade)
      |> join(:inner, [q, g], sp in QuizGenerator.SyllabusProvider,
        on: sp.id == g.syllabus_provider_id,
        as: :syllabus_provider
      )

    where(query, ^dynamics)
  end
end
