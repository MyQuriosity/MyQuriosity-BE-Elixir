import Config

# Place all the configuration which should be loaded
# provides runtime application configuration.
# It is executed every time your Mix project or your release boots

# If you want to detect you are inside a release, you can check for release specific environment variables,
# such as RELEASE_NODE or RELEASE_MODE

# You can also create runtime.exs file if needed

# IMP: When runtime.exs file is present, build wont load releases.exs file
# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :core, Core.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

# TODO:
# While developers often use user-defined module attributes as constants,
# its important to remember that the value is read at compilation time and
# not at runtime. Since the value of
# Application.get_env(:registrar, :stripe_api_base_url)
# (which comes from a system environment variable)
# is only present at runtime, using a module attribute here won’t work!
# defp stripe_api_base_url, do: Application.get_env(:registrar, :stripe_api_base_url)
# if Application.get_env(:core, :env) in [:prod, "prod"] do

# config :api, ApiWeb.Endpoint,
#   server: true,
#   http: [
#     port: "MYQAMPUS_SERVER_PORT" |> System.fetch_env!() |> String.to_integer(),
#     transport_options: [socket_opts: [:inet6]]
#   ],
#   url: [
#     scheme: System.fetch_env!("MYQAMPUS_URL_SCHEME"),
#     host: System.fetch_env!("MYQAMPUS_URL_HOST"),
#     port: System.fetch_env!("MYQAMPUS_URL_PORT")
#   ],
#   # check_origin: [System.fetch_env!("MYQAMPUS_SITE_ORIGINS") || "//*.myqampus.com"],
#   # TODO: enable it with some flexible configuration later
#   check_origin: false,
#   secret_key_base: System.fetch_env!("MYQAMPUS_SECRET_KEY_BASE")

# # config :api, ApiWeb.Endpoint,
# #   http: [port: {:system, "PORT"}],
# #   url: [scheme: "https", host: "mobile-api-elixir-1.herokuapp.com", port: 443],
# #   force_ssl: [rewrite_on: [:x_forwarded_proto]],
# #   cache_static_manifest: "priv/static/cache_manifest.json"

# # Configure your database
# # config :data, Data.Repo,
# #   # ssl: true,
# #   url: System.fetch_env!("CLEARDB_DATABASE_URL"),
# #   pool_size: String.to_integer(System.fetch_env!("POOL_SIZE") || "6")

# config :data, Data.Repo,
#   # ssl: true,
#   # TODO: only enable it for dev+stage server via config
#   show_sensitive_data_on_connection_error: true,
#   username: System.fetch_env!("MYQAMPUS_DB_USER"),
#   password: System.fetch_env!("MYQAMPUS_DB_PWD"),
#   database: System.fetch_env!("MYQAMPUS_DB_NAME"),
#   hostname: System.fetch_env!("MYQAMPUS_DB_HOST"),
#   port: "MYQAMPUS_DB_PORT" |> System.get_env("5432") |> String.to_integer(),
#   pool_size: 10

# # Configure your database
# config :tenant_data, TenantData.Repo,
#   # ssl: true,
#   show_sensitive_data_on_connection_error: true,
#   username: System.fetch_env!("MYQAMPUS_DB_USER"),
#   password: System.fetch_env!("MYQAMPUS_DB_PWD"),
#   database: System.fetch_env!("MYQAMPUS_DB_NAME"),
#   hostname: System.fetch_env!("MYQAMPUS_DB_HOST"),
#   port: "MYQAMPUS_DB_PORT" |> System.get_env("5432") |> String.to_integer(),
#   # TODO: maybe get pool_size from config
#   pool_size: 10

# config :tenant_data, TenantData.ObanRepo,
#   # ssl: true,
#   show_sensitive_data_on_connection_error: true,
#   username: System.fetch_env!("MYQAMPUS_DB_USER"),
#   password: System.fetch_env!("MYQAMPUS_DB_PWD"),
#   database: System.fetch_env!("MYQAMPUS_DB_NAME"),
#   hostname: System.fetch_env!("MYQAMPUS_DB_HOST"),
#   port: "MYQAMPUS_DB_PORT" |> System.get_env("5432") |> String.to_integer(),
#   pool_size: 10

