defmodule QuizGenerator.NotificationContext do
  @moduledoc """
  Handles notification Routes.
  """

  import Ecto.Query
  alias TenantData.Announcement
  alias TenantData.InstituteUser
  alias TenantData.Notification
  alias TenantData.Repo
  alias TenantData.UserNotification
  alias TenantData.Utils.PaginationUtils
  alias TenantNotifire.Constants.NotificationConstants
  alias TenantNotifire.Utils.SchemaUtils

  @status_unread NotificationConstants.encode(:status_unread)
  @status_read NotificationConstants.encode(:status_read)

  @doc """
  This function counts unread user notification. Including announements notifications
  """
  @spec get_user_unread_notify_count(String.t()) :: integer()
  def get_user_unread_notify_count(user_id) do
    query =
      from(un in UserNotification,
        where: un.user_id == ^user_id and un.status == @status_unread,
        select: count(un.id)
      )

    TenantData.QueryRepo.one(query)
  end

  @doc """
  Get a user's notifications, except for notifications generated by
  """
  @spec get_user_notifications(map() | nil, String.t()) :: [Notification.t()]
  def get_user_notifications(params, user_id) do
    query =
      from(un in UserNotification,
        join: n in Notification,
        on: un.notification_id == n.id,
        preload: [:related_user],
        where:
          n.entity_type != ^SchemaUtils.get_table_name_from_module(Announcement) and
            un.user_id == ^user_id and is_nil(un.deactivated_at),
        order_by: [desc: [un.inserted_at]],
        preload: :related_user
      )

    PaginationUtils.paginate_without_meta(query, params)
  end

  @doc """
  Get announcement for given user.

  For announcements, the parent `notification`, for `user_notification` will have
  `entity_type` of `announcements`
  """
  def get_user_announcements(params, user_id) do
    query =
      from(un in UserNotification,
        join: n in Notification,
        on: un.notification_id == n.id,
        preload: [:related_user],
        where:
          n.entity_type == ^SchemaUtils.get_table_name_from_module(Announcement) and
            un.user_id == ^user_id,
        order_by: [desc: [un.inserted_at]]
      )

    PaginationUtils.paginate_without_meta(query, params)
  end

  @doc """
  Given a list of notification ids, this function marks as read user notification

  Returns ok tuple, if records were updated, otherwise returns an error tuple
  """
  @spec mark_notification_read([String.t()], String.t()) :: {:ok, :updated}
  def mark_notification_read(notification_ids, user_id)
      when is_list(notification_ids) do
    query =
      from(un in UserNotification,
        where: un.id in ^notification_ids and un.user_id == ^user_id and is_nil(un.deactivated_at)
      )

    {updated_records_count, nil} =
      Repo.update_all(query, set: [status: @status_read])

    if updated_records_count > 0 do
      {:ok, :updated}
    else
      {:error, :not_found}
    end
  end

  def mark_notification_read(_), do: {:error, "Invalid input format"}

  @doc """
  This function returns the count of all notifications, belonging to the
  given user (identified by user_id)
  """
  @spec get_all_count(String.t()) :: non_neg_integer
  def get_all_count(user_id) do
    query =
      from(un in UserNotification,
        where: un.user_id == ^user_id,
        select: count(un)
      )

    TenantData.QueryRepo.one(query)
  end

  @doc """
  Updates user's last_seen_at field for notifications, updates it for
  """
  @spec update_last_seen_at(String.t()) :: {:ok, InstituteUser.t()} | {:error, Ecto.Changeset.t()}
  def update_last_seen_at(user_id) do
    time_right_now = DateTime.utc_now()

    InstituteUser
    |> Repo.get(user_id)
    |> InstituteUser.changeset(%{"last_seen_at" => time_right_now})
    |> Repo.update()
  end

  @doc """
  Returns the given user's (identified by user_id) last_seen_at field
  """
  @spec get_user_last_seen_at(String.t()) :: String.t()
  def get_user_last_seen_at(user_id) do
    Repo.get(InstituteUser, user_id).last_seen_at
  end
end
