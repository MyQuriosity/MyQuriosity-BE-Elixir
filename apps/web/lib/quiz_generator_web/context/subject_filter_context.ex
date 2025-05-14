defmodule Web.SubjectFilterContext do
  @moduledoc """
  This module provides context functions for filtering Subject.
  """

  alias Web.Subject
  alias Web.Filterable.SubjectFilter

  import Ecto.Query

  @spec filtered_query(map()) :: Ecto.Query.t()
  def filtered_query(params) do
    dynamics = SubjectFilter.build(params)

    query =
      Subject
      |> preload(grade: :syllabus_provider)
      |> join(:inner, [q], g in Web.Grade, on: g.id == q.grade_id, as: :grade)
      |> join(:inner, [q, g], sp in Web.SyllabusProvider,
        on: sp.id == g.syllabus_provider_id,
        as: :syllabus_provider
      )

    where(query, ^dynamics)
  end
end
