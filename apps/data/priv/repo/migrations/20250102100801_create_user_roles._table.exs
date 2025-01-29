defmodule Data.Repo.Migrations.AddQuizGeneratorUserRoles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add(:id, :string, primary_key: true)
      add(:is_active, :boolean, null: false, default: true)
      add(:description, :string, null: false)
    end
  end
end
