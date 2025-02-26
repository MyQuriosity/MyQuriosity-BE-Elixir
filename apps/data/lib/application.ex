defmodule Data.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc """
  # TODO: Write proper moduledoc
  """

  use Application

  def start(_type, _args) do
    Logger.add_backend(Sentry.LoggerBackend)
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      # QuizGenerator.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Data.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
