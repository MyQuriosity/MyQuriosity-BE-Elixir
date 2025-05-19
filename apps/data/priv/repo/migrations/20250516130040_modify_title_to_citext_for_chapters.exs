defmodule Data.Repo.Migrations.AddUniqueTitleConstraintToChapters do
  use Ecto.Migration

  def change do
    alter table(:chapters) do
      modify :title, :citext
    end
  end
end
