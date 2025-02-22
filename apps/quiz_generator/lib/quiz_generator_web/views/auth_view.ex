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

  def render("login.json", %{jwt: jwt, user: user, exp: exp}) do
    %{
      jwt: jwt,
      user: %{
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        gender: user.gender
      },
      exp: exp
    }
  end

  def render("forgot_password.json", %{data: data}), do: data
end
