defmodule Api.Plug.AdminAuth do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  use Plug.Builder
  alias Api.Guardian.Plug, as: GuardianPlug
  @doc false
  @spec init(map()) :: map()
  def init(opts \\ %{}), do: Enum.into(opts, %{})

  @doc false
  @spec call(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def call(conn, _opts) do
    claims = GuardianPlug.current_claims(conn)
    is_admin = claims["is_admin"]

    if is_admin == true do
      conn
    else
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(403, Jason.encode!("Permission denied"))
      |> halt
    end
  end
end
