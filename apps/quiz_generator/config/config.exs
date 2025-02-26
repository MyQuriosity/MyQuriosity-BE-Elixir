# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :quiz_generator,
  ecto_repos: [QuizGenerator.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :quiz_generator, QuizGeneratorWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: QuizGeneratorWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: QuizGenerator.PubSub,
  live_view: [signing_salt: "174itEJz"]

config :quiz_generator, QuizGenerator.Guardian,
  issuer: "quiz_generator_api",
  #  secret_key: "Secret key. You can use `mix guardian.gen.secret` to get one"
  secret_key: "UZzm1YhuWMQS+VzJGQDwqlduiXzMI9HBJoH20fhdIPBbLi/R0LR0moNLUtGplpCV"

config :quiz_generator, QuizGenerator.AuthAccessPipeline,
  module: QuizGenerator.Guardian,
  error_handler: QuizGenerator.AuthErrorHandler

config :quiz_generator, :env,
  quiz_admin_password: System.get_env("QUIZ_ADMIN_PASSWORD") || "password"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cors_plug,
  # Change this to specific origins for security
  origin: ["*"],
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
