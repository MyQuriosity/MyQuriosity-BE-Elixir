# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :data,
  ecto_repos: [Data.Repo]

# Pipeline for token auth
config :data, Data.Auth.Pipeline.ApiAuthAccessPipeline,
  module: QuizGenerator.Guardian,
  error_handler: Campus.AuthErrorHandler

# Configure your database
config :data, Data.Repo,
  migration_timestamps: [type: :utc_datetime],
  adapter: Ecto.Adapters.Postgres

# Add sendgrid API_KEY
# TODO: RELEASE_CONFIG_FIX_NEEDED
if System.get_env("MYQAMPUSMAILER_EMAIL_ADAPTER") == "ses" do
  config :data, Data.Mailer,
    adapter: Bamboo.SesAdapter,
    from_email: System.get_env("MYQAMPUS_DEFAULT_EMAIL")
else
  config :data, Data.Mailer,
    adapter: Bamboo.SendGridAdapter,
    api_key: System.get_env("BAMBOO_API_KEY"),
    from_email: System.get_env("MYQAMPUS_DEFAULT_EMAIL")
end

if System.get_env("E2E_TESTING_ENABLED") == "true" do
  config :data, Data.Mailer, adapter: Bamboo.TestAdapter
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
