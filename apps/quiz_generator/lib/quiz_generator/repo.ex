defmodule QuizGenerator.Repo do
  use Ecto.Repo,
    otp_app: :quiz_generator,
    adapter: Ecto.Adapters.Postgres
end
