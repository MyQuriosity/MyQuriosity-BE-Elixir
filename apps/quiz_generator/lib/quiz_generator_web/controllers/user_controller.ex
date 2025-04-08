defmodule QuizGeneratorWeb.UserController do
  use QuizGeneratorWeb, :controller

  alias QuizGenerator.HeaderUtils
  alias QuizGenerator.UserContext
  alias QuizGeneratorWeb.SharedView

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, params) do
    user = HeaderUtils.get_current_user(conn)

    with {:ok, _updated_user} <- UserContext.update(user, params) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "User successfully updated"}})
    end
  end

  @spec update_password(any(), map()) ::
          {:error, false | :not_found | Ecto.Changeset.t()} | Plug.Conn.t()
  def update_password(
        conn,
        %{"password" => password, "confirmed_password" => confirmed_password} = params
      ) do
    user = HeaderUtils.get_current_user(conn)
    with {:ok, true} <- UserContext.verify_password(password, confirmed_password),
         {:ok, _updated_user} <- UserContext.update_password(user, params) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "Password updated successfully"}})
    end
  end

  def reset_password(conn, params) do
    user = HeaderUtils.get_current_user(conn)
    IO.inspect(conn)
  end
end
