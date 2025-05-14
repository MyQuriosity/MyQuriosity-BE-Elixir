defmodule Web.Filterable.SubjectFilter do
  @moduledoc """
    A dynamic filtering module for the `Subject` schema using `FatEcto.Dynamics.FatBuildable`.
  """

  import Ecto.Query

  use FatEcto.Dynamics.FatBuildable,
    filterable_fields: %{
      "title" => "$ILIKE",
      "course_code" => "$ILIKE",
      "color" => "$ILIKE",
      "grade_id" => "$EQUAL",
      "id" => "$EQUAL",
      "inserted_at" => "*"
    },
    overrideable_fields: ["syllabus_provider_id"],
    ignoreable_fields_values: %{
      "title" => ["%%", nil],
      "couse_code" => ["", nil],
      "syllabus_provider_id" => ["", nil],
      "color" => ["", nil],
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

  def override_whereable(dynamics, _field, _operator, _value), do: dynamics
end
