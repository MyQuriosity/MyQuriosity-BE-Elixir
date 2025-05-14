defmodule Api.OtpUtils do
  @moduledoc """
    This module containts methods to deal with otp codes
  """

  alias Api.EmailUtils
  alias Api.Utils.Email.NotificationPayload
  alias Data.User

  @default_char_list [1, 2, 3, 4, 5, 6, 7, 8, 9]
  @medium_email "email"
  @doc """
   send otp either for password_setup/password_reset through email
  """
  @spec send_otp(String.t(), User.t(), String.t(), map(), String.t()) ::
          {:error, any} | {:ok, :sent}
  def send_otp(otp, user, url, %{"medium" => @medium_email} = params, action) do
    user
    |> NotificationPayload.notification_payload(otp, url, params, action)
    |> EmailUtils.send_email(action)
    |> case do
      {:ok, _} ->
        {:ok, :sent}

      {:error, %Bamboo.ApiError{message: message} = error} ->
        if String.contains?(message, "Maximum credits exceeded") do
          {:error, "Unable to send email, maximum limit is reached."}
        else
          {:error, error}
        end

      error ->
        error
    end
  end

  @spec generate_otp(list()) :: String.t()
  def generate_otp(options \\ []) do
    char_array = if options[:char_array], do: options[:char_array], else: @default_char_list
    length = if options[:length], do: options[:length], else: 6

    char_array
    |> Enum.take_random(length)
    |> Enum.join()
  end
end
