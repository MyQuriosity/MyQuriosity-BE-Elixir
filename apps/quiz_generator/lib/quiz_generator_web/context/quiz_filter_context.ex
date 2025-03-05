defmodule QuizGenerator.QuizFilterContext do
  @moduledoc """
  This module provides context functions for filtering Multiple Choice Questions (MCQs).
  """
  import Ecto.Query

  alias QuizGenerator.Quiz
  alias QuizGeneratorWeb.Filterable.QuizFilter

  def filtered_query(params) do
    dynamics = QuizFilter.build(params)

    query =
      Quiz
      |> preload([:topic, questions: :options])
      |> join(:inner, [q], t in QuizGenerator.Topic, on: t.id == q.topic_id, as: :topic)
      |> join(:inner, [q, t], ch in QuizGenerator.Chapter,
        on: ch.id == t.chapter_id,
        as: :chapter
      )
      |> join(:inner, [q, t, ch], s in QuizGenerator.Subject,
        on: s.id == ch.subject_id,
        as: :subject
      )
      |> join(:inner, [_q, _t, _c, s], g in QuizGenerator.Grade,
        on: g.id == s.grade_id,
        as: :grade
      )
      |> join(:inner, [_q, _t, _c, _s, g], sp in QuizGenerator.SyllabusProvider,
        on: sp.id == g.syllabus_provider_id,
        as: :syllabus_provider
      )

    where(query, ^dynamics)
  end
end
