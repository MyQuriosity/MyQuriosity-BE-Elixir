defmodule Data.Repo.Migrations.ModifyTitleToCitextForSyllabusProviders do
  use Ecto.Migration

  def change do
    alter table(:syllabus_providers) do
      modify :title, :citext
    end
  end
end
