defmodule Quriosity.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: save_and_get_version(),
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

  defp get_version do
    System.get_env("RELEASE_VERSION") || "0.1.0"
  end

  def save_and_get_version do
    version = get_version()

    version_info = get_version_info()
    version_info = Map.put(version_info, :app_version, version)

    # Save to a common file in the umbrella's `priv` directory
    save_version_info(version_info, "apps/core/priv/version_info.json")

    version
  end

  def save_release_info(release) do
    version = get_version()

    version_info = get_version_info()
    version_info = Map.put(version_info, :app_version, version)

    # Save to a common file in the umbrella's `priv` directory
    save_version_info(version_info, "apps/core/priv/version_info.json")

    release
  end

  @doc """
  Helper function to save version/release info to a file.
  """
  def save_version_info(info, file_path) do
    # Ensure the directory exists
    File.mkdir_p!(Path.dirname(file_path))

    # Write the info to the file
    # File.write!(file_path, Poison.encode!(info))

    # Write the info to the file as raw content
    File.write!(file_path, encode(info))
  end

  def encode(map) do
    map
    |> Enum.map(fn {k, v} -> "\"#{k}\":\"#{v}\"" end)
    |> Enum.join(",")
    |> then(&"{#{&1}}")
  end

  def get_version_info do
    with {:ok, commit_hash} <- execute_git_command("show", ["-s", "--pretty=format:%h"]),
         {:ok, commit_message} <- execute_git_command("show", ["-s", "--pretty=format:%s"]),
         {:ok, commit_author} <- execute_git_command("show", ["-s", "--pretty=format:%cn"]),
         {:ok, commit_date} <- execute_git_command("show", ["-s", "--pretty=format:%cd"]),
         {:ok, branch} <- execute_git_command("rev-parse", ["--abbrev-ref", "HEAD"]) do
      %{
        commit_hash: commit_hash,
        commit_message: commit_message,
        commit_author: commit_author,
        commit_date: commit_date,
        branch: branch
      }
    else
      _ -> nil
    end
  end

  def execute_git_command(command, args) do
    case System.cmd("git", [command | args]) do
      {output, 0} -> {:ok, String.trim_trailing(output)}
      _ -> :error
    end
  end

  defp releases do
    [
      QuizGenerator: [
        applications: [
          runtime_tools: :permanent,
          core: :permanent,
          data: :permanent,
          quiz_generator: :permanent
        ],
        path: "builds",
        # have Mix automatically create a tarball after assembly
        steps: [:assemble, &save_release_info/1, :tar]
      ]
    ]
  end
end
