defmodule QuizGeneratorWeb.NotificationController do
  @moduledoc """
  Handles retrieving of Notification for a user, for the given role,
  also for marking the status for notification, single or in bulk
  """
  use QuizGeneratorWeb, :controller

  alias QuizGenerator.HeaderUtils
  alias QuizGenerator.NotificationContext

  @doc """
  Dedicated function to just get list of all Notification.

  We also update the user's `last_seen_at` field, which is sent
  to the view, where it is used to split the notification into new and old
  """
  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    with {:ok, user_id} <- HeaderUtils.get_current_user_id(conn),
         {:ok, notifications} <-
           {:ok, NotificationContext.get_user_notifications(params, user_id)},
         {:ok, unread_count} <- {:ok, NotificationContext.get_user_unread_notify_count(user_id)},
         {:ok, total_count} <- {:ok, NotificationContext.get_all_count(user_id)},
         {:ok, last_seen_at} <- {:ok, NotificationContext.get_user_last_seen_at(user_id)},
         {:ok, _} <- NotificationContext.update_last_seen_at(user_id) do
      render(conn, "notification_details.json", %{
        notifications: notifications,
        last_seen_at: last_seen_at,
        unread_count: unread_count,
        total_count: total_count
      })
    end
  end

  @doc """
  This function marks read or unread notifications
  """
  @spec mark_read(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def mark_read(
        conn,
        %{"notification_ids" => notification_ids} = _params
      ) do
    with {:ok, user_id} <- HeaderUtils.get_current_user_id(conn),
         {:ok, :updated} <-
           NotificationContext.mark_notification_read(notification_ids, user_id) do
      render(conn, "success.json", message: "Notification status updated")
    end
  end
end
