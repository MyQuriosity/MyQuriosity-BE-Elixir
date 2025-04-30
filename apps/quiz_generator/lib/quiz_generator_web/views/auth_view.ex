defmodule QuizGeneratorWeb.AuthView do
  use QuizGeneratorWeb, :view

  def render("signup.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      gender: user.gender
    }
  end

  def render("login.json", %{
        jwt: jwt,
        user: user,
        exp: exp,
        syllabus_providers: syllabus_providers
      }) do
    %{
      jwt: jwt,
      user: %{
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        gender: user.gender,
        is_admin: user.is_admin,
        syllabus_provider:
          render_one(user.syllabus_provider, QuizGeneratorWeb.SyllabusProviderView, "show.json",
            as: :syllabus_provider
          )
      },
      exp: exp,
      syllabus_providers:
        render_many(syllabus_providers, QuizGeneratorWeb.SyllabusProviderView, "show.json",
          as: :syllabus_provider
        )
    }
  end

  def render("forgot_password.json", %{data: data}), do: data
end
