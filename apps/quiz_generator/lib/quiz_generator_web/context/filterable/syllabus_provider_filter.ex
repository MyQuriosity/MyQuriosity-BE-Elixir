defmodule QuizGeneratorWeb.Filterable.SyllabusProviderFilter do
  use FatEcto.FatQuery.Whereable,
    filterable_fields: %{
      "title" => "$ILIKE",
      "id" => "$EQUAL"
    },
    overrideable_fields: [
      "inserted_at"
    ],
    ignoreable_fields_values: %{
      "title" => ["%%", nil],
      "inserted_at" => ["", nil],
      "id" => ["", nil]
    }

  import Ecto.Query

  def override_whereable(_dynamics, "inserted_at", "$equal", value) do
    {:ok, date} = Date.from_iso8601(value)
    dynamic([q], fragment("?::date", q.inserted_at) == ^date)
  end

  def override_whereable(dynamics, _, _, _), do: dynamics
end
