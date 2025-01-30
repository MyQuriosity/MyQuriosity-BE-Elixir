defmodule QuizGenerator.GuardianHelper do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  @spec current_user(Plug.Conn.t()) :: map() | nil
  def current_user(conn), do: Guardian.Plug.current_resource(conn)
end
