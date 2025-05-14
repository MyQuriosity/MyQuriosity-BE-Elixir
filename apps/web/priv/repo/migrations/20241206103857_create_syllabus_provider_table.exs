defmodule Web.Repo.Migrations.CreateSyllabusProviderTableForQuestionBank do
  use Ecto.Migration

  def change do
    create table(:syllabus_providers, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)
      add(:description, :string)
      add(:deactivated_at, :utc_datetime)

      timestamps()
    end
  end
end