# if System.get_env("MYQAMPUSMAILER_EMAIL_ADAPTER") == "ses" do
#   config :data, Data.Mailer,
#     adapter: Bamboo.SesAdapter,
#     from_email: System.get_env("MYQAMPUS_DEFAULT_EMAIL")
# else
#   config :data, Data.Mailer,
#     adapter: Bamboo.SendGridAdapter,
#     api_key: System.fetch_env!("BAMBOO_API_KEY"),
#     from_email: System.get_env("MYQAMPUS_DEFAULT_EMAIL")
# end

# config :tenant_data, TenantData.Mailer, adapter: nil

# config :stripity_stripe,
#   api_key: System.get_env("STRIPE_SECRET"),
#   api_version: "2019-12-03",
#   signing_secret: System.get_env("WEB_HOOK_SECRET"),
#   connect_client_id: System.get_env("STRIPE_CLIENT_ID")

# if System.get_env("MYQAMPUSMAILER_EMAIL_ADAPTER") == "ses" do
#   config :tenant_data, TenantData.MyQampusMailer,
#     adapter: Bamboo.SesAdapter,
#     default_myqampus_email_for_tenant: System.fetch_env!("MYQAMPUS_TENANT_DEFAULT_EMAIL")
# else
#   config :tenant_data, TenantData.MyQampusMailer,
#     adapter: Bamboo.SendGridAdapter,
#     api_key: System.fetch_env!("BAMBOO_API_KEY"),
#     default_myqampus_email_for_tenant: System.fetch_env!("MYQAMPUS_TENANT_DEFAULT_EMAIL")
# end

# config :arc,
#   # or Arc.Storage.Local
#   storage: Arc.Storage.S3,
#   # if using Amazon S3
#   bucket: System.fetch_env!("AWS_S3_BUCKET"),
#   virtual_host: true

# config :ex_aws,
#   access_key_id: System.fetch_env!("AWS_ACCESS_KEY_ID"),
#   secret_access_key: System.fetch_env!("AWS_SECRET_ACCESS_KEY"),
#   region: System.fetch_env!("AWS_S3_REGION")

# config :tenant_data, TenantData.FCM,
#   adapter: Pigeon.FCM,
#   project_id: System.fetch_env!("FCM_PROJECT_ID"),
#   service_account_json: File.read!("/home/ubuntu/service-account.json")

# config :notifire, Notifire.FCM,
#   adapter: Pigeon.FCM,
#   project_id: System.fetch_env!("FCM_PROJECT_ID"),
#   service_account_json: File.read!("/home/ubuntu/service-account.json")

# ## configuration for segment
# config :segment, segment_api_token: System.fetch_env!("SEGMENT_API_TOKEN")

# config :sentry,
#   dsn: System.fetch_env!("SENTRY_DSN"),
#   environment_name: System.fetch_env!("MYQAMPUS_URL_HOST"),
#   enable_source_code_context: true,
#   root_source_code_path: File.cwd!(),
#   tags: %{
#     env: System.fetch_env!("MYQAMPUS_URL_HOST")
#   },
#   included_environments: ["be.dev.myqampus.com", "be.stage.myqampus.com", "be.myqampus.com"]

# config :logger, :logger_papertrail_backend,
#   host: System.fetch_env!("PAPER_TRAIL_HOST") || "logs2.papertrailapp.com:20651",
#   level: :debug,
#   system_name: System.fetch_env!("PAPER_TRAIL_SYSTEM") || "MyQampusDev"

# config :logger,
#   backends: [Sentry.LoggerBackend, LoggerPapertrailBackend.Logger],
#   level: :debug

# config :core, ENDPOINT,
#   url_scheme: System.fetch_env!("MYQAMPUS_URL_SCHEME"),
#   url_host: System.fetch_env!("MYQAMPUS_URL_HOST")

# config :tzdata, :data_dir, "/home/ubuntu/elixir_tzdata_data"
