defmodule Data.Repo.Migrations.ModifyTitleToCitextForOptions do
  use Ecto.Migration

  def change do
    alter table(:options) do
      modify :title, :citext
    end
  end
end
