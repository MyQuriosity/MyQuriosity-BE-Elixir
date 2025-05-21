defmodule Data.Repo.Migrations.AddUniqueTitleConstraintToSyllabusProviders do
  use Ecto.Migration

  def change do
    create unique_index(:syllabus_providers, [:title],
             name: :unique_syllabus_providers_title,
             where: "deactivated_at IS NULL"
           )
  end
end
