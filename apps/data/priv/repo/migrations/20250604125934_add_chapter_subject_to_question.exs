defmodule Data.Repo.Migrations.AddChapterSubjectToQuestion do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add(:chapter_id, references(:chapters, column: :id, type: :uuid))
      add(:subject_id, references(:subjects, column: :id, type: :uuid))
    end

    create unique_index(:questions, [:title, :topic_id],
             name: :unique_questions_topic_index,
             where: "deactivated_at IS NULL"
           )

    create unique_index(:questions, [:title, :chapter_id],
             name: :unique_questions_chapter_index,
             where: "deactivated_at IS NULL"
           )

    create unique_index(:questions, [:title, :subject_id],
             name: :unique_questions_subject_index,
             where: "deactivated_at IS NULL"
           )
  end
end
