defmodule Web.Utils.Email.NotificationPayload do
  @moduledoc """
  Utility module for generating email notification payloads related to user
  """

  alias Web.User

  @password_reset "password_reset"
  @password_setup "password_setup"

  @spec set_redirect_path(String.t(), String.t(), String.t(), String.t()) :: String.t()
  def set_redirect_path(email, otp, url, @password_setup = _action) do
    "#{url}/user/setup-password?otp=#{otp}&email=#{email}"
  end

  @spec set_redirect_path(String.t(), String.t(), String.t(), String.t()) ::
          String.t()
  def set_redirect_path(email, otp, url, @password_reset = _action) do
    "#{url}/quiz/user/reset-password?otp=#{otp}&email=#{email}"
  end

  @spec set_message_body(String.t(), String.t()) :: String.t()
  def set_message_body(redirect_path, @password_reset) do
    """
    We received a request to reset your password for your account at MyQuriosity. If you
    did not request this password reset, please ignore this message.
    To reset your password, please click on the following link: #{redirect_path}
    If you have any questions, please do not hesitate to contact us.
    Thank you
    """
  end

  def set_message_body(redirect_path, @password_setup) do
    """
    Congratulations, Your account has been created in MyQuriosity. please click
    on the following link: : #{redirect_path} to setup your password. If you have any questions,
    please do not hesitate to contact us.
    Thank you
    """
  end

  @spec notification_payload(User.t(), String.t(), String.t(), map(), String.t()) ::
          map()
  def notification_payload(
        %User{id: user_id, email: email} = _user,
        otp,
        url,
        %{"medium" => "email"},
        @password_reset = action
      ) do
    redirect_path = set_redirect_path(email, otp, url, action)

    Map.new()
    |> Map.put("to", email)
    |> Map.put("subject", "Password Reset Request")
    |> Map.put("redirect_path", redirect_path)
    |> Map.put("user_id", user_id)
  end

  def notification_payload(
        %User{id: user_id, email: email} = _user,
        otp,
        url,
        %{"medium" => "email"},
        @password_setup = action
      ) do
    redirect_path = set_redirect_path(email, otp, url, action)

    Map.new()
    |> Map.put("to", email)
    |> Map.put("subject", "Password Setup")
    |> Map.put("redirect_path", redirect_path)
    |> Map.put("user_id", user_id)
  end
end
