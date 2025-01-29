defmodule Campus.Plug.ValidateUUID do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  use Plug.Builder
  @doc false
  @spec init(map()) :: map()
  def init(opts \\ %{}), do: Enum.into(opts, %{})

  @doc false
  @spec call(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def call(conn, _opts) do
    params = conn.path_params

    case params do
      %{"id" => id} ->
        map = Ecto.UUID.cast(id)

        case map do
          {:ok, _} ->
            conn

          :error ->
            conn
            |> send_resp(400, "Invalid ID")
            |> halt()
        end

      _ ->
        conn
    end
  end
end
