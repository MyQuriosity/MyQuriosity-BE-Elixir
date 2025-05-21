defmodule Api.Filterable.SyllabusProviderFilter do
  @moduledoc """
    A dynamic filtering module for the `Syllabus Provider` schema using `FatEcto.Builder.FatDynamicsBuildable`.
  """
  use FatEcto.Builder.FatDynamicsBuildable,
    filterable: [
      title: "$ILIKE",
      id: "$EQUAL",
      inserted_at: "*"
    ],
    overrideable: [],
    ignoreable: [
      title: ["%%", nil],
      inserted_at: ["", nil],
      id: ["", nil]
    ]

  @impl true
  def after_whereable(dynamics) do
    if dynamics, do: dynamics, else: true
  end
end
