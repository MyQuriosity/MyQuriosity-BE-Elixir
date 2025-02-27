defmodule QuizGeneratorWeb.Filterable.GradeFilter do
  use FatEcto.FatQuery.Whereable,
    filterable_fields: %{
      "title" => "$ILIKE",
      "syllabus_provider_id" => "$EQUAL",
      "id" => "$EQUAL",
      "inserted_at" => "*"
    },
    overrideable_fields: [],
    ignoreable_fields_values: %{
      "title" => ["%%", nil],
      "syllabus_provider_id" => ["", nil],
      "inserted_at" => ["", nil],
      "id" => ["", nil]
    }

end
