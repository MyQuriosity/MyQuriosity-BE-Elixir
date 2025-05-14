defmodule Api.ChapterFilterContext do
  @moduledoc """
  This module provides context functions for filtering Chapter.
  """

  alias Api.Chapter
  alias Api.Filterable.ChapterFilter

  import Ecto.Query

  @spec filtered_query(map()) :: Ecto.Query.t()
  def filtered_query(params) do
    dynamic = ChapterFilter.build(params)

    query =
      Chapter
      |> preload(subject: [grade: :syllabus_provider])
      |> join(:inner, [c], s in Api.Subject, on: s.id == c.subject_id, as: :subject)
      |> join(:inner, [c, s], g in Api.Grade, on: g.id == s.grade_id, as: :grade)
      |> join(:inner, [c, s, g], sp in Api.SyllabusProvider,
        on: sp.id == g.syllabus_provider_id,
        as: :syllabus_provider
      )

    where(query, ^dynamic)
  end
end
