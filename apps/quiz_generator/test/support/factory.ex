defmodule TenantData.Support.Factory do
  use ExMachina.Ecto, repo: QuizGenerator.Repo
  alias QuizGenerator.SyllabusProvider
  alias QuizGenerator.User

  def user_factory do
    %User{
      first_name: "Super",
      last_name: "Admin",
      password: "12345678",
      email: "admin@gmail.com",
      gender: "male",
      is_admin: true
    }
  end

  def syllabus_provider_factory do
    %SyllabusProvider{
      title: "Punjab Textbook Board",
      description: "For Punjab schools"
    }
  end
end
