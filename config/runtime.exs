import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/quiz_generator start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.

if config_env() == :prod do
  config :quiz_generator, QuizGeneratorWeb.Endpoint,
    server: true,
    http: [
      port: "MYQURIOSITY_SERVER_PORT" |> System.fetch_env!() |> String.to_integer(),
      transport_options: [socket_opts: [:inet6]]
    ],
    url: [
      scheme: System.fetch_env!("MYQURIOSITY_URL_SCHEME"),
      host: System.fetch_env!("MYQURIOSITY_URL_HOST"),
      port: System.fetch_env!("MYQURIOSITY_URL_PORT")
    ],
    # check_origin: [System.fetch_env!("MYQURIOSITY_SITE_ORIGINS") || "//*.myquriosity.com"],
    # TODO: enable it with some flexible configuration later
    check_origin: false,
    secret_key_base: System.fetch_env!("MYQURIOSITY_SECRET_KEY_BASE")

  config :quiz_generator, QuizGenerator.Repo,
    # ssl: true,
    # TODO: only enable it for dev+stage server via config
    show_sensitive_data_on_connection_error: true,
    username: System.fetch_env!("MYQURIOSITY_DB_USER"),
    password: System.fetch_env!("MYQURIOSITY_DB_PWD"),
    database: System.fetch_env!("MYQURIOSITY_DB_NAME"),
    hostname: System.fetch_env!("MYQURIOSITY_DB_HOST"),
    port: "MYQURIOSITY_DB_PORT" |> System.get_env("5432") |> String.to_integer(),
    pool_size: 10

  config :data, QuizGenerator.Repo,
    # ssl: true,
    # TODO: only enable it for dev+stage server via config
    show_sensitive_data_on_connection_error: true,
    username: System.fetch_env!("MYQURIOSITY_DB_USER"),
    password: System.fetch_env!("MYQURIOSITY_DB_PWD"),
    database: System.fetch_env!("MYQURIOSITY_DB_NAME"),
    hostname: System.fetch_env!("MYQURIOSITY_DB_HOST"),
    port: "MYQURIOSITY_DB_PORT" |> System.get_env("5432") |> String.to_integer(),
    pool_size: 10

  # When generating build for macbook provide a different path or comment it out
  config :tzdata, :data_dir, "/home/ubuntu/elixir_tzdata_data"
end
