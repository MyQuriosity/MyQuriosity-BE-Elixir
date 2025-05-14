# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :data,
  ecto_repos: [Data.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configure your database
config :data, Data.Repo,
  migration_timestamps: [type: :utc_datetime],
  adapter: Ecto.Adapters.Postgres

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
