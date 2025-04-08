# this file is read at build time, before we compile our application and before we even load our dependencies.
# This means we can’t access the code in our application nor in our dependencies.
# However, it means we can control how they are compiled

# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

for config <- "../apps/*/config/config.exs" |> Path.expand(__DIR__) |> Path.wildcard() do
  import_config config
end

# config :sentry,
#   dsn: System.get_env("SENTRY_DSN"),
#   environment_name: System.get_env("SENTRY_SERVER_NAME"),
#   enable_source_code_context: true,
#   root_source_code_path: File.cwd!(),
#   tags: %{
#     env: System.get_env("SENTRY_SERVER_NAME")
#   },
#   included_environments: ["be.dev.QuizGenerator.com", "be.stage.QuizGenerator.com", "be.QuizGenerator.com"]

# config :notifire, Notifire.FCM,
#   adapter: Pigeon.FCM,
#   project_id: "QuizGenerator-dev-ad775",
#   service_account_json: File.read!("service-account-dev.json")

# config :segment, Segment.HTTP.Trackable, client: Segment.HTTP.Segment.Client
import_config "#{config_env()}.exs"
