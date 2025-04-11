defmodule QuizGenerator.Repo.Migrations.CreateOptionsTableForQuestios do
  use Ecto.Migration

  def change do
    create table(:options, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)
      add(:is_correct, :boolean)
      add(:question_id, references(:questions, column: :id, type: :uuid))
      add(:deactivated_at, :utc_datetime)
      timestamps()
    end

    create unique_index(:options, [:title, :question_id],
             name: :unique_title_questions_index,
             where: "deactivated_at IS NULL"
           )
  end
end
