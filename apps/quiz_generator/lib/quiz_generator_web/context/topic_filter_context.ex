defmodule QuizGenerator.TopicFilterContext do
  @moduledoc """
  This module provides context functions for filtering Syllabus Provider.
  """

  alias QuizGenerator.Topic
  alias QuizGeneratorWeb.Filterable.TopicFilter

  import Ecto.Query

  @spec filtered_query(map()) :: Ecto.Query.t()
  def filtered_query(params) do
    IO.inspect(params)
    dynamic = TopicFilter.build(params)

    query =
      Topic
      |> preload(chapter: [subject: [grade: :syllabus_provider]])
      |> join(:inner, [t], c in QuizGenerator.Chapter, on: c.id == t.chapter_id, as: :chapter)
      |> join(:inner, [_t, c], s in QuizGenerator.Subject, on: s.id == c.subject_id, as: :subject)
      |> join(:inner, [_t, _c, s], g in QuizGenerator.Grade, on: g.id == s.grade_id, as: :grade)
      |> join(:inner, [_t, _c, _s, g], sp in QuizGenerator.SyllabusProvider,
        on: sp.id == g.syllabus_provider_id,
        as: :syllabus_provider
      )

    IO.inspect(dynamic, label: "---dynamic--: ")
    where(query, ^dynamic)
  end
end
