defmodule Quriosity.MixProject do
  use Mix.Project
  alias FatUtils.Version

  def project do
    [
      apps_path: "apps",
      version: version(),
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      elixirc_options: [warnings_as_errors: true],
      dialyzer: [
        flags: [
          :no_contracts,
          :no_fail_call,
          :no_return,
          :no_opaque,
          :no_unused,
          :no_match
        ],
        plt_add_apps: [:mix, :ex_unit]
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    []
  end

  defp put_version(rel) do
    app_version = version()
    # Copy it to somewhere predictable
    {:ok, core_app_version} = :application.get_key(:core, :vsn)

    build_path =
      "#{rel.path}/lib/core-#{to_string(core_app_version)}/priv/version_info.json"

    local_path = "apps/core/priv/version_info.json"

    Version.write_version_info(app_version, local_path, build_path)

    rel
  end

  defp version do
    if System.get_env("RELEASE_VERSION") in ["", nil] do
      git_version()
    else
      System.get_env("RELEASE_VERSION")
    end
  end

  def git_version do
    "git"
    |> System.cmd(["rev-parse", "--short", "HEAD"])
    |> elem(0)
    |> String.trim_trailing()
  end

  defp releases do
    [
      myquriosity: [
        applications: [
          runtime_tools: :permanent,
          core: :permanent,
          data: :permanent,
          quiz_generator: :permanent
        ],
        path: "builds",
        # have Mix automatically create a tarball after assembly
        steps: [:assemble, &put_version/1, :tar]
      ]
    ]
  end
end
