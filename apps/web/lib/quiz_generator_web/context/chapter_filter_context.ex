defmodule Web.ChapterFilterContext do
  @moduledoc """
  This module provides context functions for filtering Chapter.
  """

  alias Web.Chapter
  alias Web.Filterable.ChapterFilter

  import Ecto.Query

  @spec filtered_query(map()) :: Ecto.Query.t()
  def filtered_query(params) do
    dynamic = ChapterFilter.build(params)

    query =
      Chapter
      |> preload(subject: [grade: :syllabus_provider])
      |> join(:inner, [c], s in Web.Subject, on: s.id == c.subject_id, as: :subject)
      |> join(:inner, [c, s], g in Web.Grade, on: g.id == s.grade_id, as: :grade)
      |> join(:inner, [c, s, g], sp in Web.SyllabusProvider,
        on: sp.id == g.syllabus_provider_id,
        as: :syllabus_provider
      )

    where(query, ^dynamic)
  end
end
