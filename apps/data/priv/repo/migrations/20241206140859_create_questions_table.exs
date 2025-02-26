defmodule QuizGenerator.Repo.Migrations.CreateQuestionsTableForQuizGenerator do
  use Ecto.Migration

  def change do
    create table(:questions, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)
      add(:quiz_id, references(:quizzes, column: :id, type: :uuid))

      timestamps()
    end
  end
end
