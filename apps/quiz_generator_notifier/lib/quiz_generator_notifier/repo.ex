defmodule QuizGeneratorNotifier.Repo do
  use Ecto.Repo,
    otp_app: :quiz_generator_notifier,
    adapter: Ecto.Adapters.Postgres
end
