# defmodule QuizGenerator.UserNotification do
#   @moduledoc """
#   # TODO: Write proper moduledoc
#   """
#   use QuizGeneratorWeb, :model
#   use Core.Macros.PK

#   alias QuizGenerator.Constants.QuizGeneratorNotificationConstants
#   @unread_status QuizGeneratorNotificationConstants.encode(:unread_status)

#   @type t :: %__MODULE__{}
#   schema "user_notifications" do
#     field(:title, :string)
#     field(:body, :string)
#     field(:status, :string, default: @unread_status)
#     field(:redirect_path, :string)

#     belongs_to(:role, Acl.Role,
#       foreign_key: :user_role_id,
#       references: :id,
#       type: :string
#     )

#     belongs_to(:user, QuizGenerator.User, foreign_key: :user_id, references: :id)

#     belongs_to(:related_user, QuizGenerator.User,
#       foreign_key: :related_user_id,
#       references: :id
#     )

#     belongs_to(:notification, QuizGenerator.Notification)
#     field(:deactivated_at, :utc_datetime)

#     timestamps()
#   end

#   @spec changeset(user_notifications | changeset, params) :: changeset
#         when user_notifications: t(),
#              changeset: Ecto.Changeset.t(),
#              params: map()
#   def changeset(struct, params \\ %{}) do
#     struct
#     |> cast(params, [
#       :user_id,
#       :related_user_id,
#       :user_role_id,
#       :notification_id,
#       :title,
#       :body,
#       :status,
#       :redirect_path
#     ])
#     |> foreign_key_constraint(:user_id)
#     |> foreign_key_constraint(:related_user_id)
#     |> foreign_key_constraint(:notification_id)
#     |> foreign_key_constraint(:user_role_id)
#   end
# end
