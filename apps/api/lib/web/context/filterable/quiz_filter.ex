defmodule Api.Filterable.QuestionFilter do
  @moduledoc """
    A dynamic filtering module for the `Quiz` schema using `FatEcto.Query.Dynamics.Buildable`.
  """

  import Ecto.Query

  use FatEcto.Query.Dynamics.Buildable,
    filterable: [
      title: "$ILIKE",
      topic_id: "$EQUAL",
      inserted_at: "*",
      id: "$EQUAL"
    ],
    overrideable: [
      "syllabus_provider_id",
      "grade_id",
      "subject_id",
      "chapter_id",
      "topic_title"
    ],
    ignoreable: [
      title: ["%%", nil],
      topic_title: ["%%", nil],
      topic_id: ["", nil],
      subject_id: ["", nil],
      chapter_id: ["", nil],
      inserted_at: ["", nil],
      id: ["", nil]
    ]

  @impl true
  def after_buildable(dynamics) do
    if dynamics, do: dynamics, else: true
  end

  @impl true
  def override_buildable("syllabus_provider_id", "$EQUAL", value) do
    dynamic([syllabus_provider: syllabus_provider], syllabus_provider.id == ^value)
  end

  def override_buildable("grade_id", "$EQUAL", value) do
    dynamic([grade: grade], grade.id == ^value)
  end

  def override_buildable("subject_id", "$EQUAL", value) do
    dynamic([subject: subject], subject.id == ^value)
  end

  def override_buildable("chapter_id", "$EQUAL", value) do
    dynamic([chapter: chapter], chapter.id == ^value)
  end

  def override_buildable("topic_title", "$ILIKE", value) do
    dynamic([topic: topic], ilike(fragment("(?)::TEXT", topic.title), ^value))
  end

  def override_buildable(_field, _operator, _value), do: nil
end
