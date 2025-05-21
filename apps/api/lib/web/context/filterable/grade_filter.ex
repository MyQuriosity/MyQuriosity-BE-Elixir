defmodule Api.Filterable.GradeFilter do
  @moduledoc """
    A dynamic filtering module for the `Grade` schema using `FatEcto.Builder.FatDynamicsBuildable`.
  """

  use FatEcto.Builder.FatDynamicsBuildable,
    filterable: [
      title: "$ILIKE",
      syllabus_provider_id: "$EQUAL",
      id: "$EQUAL",
      inserted_at: "*"
    ],
    overrideable: [],
    ignoreable: [
      title: ["%%", nil],
      syllabus_provider_id: ["", nil],
      inserted_at: ["", nil],
      id: ["", nil]
    ]

  @impl true
  def after_whereable(dynamics) do
    if dynamics, do: dynamics, else: true
  end
end
