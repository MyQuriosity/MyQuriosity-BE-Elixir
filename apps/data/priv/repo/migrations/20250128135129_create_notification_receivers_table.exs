defmodule TenantData.Repo.Migrations.CreateNotificationReceiversTable do
  use Ecto.Migration

  def change do
    create table("external_notification_receivers", primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:notification_id, references(:notifications, column: :id, type: :uuid))
      add(:receiver_id, references(:users, column: :id, type: :uuid))
      add(:receiver_role_id, references(:roles, column: :id, type: :string))
      add(:medium, :string)
      add(:title, :string)
      add(:body, :string)
      add(:status, :string)

      timestamps()
    end
  end
end
