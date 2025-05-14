defmodule Api.UserController do
  use MyQuriosityWeb, :controller

  alias Api.HeaderUtils
  alias Api.UserContext
  alias Api.SharedView

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id} = params) do
    with {:ok, user} <- UserContext.get_user_by_id(id),
         {:ok, _updated_user} <- UserContext.update(user, params) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "User successfully updated"}})
    end
  end

  @spec update_password(any(), map()) ::
          {:error, false | :not_found | Ecto.Changeset.t()} | Plug.Conn.t()
  def update_password(
        conn,
        %{
          "current_password" => current_password,
          "updated_password" => password,
          "confirmed_password" => confirmed_password
        }
      ) do
    user = HeaderUtils.get_current_user(conn)
    updated_params = %{password: password}

    with {:ok, :password_verified} <- UserContext.validate_password(user.id, current_password),
         {:ok, true} <- UserContext.verify_new_password(password, confirmed_password),
         {:ok, _updated_user} <- UserContext.update_password(user, updated_params) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "Password updated successfully"}})
    end
  end
end
