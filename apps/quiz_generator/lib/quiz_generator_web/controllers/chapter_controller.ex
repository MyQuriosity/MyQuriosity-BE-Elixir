defmodule QuizGeneratorWeb.ChapterController do
  use QuizGeneratorWeb, :controller

  alias QuizGeneratorWeb.SharedView
  alias QuizGeneratorWeb.Context.ChapterContext

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    {records, meta} = ChapterContext.apply_filter(params)

    render(conn, "index.json", records: records, meta: meta)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, _chapter} <- ChapterContext.create(params) do
      conn |> put_view(SharedView) |> render("success.json", %{data: %{message: "Created"}})
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, chapter} <- ChapterContext.fetch_by_id(id) do
      render(conn, "show.json", chapter: chapter)
    end
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id} = params) do
    with {:ok, chapter} <- ChapterContext.fetch_by_id(id),
         {:ok, _updated_chapter} <-
           ChapterContext.update(chapter, params) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "Chapter successfully updated"}})
    end
  end

  @spec deactivate(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def deactivate(conn, %{"id" => id}) do
    with {:ok, chapter} <- ChapterContext.fetch_by_id(id),
         {:ok, _deactivated_chapter} <-
           ChapterContext.deactivate(chapter) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "Chapter successfully deactivated"}})
    else
      nil -> {:error, :not_found}
      error -> error
    end
  end

  @spec subject_chapters(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def subject_chapters(conn, %{"id" => id} = params) do
    {records, meta} = ChapterContext.fetch_paginated_subject_chapters(id, params)

    render(conn, "index.json", records: records, meta: meta)
  end
end
