defmodule Api.Filterable.SyllabusProviderFilter do
  @moduledoc """
    A dynamic filtering module for the `Syllabus Provider` schema using `FatEcto.Query.Dynamics.Buildable`.
  """
  use FatEcto.Query.Dynamics.Buildable,
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
  def after_buildable(dynamics) do
    if dynamics, do: dynamics, else: true
  end
end
