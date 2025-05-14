defmodule Data.Repo.Migrations.CreateChaptersTableForWeb do
  use Ecto.Migration

  def change do
    create table(:chapters, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)
      add(:description, :string)
      add(:deactivated_at, :utc_datetime)
      add(:number, :integer)
      add(:subject_id, references(:subjects, column: :id, type: :uuid))

      timestamps()
    end

    create unique_index(:chapters, [:title, :subject_id],
             name: :unique_chapters_subject_index,
             where: "deactivated_at IS NULL"
           )
  end
end
