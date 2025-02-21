defmodule QuizGeneratorWeb.Filterable.GradeFilter do
  use FatEcto.FatQuery.Whereable,
    filterable_fields: %{
      "title" => "$ilike",
      "syllabus_provider_id" => "$equal",
      "id" => "$equal"
    },
    overrideable_fields: [
      "inserted_at"
    ],
    ignoreable_fields_values: %{
      "title" => ["%%", nil],
      "syllabus_provider_id" => ["", nil],
      "inserted_at" => ["", nil],
      "id" => ["", nil]
    }

  import Ecto.Query

  def override_whereable(query, "inserted_at", "$equal", value) do
    {:ok, date} = Date.from_iso8601(value)
    where(query, [q], fragment("?::date", q.inserted_at) == ^date)
  end

  def override_whereable(query, _, _, _), do: query
end
