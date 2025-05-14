import Config

# Configure your database
config :data, Data.Repo,
  username: "postgres",
  password: "postgres",
  database: "myquriosity_test",
  hostname: System.get_env("DB_ENV_POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  port: System.get_env("DB_ENV_POSTGRES_PORT") || 5432
