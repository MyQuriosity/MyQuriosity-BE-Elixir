defmodule Mix.Tasks.SuperAdminSeed do
  @shortdoc "mix super_admin_seed"
  @moduledoc """
  # TODO: Write proper moduledoc
  """

  use Mix.Task
  alias Core.Utils.AuthUtils, as: AuthUtils

  def run(_args) do
    IO.inspect("heree")
    Enum.each([:postgrex, :ecto, :ecto_sql], &Application.ensure_all_started/1)

    QuizGenerator.Repo.start_link()

    data = [
      %{
        first_name: "Super",
        last_name: "Admin",
        hashed_password:
          AuthUtils.hash_password(
            Application.get_env(:quiz_generator, :env)[:quiz_admin_password]
          ),
        email: "admin@gmail.com",
        gender: "male",
        is_admin: true,
        inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
        updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      }
    ]

    insert_all_users(data)
  end

  defp insert_all_users(data) do
    QuizGenerator.Repo.insert_all(QuizGenerator.User, data,
      on_conflict: {:replace_all_except, [:id]},
      returning: true,
      conflict_target: [:id]
    )
  end
end
