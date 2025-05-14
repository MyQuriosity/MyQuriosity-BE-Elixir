# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :web,
  ecto_repos: [Web.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :web, Web.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: Web.ErrorJSON],
    layout: false
  ],
  pubsub_server: Web.PubSub,
  live_view: [signing_salt: "174itEJz"]

config :web, Web.Guardian,
  issuer: "quiz_generator_api",
  #  secret_key: "Secret key. You can use `mix guardian.gen.secret` to get one"
  secret_key: "UZzm1YhuWMQS+VzJGQDwqlduiXzMI9HBJoH20fhdIPBbLi/R0LR0moNLUtGplpCV"

config :web, Web.AuthAccessPipeline,
  module: Web.Guardian,
  error_handler: Web.AuthErrorHandler

config :web, :env,
  quiz_admin_password: System.get_env("QUIZ_ADMIN_PASSWORD") || "password"

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_S3_REGION")

if System.get_env("MYQURIOSITYMAILER_EMAIL_ADAPTER") == "ses" do
  # Rest of SES configs will be fetched from ex_aws
  config :web, Web.Mailer,
    adapter: Bamboo.SesAdapter,
    from_email: System.get_env("MYQAMPUS_DEFAULT_EMAIL")
else
  config :web, Web.Mailer,
    adapter: Bamboo.SendGridAdapter,
    api_key: System.get_env("BAMBOO_API_KEY"),
    from_email: System.get_env("MYQAMPUS_DEFAULT_EMAIL")
end

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cors_plug,
  # Change this to specific origins for security
  origin: ["*"],
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
