defmodule QuizGeneratorWeb.Filterable.QuizFilter do
  use FatEcto.FatQuery.Whereable,
    filterable_fields: %{
      "title" => "$ilike",
      "topic_id" => "$equal",
      "id" => "$equal"
    },
    overrideable_fields: [
      "subject_id",
      "chapter_id",
      "topic_title",
      "inserted_at"
    ],
    ignoreable_fields_values: %{
      "title" => ["%%", nil],
      "topic_title" => ["%%", nil],
      "topic_id" => ["", nil],
      "subject_id" => ["", nil],
      "chapter_id" => ["", nil],
      "inserted_at" => ["", nil],
      "id" => ["", nil]
    }

  import Ecto.Query

  def override_whereable(query, "topic_title", "$ilike", value) when is_binary(value) do
    query
    |> join(:inner, [q], t in QuizGenerator.Topic, on: t.id == q.topic_id, as: :topic)
    |> where([q, t], ilike(t.title, ^"%#{value}%"))
  end

  # def override_whereable(query, "chapter_id", "$equal", value) when is_binary(value) do
  #   query
  #   |> join(:inner, [q], t in QuizGenerator.Topic, on: t.id == q.topic_id, as: :topic)
  #   |> join(:inner, [q, t], ch in QuizGenerator.Chapter, on: ch.id == t.chapter_id, as: :chapter)
  #   |> where([q, t, ch], ch.id == ^value)
  # end

  def override_whereable(query, "subject_id", "$equal", value) do
    query
    |> join(:inner, [q], t in QuizGenerator.Topic, on: t.id == q.topic_id, as: :topic)
    |> join(:inner, [q, t], ch in QuizGenerator.Chapter, on: ch.id == t.chapter_id, as: :chapter)
    |> join(:inner, [q, t, ch], s in QuizGenerator.Subject,
      on: s.id == ch.subject_id,
      as: :subject
    )
    |> where([q, t, ch, s], s.id == ^value)
  end

  def override_whereable(query, "inserted_at", "$equal", value) do
    {:ok, date} = Date.from_iso8601(value)
    where(query, [q], fragment("?::date", q.inserted_at) == ^date)
  end

  def override_whereable(query, _, _, _), do: query
end
