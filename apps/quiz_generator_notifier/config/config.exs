import Config

config :tenant_notifire, web_push_endpoint: ApiWeb.Endpoint

config :tenant_notifire, Oban,
  name: TenanatNotifire.Oban,
  prefix: "quiz_generator_notifire_oban",
  repo: TenantData.ObanRepo,
  queues: [
    default: 1,
    notifications: 100,
    daily_tenant_worker: 10,
    salary_generators: 10,
    pickup_request: 10,
    salaries: 10
  ],
  plugins: [
    {Oban.Plugins.Pruner, max_age: 1 * 24 * 60 * 60},
    {
      Oban.Plugins.Cron,
      # crontab: [
      #   {"@daily", TenantApi.Workers.DailyTenantWorker,
      #    args: %{
      #      worker: TenantApi.Workers.MainSalaryWorker,
      #      queue: :salary_generators
      #    },
      #    queue: :daily_tenant_worker}
      # ]
    }
  ]

import_config "#{Mix.env()}.exs"
