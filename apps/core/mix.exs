defmodule Core.MixProject do
  use Mix.Project

  def project do
    [
      app: :core,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "schemas", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web", "schemas"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cors_plug, "~> 3.0"},
      {:guardian, "~> 2.3"},
      {:guardian_db, "~> 2.1"},
      {:bcrypt_elixir, "~> 3.0"},
      {:ecto, "~> 3.10"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, "~> 0.17.1"},
      {:oban, "~> 2.12.0"},
      {:gettext, "~> 0.21.0"},
      {:ex_machina, "~> 2.7"},
      {:faker, "~> 0.17.0"},
      # {:fat_ecto, "~> 1.0.0"},
      {:fat_ecto, github: "tanweerdev/fat_ecto", branch: "master"},
      # {:fat_ecto, path: "/Users/tanweer/projects/tanweerdev/fat_ecto"},
      {:timex, "~> 3.7"},
      {:triplex, "~> 1.3"},
      {:phoenix, "~> 1.7"},
      {:phoenix_view, "~> 2.0"},
      {:phoenix_pubsub, "~> 2.1"},
      {:jason, "~> 1.4"},
      {:polymorphic_embed, "~> 3.0"},
      {:sentry, "~> 8.0"},
      {:ex_phone_number, "~> 0.4.2"},
      {:roman, "~> 0.2.1"},
      {:hammox, "~> 0.7.0", only: [:test]},
      {:bamboo, "~> 2.2"},
      {:bamboo_smtp, "~> 4.2"},
      {:bodyguard, "~> 2.4"},
      {:plug, "~> 1.14"},
      {:plug_cowboy, "~> 2.6"},
      {:pigeon, "~> 2.0.0-rc.1"},
      {:ex_aws, "~> 2.4"},
      {:ex_aws_s3, "~> 2.4"},
      {:sweet_xml, "~> 0.7.3"},
      {:csv, "~> 3.0"},
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.3"},
      {:ua_inspector, "~> 3.3"},
      {:tesla, "~> 1.7"},
      {:observer_cli, "~> 1.7"},
      {:bamboo_ses, "~> 0.4"},
      {:excoveralls, "~> 0.16.1", only: :test},
      {:mox, "~> 1.0", only: :test},
      {:assertions, "~> 0.19", only: :test},
      {:dialyxir, "~> 1.3", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:git_hooks, "~> 0.7.3", only: [:dev, :test], runtime: false},
      {:mock, "~> 0.3.7", only: :test},
      {:logger_papertrail_backend, "~> 1.1"},
      {:cachex, "~> 3.6"},
      {:decimal, "~> 2.1"},
      # {:hammer, "~> 6.1"},
      {:stripity_stripe, "~> 2.17"}
    ]
  end
end
