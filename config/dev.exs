import Config

# Enable strict mode later
# {:cmd, "mix credo --strict"},
config :git_hooks,
  auto_install: true,
  verbose: true,
  hooks: [
    pre_commit: [
      tasks: [
        {:cmd, "mix compile --force --all-warnings"},
        {:cmd, "mix format --check-formatted"},
        {:cmd, "mix format"},
        # {:cmd, "mix credo"},
        {:cmd, "mix test --color"},
        {:cmd, "echo 'success!'"}
      ]
    ]
  ]

## configuration for segment
# config :segment, segment_api_token: System.get_env("SEGMENT_API_TOKEN")
