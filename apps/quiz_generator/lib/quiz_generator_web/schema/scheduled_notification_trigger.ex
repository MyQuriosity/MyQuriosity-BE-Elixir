# defmodule QuizGenerator.ScheduledNotificationTrigger do
#   @moduledoc """
#   Record of Notification Triggers.
#   """
#   use Ecto.Schema
#   use Core.Macros.PK
#   import Ecto.Changeset

#   alias TenantData.Constants.PickupNotificationConstants
#   # require Campus.CommonField
#   @feature_pickup_facility PickupNotificationConstants.encode(:feature_pickup_facility)
#   @pickup_actions PickupNotificationConstants.encode(:pickup_actions)

#   @type t :: %__MODULE__{}
#   schema "scheduled_notification_triggers" do
#     field(:feature, :string)
#     field(:action, :string)
#     field(:send_to, :string)
#     field(:notify_time, :time)
#     field(:sechduled_on, :string)
#     field(:schedule_unit, :string)
#     field(:schedule_quantity, :integer)
#     field(:first_priority_medium, :string)
#     field(:second_priority_medium, :string)
#     field(:send_all_mediums, :boolean)
#     field(:in_app_notification_enabled, :boolean)
#     field(:deactivated_at, :utc_datetime)

#     belongs_to(:actor, TenantData.InstituteUser, foreign_key: :actor_id, references: :id)

#     belongs_to(:actor_role, Acl.Role,
#       foreign_key: :actor_role_id,
#       references: :id,
#       type: :string
#     )

#     belongs_to(:receiver, QuizGenerator.User, foreign_key: :receiver_id, references: :id)

#     belongs_to(:receiver_role, QuizGenerator.Role,
#       foreign_key: :receiver_role_id,
#       references: :id,
#       type: :string
#     )

#     has_many(:notifications, QuizGenerator.Notification, references: :id)

#     # has_many(:excluded_receivers, TenantData.ExcludedNotificationReceiver,
#     #   references: :id,
#     #   on_replace: :delete_if_exists
#     # )

#     Campus.CommonField.relational_fields(QuizGenerator.User)

#     timestamps()
#   end

#   @spec changeset(notification_trigger | changeset, params) :: changeset
#         when notification_trigger: t(),
#              changeset: Ecto.Changeset.t(),
#              params: map()
#   def changeset(struct, params \\ %{}) do
#     struct
#     |> cast(params, [
#       :feature,
#       :action,
#       :send_to,
#       :notify_time,
#       :sechduled_on,
#       :schedule_unit,
#       :schedule_quantity,
#       :first_priority_medium,
#       :second_priority_medium,
#       :send_all_mediums,
#       :in_app_notification_enabled,
#       :deactivated_at,
#       :actor_id,
#       :actor_role_id,
#       :receiver_id,
#       :receiver_role_id,
#       :inserted_by_id,
#       :updated_by_id,
#       :deactivated_by_id
#     ])
#     |> validate_required([
#       :feature,
#       :action,
#       :actor_id,
#       :actor_role_id,
#       :first_priority_medium,
#       :second_priority_medium,
#       :send_to,
#       :in_app_notification_enabled
#     ])
#     |> validate_inclusion(:receiver_role_id, [
#       "section_admin",
#       "campus_admin",
#       "campus_moderator",
#       "section_moderator",
#       "staff",
#       "section_teacher",
#       "section_student",
#       "guardian",
#       "pickup_person"
#     ])
#     |> validate_inclusion(:send_to, [
#       "associated_guardians",
#       "associated_pickup_persons",
#       "main_guardian",
#       "main_pickup_person",
#       "concerned_student",
#       "staff",
#       "teacher"
#     ])
#     |> validate_inclusion(:feature, [
#       @feature_pickup_facility
#     ])
#     |> validate_inclusion(
#       :action,
#       List.flatten([
#         @pickup_actions
#       ])
#     )
#     |> validate_inclusion(:first_priority_medium, [
#       "sms",
#       "email"
#     ])
#     |> validate_inclusion(:second_priority_medium, [
#       "sms",
#       "email"
#     ])
#     |> validate_inclusion(:sechduled_on, [
#       "before",
#       "after"
#     ])
#     |> unique_constraint([:feature, :action, :send_to],
#       name: :feature_action_send_to_index,
#       message: "trigger setting already exist for this role"
#     )
#     |> unique_constraint([:feature, :action, :send_to, :receiver_id],
#       name: :feature_action_send_to_receiver_id_index,
#       message: "trigger setting already exist for this role and person"
#     )
#     |> unique_constraint([:feature, :action, :send_to, :campus_id],
#       name: :feature_action_send_to_campus_id_index,
#       message: "trigger setting already exist for this role in particular campus"
#     )
#     |> unique_constraint([:feature, :action, :send_to, :receiver_id, :campus_id],
#       name: :feature_action_send_to_receiver_id_campus_id_index,
#       message: "trigger setting already exist for this role and person in particular campus"
#     )
#     |> unique_constraint([:feature, :action, :send_to, :section_id],
#       name: :feature_action_send_to_section_id_index,
#       message: "trigger setting already exist for this role in particular section"
#     )
#     |> unique_constraint([:feature, :action, :send_to, :receiver_id, :section_id],
#       name: :feature_action_send_to_receiver_id_section_id_index,
#       message: "trigger setting already exist for this role and person in particular section"
#     )
#     |> cast_assoc(:excluded_receivers, with: &TenantData.ExcludedNotificationReceiver.changeset/2)
#   end
# end
