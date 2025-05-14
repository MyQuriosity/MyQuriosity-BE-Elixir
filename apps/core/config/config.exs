import Config

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Stripe
# config :stripity_stripe,
#   api_key: System.get_env("STRIPE_SECRET"),
#   api_version: "2019-12-03",
#   signing_secret: System.get_env("WEB_HOOK_SECRET"),
#   connect_client_id: System.get_env("STRIPE_CLIENT_ID")

# Configures Elixir's Logger
config :logger, :console,
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
  backends: [:console]

config :logger, level: :debug

config :tesla, adapter: Tesla.Adapter.Hackney

config :logger, :logger_papertrail_backend,
  metadata_filter: [],
  format: {Formatter.Log, :format},
  # format: "$metadata $message"
  metadata: [
    :phoenix,
    :action,
    :httpRequest,
    :pid,
    :file,
    :line,
    :function,
    :module,
    :application,
    :span_id,
    :trace_id,
    :request_id,
    # Custom metadata
    :logged_user_id,
    :logged_user_phone,
    :logged_user_email,
    :logged_user_username,
    :logged_user_first_name,
    :logged_user_last_name,
    :tenant_prefix,
    :myquriosity_site,
    :personal_site,
    :event,
    :error,
    :failed_operation,
    :reason,
    :message_id,
    :uncaught_pattern
  ]

config :logger,
  backends: [:console],
  level: :debug

import_config "#{config_env()}.exs"
