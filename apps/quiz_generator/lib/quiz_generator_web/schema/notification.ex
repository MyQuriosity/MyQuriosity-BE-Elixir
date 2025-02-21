defmodule QuizGenerator.Notification do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  use QuizGeneratorWeb, :model
  use Core.Macros.PK

  @type t :: %__MODULE__{}
  schema "notifications" do
    field(:entity_id, :string)
    field(:entity_type, :string)
    field(:worker_module, :string)
    field(:status, :string)

    belongs_to(:role, Acl.Role, foreign_key: :actor_role_id, references: :id, type: :string)
    belongs_to(:actor, QuizGenerator.User)

    belongs_to(:scheduled_notification_trigger, TenantData.ScheduledNotificationTrigger,
      foreign_key: :scheduled_notification_trigger_id,
      references: :id
    )

    belongs_to(:instant_notification_trigger, TenantData.InstantNotificationTrigger,
      foreign_key: :instant_notification_trigger_id,
      references: :id
    )

    has_many(:user_notifications, QuizGenerator.UserNotification, references: :id)
    has_many(:external_notification_receivers, TenantData.NotificationReceiver, references: :id)

    timestamps()
  end

  @spec changeset(notifications | changeset, params) :: changeset
        when notifications: t(),
             changeset: Ecto.Changeset.t(),
             params: map()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :actor_id,
      :actor_role_id,
      :entity_id,
      :entity_type,
      :worker_module,
      :status,
      :instant_notification_trigger_id,
      :scheduled_notification_trigger_id
    ])
    |> foreign_key_constraint(:actor_id)
    |> foreign_key_constraint(:actor_role_id)
    |> foreign_key_constraint(:instant_notification_trigger_id)
    |> foreign_key_constraint(:scheduled_notification_trigger_id)
  end
end
