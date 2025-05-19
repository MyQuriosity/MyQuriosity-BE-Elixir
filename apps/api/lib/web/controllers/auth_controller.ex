defmodule Api.AuthController do
  use MyQuriosityWeb, :controller

  alias Api.AuthContext
  alias Api.Guardian
  alias Api.Guardian.Plug, as: GuardianPlug
  alias Api.HeaderUtils
  alias Api.OtpCodeContext
  alias Api.OtpUtils
  alias Api.SharedView
  alias Api.UserContext
  alias Api.Utils.Auth

  @spec login(Plug.Conn.t(), map) :: Plug.Conn.t()
  def login(
        conn,
        %{"email" => email, "password" => password, "remember_me" => remember_me} = _params
      ) do
    user_login(conn, email, password, remember_me)
  end

  def signup(conn, params) do
    with {:ok, user} <- UserContext.create_user(params),
         {:ok, url} <- get_url(conn),
         {:ok, :email_sent} <- AuthContext.send_email_verification(user, url) do
      render(conn, "signup.json", user: user)
    end
  end

  def resend_email(conn, %{"email" => email} = _params) do
    case UserContext.get_user_by_email(email) do
      nil ->
        conn
        |> put_status(404)
        |> put_view(Api.ErrorView)
        |> render("error.json",
          code: 404,
          message: "This email is not registered. Please sign up first."
        )

      user ->
        if user_setup_complete?(user) do
          conn
          |> put_view(Api.ErrorView)
          |> render("error.json",
            code: 400,
            message: "Your account is already verified. Please sign in."
          )
        else
          with {:ok, url} <- get_url(conn),
               {:ok, :email_sent} <- AuthContext.send_email_verification(user, url) do
            conn
            |> put_view(SharedView)
            |> render("success.json", %{data: %{message: "Email has been sent"}})
          end
        end
    end
  end

  def setup_password(conn, %{"token" => token} = params) do
    with {:ok, :valid} <- token_valid?(token),
         {:ok, user} <- AuthContext.verify_and_update_user(token),
         {:ok, _record} <- AuthContext.setup_password(user, params) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "Setup complete"}})
    end
  end

  @doc """
  Logs out a user by revoking their token and signing them out.
  """
  @spec logout(Plug.Conn.t(), %{required(String.t()) => String.t()}) :: Plug.Conn.t()
  def logout(conn, %{"token" => token} = _params) do
    Guardian.revoke(token)
    GuardianPlug.sign_out(conn)

    send_resp(
      conn,
      200,
      Jason.encode!(%{
        code: 200,
        message: "User is successfully logout"
      })
    )
  end

  @spec user_login(Plug.Conn.t(), String.t(), String.t(), boolean()) :: Plug.Conn.t()
  def user_login(conn, email, password, remember_me) do
    case validate_identity(email) do
      {:email, email} ->
        auth_user(conn, password, email, remember_me)

      {:error, :email_not_registered} ->
        Auth.not_authorized(conn, "Email not registered")
    end
  end

  @doc """
  This function is used to send pre info for forgot password
  """
  @spec forgot_password_pre_info(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def forgot_password_pre_info(conn, params) do
    with {:ok, data} <- AuthContext.forgot_password_pre_info(params) do
      render(conn, "forgot_password.json", data: data)
    end
  end

  @spec forgot_password(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def forgot_password(conn, params) do
    with {:ok, url} <- get_url(conn),
         {:ok, :sent} <- validate_user_and_send_otp(url, params, "password_reset") do
      render(conn, "forgot_password.json", %{data: %{message: "reset link send successfully"}})
    end
  end

  defp validate_user_and_send_otp(url, %{"email" => email} = params, action) do
    query =
      from(user in Data.User,
        where: user.email == ^email and is_nil(user.deactivated_at)
      )

    user = Repo.one(query)
    do_send_otp(user, url, params, action)
  end

  defp do_send_otp(nil, _, _, _),
    do: {:error, "This user is not registered. Please sign up first."}

  defp do_send_otp(user, url, params, action) do
    OtpCodeContext.deactivate_user_otps(user, action)

    user.id
    |> OtpCodeContext.create_unique_otp(action)
    |> case do
      {:ok, {otp, _} = _otp_data} ->
        OtpUtils.send_otp(otp, user, url, params, action)

      error ->
        error
    end
  end

  @spec reset_password(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def reset_password(
        conn,
        %{
          "password" => password,
          "email" => email,
          "otp" => _otp
        } = _params
      ) do
    query =
      from(oc in Data.OtpCode,
        inner_join: user in Data.User,
        on: user.id == oc.user_id,
        where:
          user.email == ^email and
            oc.reason == "password_reset" and
            is_nil(oc.deactivated_at),
        preload: [:user],
        limit: 1
      )

    otp = Repo.one(query)

    case otp do
      nil ->
        conn
        |> put_status(404)
        |> put_view(Api.ErrorView)
        |> render("error.json",
          code: 404,
          message: "Wrong Otp Code"
        )

      _ ->
        multi_result =
          Ecto.Multi.new()
          |> Ecto.Multi.update(
            :user,
            Data.User.update_password_changeset(otp.user, %{
              password: password
            })
          )
          |> Ecto.Multi.update(
            :otp,
            Data.OtpCode.changeset(otp, %{
              deactivated_at: DateTime.utc_now()
            })
          )
          |> Data.Repo.transaction()

        case multi_result do
          {:ok, _record} ->
            send_resp(
              conn,
              200,
              Jason.encode!(%{
                code: 200,
                message: "Password Reset"
              })
            )

          {:error, _error_key, value, _} ->
            conn
            |> put_status(:unprocessable_entity)
            |> put_view(Api.ErrorView)
            |> render("errors.json", %{
              code: 422,
              message: "Unprocessable entity",
              changeset: value
            })
        end
    end
  end

  defp validate_identity(identity) do
    is_email = Regex.match?(~r(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$), identity)

    if is_email == true do
      {:email, identity}
    else
      {:error, :email_not_registered}
    end
  end

  @spec auth_user(Plug.Conn.t(), String.t(), String.t(), boolean()) :: Plug.Conn.t()
  def auth_user(conn, password, identity, remember_me) do
    case Auth.auth_user_validate(password, identity) do
      {:ok, user} ->
        authenticate_user(conn, user, remember_me)

      {:error, :password_not_set} ->
        Auth.not_authorized(conn, "Registration setup is not competed")

      {:error, _} ->
        Auth.not_authorized(conn, "Invalid id or password")
    end
  end

  defp authenticate_user(conn, user, true) do
    conn =
      conn
      |> GuardianPlug.sign_in(user, %{}, ttl: {30, :day}, token_type: "access")
      |> GuardianPlug.remember_me(user)

    jwt = GuardianPlug.current_token(conn)
    claims = GuardianPlug.current_claims(conn)
    exp = Map.get(claims, "exp")

    conn =
      conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_resp_header("x-expires", "#{exp}")

    {syllabus_providers, _meta} =
      Api.SyllabusProviderContext.fetch_active_paginated(%{})

    data = %{
      jwt: jwt,
      user: user,
      exp: exp,
      syllabus_providers: syllabus_providers
    }

    render(conn, "login.json", data)
  end

  defp authenticate_user(conn, user, false) do
    conn = GuardianPlug.sign_in(conn, user, %{}, ttl: {1, :day})
    jwt = GuardianPlug.current_token(conn)
    claims = GuardianPlug.current_claims(conn)
    exp = Map.get(claims, "exp")

    conn =
      conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_resp_header("x-expires", "#{exp}")

    {syllabus_providers, _meta} =
      Api.SyllabusProviderContext.fetch_active_paginated(%{})

    data = %{
      jwt: jwt,
      user: user,
      exp: exp,
      syllabus_providers: syllabus_providers
    }

    render(conn, "login.json", data)
  end

  defp get_url(conn) do
    url = HeaderUtils.get_origin_url(conn)
    {:ok, url}
  end

  defp token_valid?(token) when token not in [nil, ""] do
    {:ok, :valid}
  end

  defp token_valid?(_), do: {:error, "Invalid token"}

  defp user_setup_complete?(%{email_verified_at: nil}), do: false
  defp user_setup_complete?(_), do: true
end
