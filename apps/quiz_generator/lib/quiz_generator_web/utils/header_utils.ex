defmodule QuizGenerator.HeaderUtils do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  # alias TenantApi.Constants.Headers
  alias QuizGenerator.GuardianHelper

    @doc """
   This function gets origin from request header
  """
  @spec get_origin_url(Plug.Conn.t()) :: String.t() | nil
  def get_origin_url(conn) do
    conn
    |> Plug.Conn.get_req_header("origin")
    |> List.first()
  end

  @doc """
  This function gets current user id from conn
  """
  @spec get_current_user_id(Plug.Conn.t()) :: {:ok, String.t()}
  def get_current_user_id(conn) do
    {:ok, GuardianHelper.current_user(conn).id}
  end

  @spec get_current_user(Plug.Conn.t()) :: QuizGenerator.User.t()
  def get_current_user(conn) do
    GuardianHelper.current_user(conn)
  end
end
