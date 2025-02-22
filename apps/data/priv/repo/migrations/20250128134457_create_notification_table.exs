defmodule Data.Repo.Migrations.CreateNotificationTable do
  use Ecto.Migration

  def change do
    create table(:notifications, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)
      add(:status, :string)
      add(:deactivated_at, :utc_datetime)

      add(:notifier_id, references(:users, column: :id, type: :uuid))
      add(:actor_id, references(:users, column: :id, type: :uuid))

      add(
        :scheduled_notification_trigger_id,
        references(:scheduled_notification_triggers, column: :id, type: :uuid)
      )

      add(
        :instant_notification_trigger_id,
        references(:instant_notification_triggers, column: :id, type: :uuid)
      )
      timestamps()
    end
  end
end
