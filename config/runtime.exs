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
  config :web, Web.Endpoint,
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
    # check_origin: [System.fetch_env!("MYQURIOSITY_SITE_ORIGINS") || "//*.Web.com"],
    # TODO: enable it with some flexible configuration later
    check_origin: false,
    secret_key_base: System.fetch_env!("MYQURIOSITY_SECRET_KEY_BASE")

  config :web, Web.Repo,
    # ssl: true,
    # TODO: only enable it for dev+stage server via config
    show_sensitive_data_on_connection_error: true,
    username: System.fetch_env!("MYQURIOSITY_DB_USER"),
    password: System.fetch_env!("MYQURIOSITY_DB_PWD"),
    database: System.fetch_env!("MYQURIOSITY_DB_NAME"),
    hostname: System.fetch_env!("MYQURIOSITY_DB_HOST"),
    port: "MYQURIOSITY_DB_PORT" |> System.get_env("5432") |> String.to_integer(),
    pool_size: 10

  config :ex_aws,
    access_key_id: System.fetch_env!("AWS_ACCESS_KEY_ID"),
    secret_access_key: System.fetch_env!("AWS_SECRET_ACCESS_KEY"),
    region: System.fetch_env!("AWS_S3_REGION")

  if System.get_env("MYQURIOSITYMAILER_EMAIL_ADAPTER") == "ses" do
    # Rest of SES configs will be fetched from ex_aws
    config :web, Web.Mailer,
      adapter: Bamboo.SesAdapter,
      from_email: System.get_env("MYQURIOSITY_DEFAULT_EMAIL")
  else
    config :web, Web.Mailer,
      adapter: Bamboo.SendGridAdapter,
      api_key: System.fetch_env!("BAMBOO_API_KEY"),
      from_email: System.get_env("MYQURIOSITY_DEFAULT_EMAIL")
  end

  config :web, Web.Repo,
    # ssl: true,
    # TODO: only enable it for dev+stage server via config
    show_sensitive_data_on_connection_error: true,
    username: System.fetch_env!("MYQURIOSITY_DB_USER"),
    password: System.fetch_env!("MYQURIOSITY_DB_PWD"),
    database: System.fetch_env!("MYQURIOSITY_DB_NAME"),
    hostname: System.fetch_env!("MYQURIOSITY_DB_HOST"),
    port: "MYQURIOSITY_DB_PORT" |> System.get_env("5432") |> String.to_integer(),
    pool_size: 10

  config :logger,
    backends: [
      Sentry.LoggerBackend,
      {LoggerFileBackend, :error_log},
      {LoggerFileBackend, :info_log}
    ],
    level: :debug

  # READ https://hexdocs.pm/logger_file_backend/readme.html#configuration for more details
  config :logger, :error_log,
    path: System.fetch_env!("MYQURIOSITY_ERROR_LOG_FILE"),
    format: "$time $metadata[$level] $message\n",
    metadata: [
      :request_id,
      :user_id,
      :user_email,
      :event,
      :error,
      :failed_operation,
      :reason,
      :message_id,
      :uncaught_pattern
    ],
    level: :error

  config :logger, :info_log,
    path: System.fetch_env!("MYQURIOSITY_INFO_LOG_FILE"),
    format: "$time $metadata[$level] $message\n",
    metadata: [
      :request_id,
      :user_id,
      :user_email,
      :event,
      :error,
      :failed_operation,
      :reason,
      :message_id,
      :uncaught_pattern
    ],
    level: :info

  # When generating build for macbook provide a different path or comment it out
  config :tzdata, :data_dir, System.get_env("TZ_DATA_DIR_PATH", "/home/ubuntu/elixir_tzdata_data")
end
