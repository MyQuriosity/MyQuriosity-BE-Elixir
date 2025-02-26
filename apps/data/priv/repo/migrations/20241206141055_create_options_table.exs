defmodule QuizGenerator.Repo.Migrations.CreateOptionsTableForQuestios do
  use Ecto.Migration

  def change do
    create table(:options, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)
      add(:is_correct, :boolean)
      add(:question_id, references(:questions, column: :id, type: :uuid))
      timestamps()
    end
  end
end
