defmodule QuizGenerator.Plug.RequestLogger do
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
    user = QuizGenerator.Guardian.Plug.current_resource(conn)

    # Setting user context
    Sentry.Context.set_extra_context(%{
      user_id: user && user.id,
      user_email: user && user.email
    })

    # credo:disable-for-lines:11
    Logger.metadata(
      user_id: user && user.id,
      user_email: user && user.email
    )

    conn
  end
end
