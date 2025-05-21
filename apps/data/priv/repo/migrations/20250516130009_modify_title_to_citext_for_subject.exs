defmodule Data.Repo.Migrations.AddUniqueTitleConstraintToSubject do
  use Ecto.Migration

  def change do
    alter table(:subjects) do
      modify :title, :citext
    end
  end
end
