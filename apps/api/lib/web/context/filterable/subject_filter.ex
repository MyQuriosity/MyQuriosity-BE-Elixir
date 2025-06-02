defmodule Api.Filterable.SubjectFilter do
  @moduledoc """
    A dynamic filtering module for the `Subject` schema using `FatEcto.Query.Dynamics.Buildable`.
  """

  import Ecto.Query

  use FatEcto.Query.Dynamics.Buildable,
    filterable: [
      title: "$ILIKE",
      course_code: "$ILIKE",
      color: "$ILIKE",
      grade_id: "$EQUAL",
      id: "$EQUAL",
      inserted_at: "*"
    ],
    overrideable: ["syllabus_provider_id"],
    ignoreable: [
      title: ["%%", nil],
      couse_code: ["", nil],
      syllabus_provider_id: ["", nil],
      color: ["", nil],
      grade_id: ["", nil],
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

  def override_buildable(_field, _operator, _value), do: nil
end
