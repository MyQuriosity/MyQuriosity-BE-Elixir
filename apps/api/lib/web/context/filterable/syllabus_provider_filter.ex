defmodule Api.Filterable.SyllabusProviderFilter do
  @moduledoc """
    A dynamic filtering module for the `Syllabus Provider` schema using `FatEcto.Dynamics.FatBuildable`.
  """
  use FatEcto.Dynamics.FatBuildable,
    filterable_fields: %{
      "title" => "$ILIKE",
      "id" => "$EQUAL",
      "inserted_at" => "*"
    },
    overrideable_fields: [],
    ignoreable_fields_values: %{
      "title" => ["%%", nil],
      "inserted_at" => ["", nil],
      "id" => ["", nil]
    }

  @impl true
  def after_whereable(dynamics) do
    if dynamics, do: dynamics, else: true
  end
end
