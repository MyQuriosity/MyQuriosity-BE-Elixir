defmodule Api.TopicFilterContext do
  @moduledoc """
  This module provides context functions for filtering Syllabus Provider.
  """

  alias Api.Filterable.TopicFilter
  alias Data.Topic

  import Ecto.Query

  @spec filtered_query(map()) :: Ecto.Query.t()
  def filtered_query(params) do
    dynamic = TopicFilter.build(params)

    query =
      Topic
      |> preload(chapter: [subject: [grade: :syllabus_provider]])
      |> join(:inner, [t], c in Data.Chapter, on: c.id == t.chapter_id, as: :chapter)
      |> join(:inner, [_t, c], s in Data.Subject, on: s.id == c.subject_id, as: :subject)
      |> join(:inner, [_t, _c, s], g in Data.Grade, on: g.id == s.grade_id, as: :grade)
      |> join(:inner, [_t, _c, _s, g], sp in Data.SyllabusProvider,
        on: sp.id == g.syllabus_provider_id,
        as: :syllabus_provider
      )

    where(query, ^dynamic)
  end
end
