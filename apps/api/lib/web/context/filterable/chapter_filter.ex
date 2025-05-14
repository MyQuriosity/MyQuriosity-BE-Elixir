defmodule Api.Filterable.ChapterFilter do
  @moduledoc """
    A dynamic filtering module for the `Chapter` schema using `FatEcto.Dynamics.FatBuildable`.
  """

  import Ecto.Query

  use FatEcto.Dynamics.FatBuildable,
    filterable_fields: %{
      "title" => "$ILIKE",
      "number" => "$EQUAL",
      "id" => "$EQUAL",
      "subject_id" => "$EQUAL",
      "inserted_at" => "*"
    },
    overrideable_fields: ["syllabus_provider_id", "grade_id"],
    ignoreable_fields_values: %{
      "title" => ["%%", nil],
      "subject_id" => ["", nil],
      "syllabus_provider_id" => ["", nil],
      "grade_id" => ["", nil],
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

  def override_whereable(dynamics, _field, _operator, _value), do: dynamics
end
