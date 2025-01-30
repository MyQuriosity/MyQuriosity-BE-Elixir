defmodule Data.Repo.Migrations.CreateInstantNotificationTriggerTable do
  use Ecto.Migration

  def change do
    create table(:instant_notification_triggers, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:feature, :string)
      add(:action, :string)
      add(:send_to, :string)
      add(:first_priority_medium, :string)
      add(:second_priority_medium, :string)
      add(:send_all_mediums, :boolean)
      add(:in_app_notification_enabled, :boolean)
      add(:deactivated_at, :utc_datetime)

      add(:actor_id, references(:users, column: :id, type: :uuid))

      add(:actor_role_id, references(:roles, column: :id, type: :string), null: false)

      add(:receiver_id, references(:users, column: :id, type: :uuid))

      add(:receiver_role_id, references(:roles, column: :id, type: :string), null: false)

      add(:inserted_by_id, references(:users, column: :id, type: :uuid))
      add(:updated_by_id, references(:users, column: :id, type: :uuid))
      add(:deactivated_by_id, references(:users, column: :id, type: :uuid))
      timestamps()
    end
  end
end
