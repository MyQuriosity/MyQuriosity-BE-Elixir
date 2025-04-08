defmodule QuizGeneratorWeb.Filterable.QuizFilter do
  @moduledoc """
    A dynamic filtering module for the `Quiz` schema using `FatEcto.Dynamics.FatBuildable`.
  """

  import Ecto.Query

  use FatEcto.Dynamics.FatBuildable,
    filterable_fields: %{
      "title" => "$ILIKE",
      "topic_id" => "$EQUAL",
      "id" => "$EQUAL"
    },
    overrideable_fields: [
      "syllabus_provider_id",
      "grade_id",
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

  @impl true
  def after_whereable(dynamics) do
    if dynamics, do: dynamics, else: true
  end

  @impl true
  def override_whereable(_dynamics, "syllabus_provider_id", "$EQUAL", value) do
    dynamic([syllabus_provider: syllabus_provider], syllabus_provider.id == ^value)
  end

  def override_whereable(_dynamics, "grade_id", "$EQUAL", value) do
    dynamic([grade: grade], grade.id == ^value)
  end

  def override_whereable(_dynamics, "subject_id", "$EQUAL", value) do
    dynamic([subject: subject], subject.id == ^value)
  end

  def override_whereable(_dynamics, "chapter_id", "$EQUAL", value) do
    dynamic([chapter: chapter], chapter.id == ^value)
  end

  def override_whereable(_dynamics, "topic_title", "$ILIKE", value) do
    dynamic([topic: topic], ilike(fragment("(?)::TEXT", topic.title), ^value))
  end

  def override_whereable(dynamics, _field, _operator, _value), do: dynamics
end
