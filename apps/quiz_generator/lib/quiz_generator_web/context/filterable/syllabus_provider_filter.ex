defmodule QuizGeneratorWeb.Filterable.SyllabusProviderFilter do
  use FatEcto.FatQuery.Whereable,
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
end
