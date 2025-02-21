defmodule QuizGenerator.ErrorView do
  use QuizGeneratorWeb, :view

  def render("400.json", _assigns) do
    render("error.json", %{code: 400, message: "Bad request"})
  end

  def render("401.json", _assigns) do
    render("error.json", %{code: 401, message: "Invalid user or password"})
  end

  def render("404.json", %{message: message}) do
    render("error.json", %{code: 404, message: message})
  end

  def render("404.json", _assigns) do
    render("error.json", %{code: 404, message: "Not found"})
  end

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.json", _assigns) do
    render("error.json", %{code: 500, message: "Server error"})
  end

  def render("error.json", %{code: code, message: message}) do
    %{error: %{code: code, message: message}}
  end

  def render("errors.json", %{code: code, message: message, errors: errors}) do
    %{error: %{code: code, message: message, errors: errors}}
  end

  def render("errors_with_index.json", %{
        code: code,
        message: message,
        changeset: changeset,
        index: index
      }) do
    %{error: %{code: code, index: index, message: message, errors: translate_errors(changeset)}}
  end

  def render("errors.json", %{code: code, message: message, changeset: changeset}) do
    %{error: %{code: code, message: message, errors: translate_errors(changeset)}}
  end

  def template_not_found(_template, assigns) do
    render("500.json", assigns)
  end

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end
end
