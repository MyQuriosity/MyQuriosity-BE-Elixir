defmodule Data.Repo.Migrations.ModifyTitleToCitextForUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :email, :citext
    end
  end
end
