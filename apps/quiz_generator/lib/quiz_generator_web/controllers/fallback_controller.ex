defmodule QuizGeneratorWeb.FallbackController do
  use QuizGeneratorWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(WebApi.V1.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(WebApi.V1.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, :invalid_password}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(WebApi.V1.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, :user_not_found}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(WebApi.V1.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, changeset = %Ecto.Changeset{}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(WebApi.V1.ErrorView)
    |> render("errors.json", %{code: 422, message: "Unprocessable entity", changeset: changeset})
  end

  # For multiple create
  def call(conn, {:error, index, changeset = %Ecto.Changeset{}, _whatever}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(WebApi.V1.ErrorView)
    |> render("errors_with_index.json", %{
      code: 422,
      message: "Unprocessable entity",
      changeset: changeset,
      index: index
    })
  end

  def call(conn, {:error, :request_rate_exceeded, message: message}) do
    conn
    |> put_status(429)
    |> put_view(WebApi.V1.ErrorView)
    |> render("error.json", %{
      code: 429,
      message: message
    })
  end

  def call(conn, {status, code, message}) do
    conn
    |> put_status(status)
    |> put_view(WebApi.V1.ErrorView)
    |> render("error.json", %{code: code, message: message})
  end

  def call(conn, {:error, message}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(WebApi.V1.ErrorView)
    |> render("error.json", %{
      code: 422,
      message: message
    })
  end
end
