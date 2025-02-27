defmodule QuizGeneratorWeb.Filterable.SubjectFilter do
  use FatEcto.FatQuery.Whereable,
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

    # @impl true
    # def override_whereable(dynamics, "syllabus_provider_id", "$EQUAL", value) do
    #   dynamics and dynamic([r], ilike(fragment("(?)::TEXT", r.name), ^value))
    # end

    # def override_whereable(dynamics, _, _), do: dynamics
end
