defmodule QuizGenerator.Repo.Migrations.CreateQuestionsTableForQuizGenerator do
  use Ecto.Migration

  def change do
    create table(:questions, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)
      add(:topic_id, references(:topics, column: :id, type: :uuid))
      add(:deactivated_at, :utc_datetime)

      timestamps()
    end

    create unique_index(:questions, [:topic_id, :title],
    name: :unique_questions_topic_index,
    where: "deactivated_at IS NULL"
  )
  end
end
