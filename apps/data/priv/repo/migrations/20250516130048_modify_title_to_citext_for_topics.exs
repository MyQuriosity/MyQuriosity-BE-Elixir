defmodule Data.Repo.Migrations.AddUniqueTitleConstraintToTopics do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      modify :title, :citext
    end
  end
end
