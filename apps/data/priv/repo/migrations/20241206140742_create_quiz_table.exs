defmodule Data.Repo.Migrations.CreateQuizTable do
  use Ecto.Migration

  def change do
    create table(:quizzes, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)
      add(:deactivated_at, :utc_datetime)

      add(:topic_id, references(:topics, column: :id, type: :uuid))
      add(:inserted_by_id, references(:users, column: :id, type: :uuid))
      timestamps()
    end
  end
end
