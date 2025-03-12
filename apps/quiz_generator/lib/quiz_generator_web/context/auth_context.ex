defmodule QuizGenerator.AuthContext do
  @moduledoc """
  This context is used to signup the institute
  """
  # import Ecto.Query
  alias QuizGenerator.EmailUtils
  # alias QuizGenerator.Repo
  # alias Data.TenantInformation
  alias QuizGenerator.User
  alias QuizGenerator.UserContext
  # alias Ecto.Multi
  # alias TeamTenantApi.TenantInfoContext
  # alias QuizGenerator.UserContext

  require Logger

  # @sub_domain_reserve_keywords [
  #   "dev",
  #   "dev1",
  #   "dev2",
  #   "dev3",
  #   "development",
  #   "stage",
  #   "staging",
  #   "stagging",
  #   "prod",
  #   "production",
  #   "test",
  #   "testing",
  #   "official",
  #   "regbits",
  #   "myquriosity",
  #   "admin",
  #   "api",
  #   "logs",
  #   "app",
  #   "application",
  #   "www",
  #   "http",
  #   "https",
  #   "test",
  #   "debug",
  #   "mock"
  # ]

  @doc """
  This function is used to verify the token and then update the user
  """
  @spec verify_and_update_user(String.t()) :: {:ok, User.t()} | {:error, any()}
  def verify_and_update_user(token) do
    token
    |> UserContext.get_user_by_token()
    |> do_update_user()
  end

  defp do_update_user(nil), do: {:error, "Invalid token"}

  defp do_update_user(%User{email_verified_at: nil} = user) do
    email_verified_at = DateTime.utc_now()
    params = %{"email_verified_at" => email_verified_at, "email_verify_token" => ""}
    UserContext.update(user, params)
  end

  defp do_update_user(_),
    do: {:error, "This email is already registered. Please try to login."}

  @doc """
  This function is used to send email for verify user's email
  """
  @spec send_email_verification(User.t(), String.t()) ::
          {:error, String.t()} | {:ok, :email_sent}
  def send_email_verification(user, url) do
    email_verify_token = generate_token(48)

    user
    |> UserContext.update(%{"email_verify_token" => email_verify_token})
    |> case do
      {:ok, user} ->
        do_send_email_verification(user, email_verify_token, url)

      {:error, error} ->
        Logger.info("[send_email_verification], user changeset error: #{error}")
        {:error, error}
    end
  end

  def setup_password(user, params) do
    UserContext.update_password(user, params)
  end

  defp do_send_email_verification(
         %User{email: email} = user,
         email_verify_token,
         url
       ) do
    email_verify_token
    |> build_new_email_link(email, url)
    |> set_email_params(email, "Email Verification")
    |> EmailUtils.send_email_verification(user)
    |> case do
      {:ok, _email} ->
        {:ok, :email_sent}

      {:error, %Bamboo.ApiError{message: message}} ->
        Logger.info("[send_email_verification], Bamboo error: #{message}")
        {:error, "Unable to send. Please check your given email."}
    end
  end

  defp build_new_email_link(token, email, url) do
    "#{url}/quiz/complete-registration?token=#{token}&email=#{email}"
  end

  defp set_email_params(redirect_path, email, subject) do
    Map.new()
    |> Map.put("to", email)
    |> Map.put("subject", subject)
    |> Map.put("redirect_path", redirect_path)
  end

  # @doc """
  # This function is used to re-send email verification
  # """
  # @spec resend_email_verification(String.t(), String.t()) ::
  #         {:error, String.t()} | {:ok, Bamboo.Email.t()}
  # def resend_email_verification(email, url) do
  #   user =
  #     email
  #     |> String.downcase()
  #     |> UserContext.get_user_by_email()

  #   cond do
  #     is_nil(user) ->
  #       {:error, "This email is not registered. Please sign up first."}

  #     not is_nil(user.email_verified_at) ->
  #       {:error, "This email is already registered. Please try to login."}

  #     true ->
  #       do_resend_email_verification(user, url)
  #   end
  # end

  # defp do_resend_email_verification(user, url) do
  #   case TenantInfoContext.get_tenant_info_by_inserted_by(user.id) do
  #     nil ->
  #       {:error, "Tenant information does not exist against this email."}

  #     tenant_info ->
  #       send_email_verification(user, tenant_info.institute_name, url)
  #   end
  # end

  defp generate_token(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
  end
end
