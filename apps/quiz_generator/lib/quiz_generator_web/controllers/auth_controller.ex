defmodule QuizGeneratorWeb.AuthController do
  use QuizGeneratorWeb, :controller

  alias QuizGenerator.Guardian
  alias QuizGenerator.Guardian.Plug, as: GuardianPlug
  alias Core.Utils.HeaderUtils
  alias QuizGenerator.AuthContext
  alias QuizGenerator.UserContext
  alias QuizGenerator.Utils.Auth
  alias QuizGeneratorWeb.SharedView

  @spec login(Plug.Conn.t(), map) :: Plug.Conn.t()
  def login(
        conn,
        %{"email" => identity, "password" => password} = _params
      ) do
    user_login(conn, identity, password)
  end

  def signup(conn, params) do
    with {:ok, user} <- UserContext.create_user(params),
         {:ok, url} <- get_url(conn),
         {:ok, :email_sent} <- AuthContext.send_email_verification(user, url) do
      render(conn, "signup.json", user: user)
    end
  end

  def setup_password(conn, %{"token" => token} = params) do
    with {:ok, :valid} <- is_token_valid?(token),
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

  @spec user_login(Plug.Conn.t(), String.t(), String.t()) :: Plug.Conn.t()
  def user_login(conn, identity, password) do
    case validate_identity(identity) do
      {:email, email} ->
        auth_user(conn, password, email, :email)

      {:error, :email_not_registered} ->
        Auth.not_authorized(conn, "Email not registered")
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

  @spec auth_user(Plug.Conn.t(), String.t(), String.t(), atom()) :: Plug.Conn.t()
  def auth_user(conn, password, identity, type) do
    case Auth.auth_user_validate(password, identity, type) do
      {:ok, user} ->
        authenticate_user(conn, user)

      {:error, :password_not_set} ->
        Auth.not_authorized(conn, "Registration setup is not competed")

      {:error, _} ->
        Auth.not_authorized(conn, "Invalid id or password.")
    end
  end

  defp authenticate_user(conn, user) do
    conn = GuardianPlug.sign_in(conn, user)
    jwt = GuardianPlug.current_token(conn)
    claims = GuardianPlug.current_claims(conn)
    exp = Map.get(claims, "exp")

    conn =
      conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_resp_header("x-expires", "#{exp}")

    {syllabus_providers, _meta} =
      QuizGeneratorWeb.SyllabusProviderContext.fetch_active_paginated(%{})

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

  defp is_token_valid?(token) when token not in [nil, ""] do
    {:ok, :valid}
  end

  defp is_token_valid?(_), do: {:error, "Invalid token"}
end
