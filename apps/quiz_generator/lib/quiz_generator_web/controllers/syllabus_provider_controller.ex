defmodule QuizGeneratorWeb.SyllabusProviderController do
  use QuizGeneratorWeb, :controller

  alias QuizGeneratorWeb.SharedView
  alias QuizGeneratorWeb.SyllabusProviderContext

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    {records, meta} = SyllabusProviderContext.fetch_active_paginated(params)

    render(conn, "index.json", records: records, meta: meta)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    case SyllabusProviderContext.create(params) do
      {:ok, _syllabus_provider} ->
        conn |> put_view(SharedView) |> render("success.json", %{data: %{message: "Created"}})

      error ->
        QuizGeneratorWeb.FallbackController.call(conn, error)
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    case SyllabusProviderContext.fetch_by_id(id) do
      nil -> QuizGeneratorWeb.FallbackController.call(conn, {:error, :not_found})
      syllabus_provider -> render(conn, "show.json", syllabus_provider: syllabus_provider)
    end
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id} = params) do
    with syllabus_provider when not is_nil(syllabus_provider) <-
           SyllabusProviderContext.fetch_by_id(id),
         {:ok, _updated_syllabus_provider} <-
           SyllabusProviderContext.update(syllabus_provider, params) do
      conn |> put_view(SharedView) |> render("success.json", %{data: %{message: "Updated"}})
    else
      nil -> {:error, :not_found}
      error -> error
    end
  end

  @spec deactivate(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def deactivate(conn, %{"id" => id}) do
    with syllabus_provider when not is_nil(syllabus_provider) <-
           SyllabusProviderContext.fetch_by_id(id),
         {:ok, _updated_syllabus_provider} <-
           SyllabusProviderContext.deactivate(syllabus_provider) do
      conn |> put_view(SharedView) |> render("success.json", %{data: %{message: "Deactivated"}})
    else
      nil -> {:error, :not_found}
      error -> error
    end
  end
end
