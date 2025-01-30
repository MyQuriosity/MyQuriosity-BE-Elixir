defmodule TenantData.Repo.Migrations.CreateUserNotificationsTable do
  use Ecto.Migration

  def change do
    create table(:user_notifications, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:notification_id, references(:notifications, column: :id, type: :uuid))
      add(:user_id, references(:users, column: :id, type: :uuid))
      add(:user_role_id, references(:roles, column: :id, type: :string))
      add(:title, :string)
      add(:body, :string)
      add(:status, :string)

      timestamps()
    end
  end
end
