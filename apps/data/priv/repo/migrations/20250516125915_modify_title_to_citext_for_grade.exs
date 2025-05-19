defmodule Data.Repo.Migrations.AddUniqueTitleConstraintToGrade do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext")

    alter table(:grades) do
      modify :title, :citext
    end
  end
end
