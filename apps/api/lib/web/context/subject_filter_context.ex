defmodule Api.SubjectFilterContext do
  @moduledoc """
  This module provides context functions for filtering Subject.
  """

  alias Api.Subject
  alias Api.Filterable.SubjectFilter

  import Ecto.Query

  @spec filtered_query(map()) :: Ecto.Query.t()
  def filtered_query(params) do
    dynamics = SubjectFilter.build(params)

    query =
      Subject
      |> preload(grade: :syllabus_provider)
      |> join(:inner, [q], g in Api.Grade, on: g.id == q.grade_id, as: :grade)
      |> join(:inner, [q, g], sp in Api.SyllabusProvider,
        on: sp.id == g.syllabus_provider_id,
        as: :syllabus_provider
      )

    where(query, ^dynamics)
  end
end
