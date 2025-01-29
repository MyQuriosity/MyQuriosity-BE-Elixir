defmodule Data.Repo.Migrations.CreateQuestionsTableForQuizGenerator do
  use Ecto.Migration

  def change do
    create table(:questions, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)
      add(:syllabus_provider_id, references(:syllabus_providers, column: :id, type: :uuid))
      add(:subject_id, references(:subjects, column: :id, type: :uuid))
      add(:chapter_id, references(:chapters, column: :id, type: :uuid))
      add(:topic_id, references(:topics, column: :id, type: :uuid))
      timestamps()
    end
  end
end
