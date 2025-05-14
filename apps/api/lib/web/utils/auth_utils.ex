defmodule Api.Utils.Auth do
  @moduledoc """
  # TODO: Write proper moduledoc
  """

  use Phoenix.Controller, namespace: Web
  import Plug.Conn
  import Ecto.Query

  @spec hash_password(String.t()) :: String.t()
  def hash_password(plaintext) do
    Bcrypt.hash_pwd_salt(plaintext)
  end

  @spec auth_user_validate(String.t(), String.t()) ::
          {:error, :invalid_password | :user_not_found | :password_not_set}
          | {:ok, Data.User.t()}

  def auth_user_validate(_plaintext_pw, nil), do: {:error, :password_not_set}

  def auth_user_validate(plaintext_pw, field_value) do
    case get_by_case_insensitive(Data.User, field_value, :email) do
      {:ok, user} ->
        if Bcrypt.verify_pass(plaintext_pw, user.hashed_password),
          do: {:ok, user},
          else: {:error, :invalid_password}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_by_case_insensitive(model, field_value, field_key) do
    query =
      from(u in model,
        where: fragment("lower(?)", field(u, ^field_key)) == ^String.downcase(field_value),
        preload: :syllabus_provider,
        limit: 1
      )

    case Data.Repo.one(query) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end

  @spec not_authorized(Plug.Conn.t(), String.t()) :: Plug.Conn.t()
  def not_authorized(conn, message) do
    conn
    |> put_status(401)
    |> put_view(Api.ErrorView)
    |> render("error.json", code: 401, message: message)
  end
end
