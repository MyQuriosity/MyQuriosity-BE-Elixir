defmodule Core.Utils.HeaderUtils do
  @moduledoc """
  Utility functions for getting information
  from request headers\"""

  @doc \"""
   This function gets origin from request header
  """
  @spec get_origin_url(Plug.Conn.t()) :: String.t() | nil
  def get_origin_url(conn) do
    conn
    |> Plug.Conn.get_req_header("origin")
    |> List.first()
  end
end
