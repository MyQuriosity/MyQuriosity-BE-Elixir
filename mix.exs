defmodule Quriosity.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
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
end
