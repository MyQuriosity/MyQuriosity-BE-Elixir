defmodule QuizGenerator.Repo.Migrations.AddQuizGeneratorUserRoleEntites do
  use Ecto.Migration

  def change do
    create table(:users_roles_entities, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:user_id, references(:users, column: :id, type: :uuid), null: false)
      add(:deactivated_at, :utc_datetime)
      add(:role_id, references(:roles, column: :id, type: :string), null: false)
    end

    create_if_not_exists unique_index(:users_roles_entities, [:user_id, :role_id],
                           name: :unique_role_per_user,
                           where: "deactivated_at IS NULL"
                         )
  end
end
