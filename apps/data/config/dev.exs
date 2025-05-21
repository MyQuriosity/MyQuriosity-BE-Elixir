import Config

# Configure your database
config :data, Data.Repo,
  username: "postgres",
  password: "postgres",
  database: "myquriosity_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  stacktrace: true,
  pool_size: 10
