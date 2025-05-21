defmodule Api.QuestionFilterContext do
  @moduledoc """
  This module provides context functions for filtering Multiple Choice Questions (MCQs).
  """
  import Ecto.Query

  alias Api.Filterable.QuestionFilter
  alias Data.Question

  def filtered_query(params) do
    dynamics = QuestionFilter.build(params)

    query =
      Question
      |> preload(options: ^ordered_options_subquery())
      |> join(:left, [q], o in Data.Option, on: q.id == o.question_id, as: :option)
      |> join(:inner, [q, o], t in Data.Topic, on: t.id == q.topic_id, as: :topic)
      |> join(:inner, [q, o, t], ch in Data.Chapter,
        on: ch.id == t.chapter_id,
        as: :chapter
      )
      |> join(:inner, [q, o, t, ch], s in Data.Subject,
        on: s.id == ch.subject_id,
        as: :subject
      )
      |> join(:inner, [_q, _o, _t, _c, s], g in Data.Grade,
        on: g.id == s.grade_id,
        as: :grade
      )
      |> join(:inner, [_q, _o, _t, _c, _s, g], sp in Data.SyllabusProvider,
        on: sp.id == g.syllabus_provider_id,
        as: :syllabus_provider
      )
      |> preload([:options, topic: [chapter: [subject: :grade]]])
      |> distinct(true)

    where(query, ^dynamics)
  end

  defp ordered_options_subquery do
    from o in Data.Option,
      order_by: [asc: o.key]
  end
end
