defmodule Data.Repo.Migrations.CreateTopicsTableForQuizGenerator do
  use Ecto.Migration

  def change do
    create table(:topics, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)
      add(:description, :string)
      add(:deactivated_at, :utc_datetime)
      add(:chapter_id, references(:chapters, column: :id, type: :uuid))

      timestamps()
    end

    create unique_index(:topics, [:title, :chapter_id],
             name: :unique_topics_chapter_index,
             where: "deactivated_at IS NULL"

           )
  end
end
