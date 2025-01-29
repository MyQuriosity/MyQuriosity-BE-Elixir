defmodule Data.Repo.Migrations.CreateGradeTableForQuizGenerator do
  use Ecto.Migration

  def change do
    create table(:grades, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)
      add(:description, :string)
      add(:deactivated_at, :utc_datetime)
      add(:syllabus_provider_id, references(:syllabus_providers, column: :id, type: :uuid))

      timestamps()
    end

    create unique_index(:grades, [:title, :syllabus_provider_id],
             name: :unique_grades_syllabus_provider_index,
             where: "deactivated_at IS NULL"
           )
  end
end
