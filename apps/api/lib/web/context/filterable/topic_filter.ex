defmodule Api.Filterable.TopicFilter do
  @moduledoc """
    A dynamic filtering module for the `Topic` schema using `FatEcto.Query.Dynamics.Buildable`.
  """

  import Ecto.Query

  use FatEcto.Query.Dynamics.Buildable,
    filterable: [
      title: "*",
      number: "$EQUAL",
      id: "$EQUAL",
      chapter_id: "$EQUAL",
      inserted_at: "*"
    ],
    overrideable: ["syllabus_provider_id", "grade_id", "subject_id"],
    ignoreable: [
      title: ["%%", nil],
      syllabus_provider_id: ["", nil],
      grade_id: ["", nil],
      subject_id: ["", nil],
      inserted_at: ["", nil],
      id: ["", nil],
      number: ["", nil],
      chapter_id: ["", nil]
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

  def override_buildable(_field, _operator, _value), do: nil
end
