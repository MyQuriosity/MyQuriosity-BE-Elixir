import Config

# Configure your database
config :data, Data.Repo,
  username: "postgres",
  password: "postgres",
  database: "quiz_generator_dev",
  hostname: System.get_env("MYQAMPUS_DB_HOST") || "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
