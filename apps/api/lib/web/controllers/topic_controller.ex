defmodule Api.TopicController do
  use MyQuriosityWeb, :controller

  alias Api.SharedView
  alias Api.TopicContext

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    {:ok, result} = TopicContext.apply_filter(params)

    render(conn, "index.json", records: result.records, meta: result.meta)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, _topic} <- TopicContext.create(params) do
      conn |> put_view(SharedView) |> render("success.json", %{data: %{message: "Created"}})
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, topic} <- TopicContext.fetch_by_id(id) do
      render(conn, "show.json", topic: topic)
    end
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id} = params) do
    with {:ok, topic} <- TopicContext.fetch_by_id(id),
         {:ok, _updated_topic} <-
           TopicContext.update(topic, params) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "Topic successfully updated"}})
    end
  end

  @spec deactivate(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def deactivate(conn, %{"id" => id}) do
    with {:ok, topic} <- TopicContext.fetch_by_id(id),
         {:ok, _deactivated_topic} <- TopicContext.deactivate(topic) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "Topic successfully deactivated"}})
    else
      nil -> {:error, :not_found}
      error -> error
    end
  end

  @spec chapter_topics(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def chapter_topics(conn, %{"id" => id} = params) do
    {:ok, result} = TopicContext.fetch_paginated_chapter_topics(id, params)

    render(conn, "index.json", records: result.records, meta: result.meta)
  end
end
