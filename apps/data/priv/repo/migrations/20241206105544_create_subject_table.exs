defmodule Data.Repo.Migrations.CreateSubjectTableForQuizGenerator do
  use Ecto.Migration

  def change do
    create table(:subjects, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)
      add(:course_code, :string)
      add(:color, :string)
      add(:deactivated_at, :utc_datetime)
      add(:grade_id, references(:grades, column: :id, type: :uuid))

      timestamps()
    end

    create unique_index(:subjects, [:title, :grade_id],
             name: :unique_subjects_grade_index,
             where: "deactivated_at IS NULL"

           )
  end
end
