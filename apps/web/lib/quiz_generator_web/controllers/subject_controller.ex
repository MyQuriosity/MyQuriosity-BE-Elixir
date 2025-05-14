defmodule Web.SubjectController do
  use MyQuriosityWeb, :controller

  alias Web.SharedView
  alias Web.SubjectContext

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    {records, meta} = SubjectContext.apply_filter(params)

    render(conn, "index.json", records: records, meta: meta)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, _syllabus_provider} <- SubjectContext.create(params) do
      conn |> put_view(SharedView) |> render("success.json", %{data: %{message: "Created"}})
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, subject} <- SubjectContext.fetch_by_id(id) do
      render(conn, "show.json", subject: subject)
    end
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id} = params) do
    with {:ok, subject} <- SubjectContext.fetch_by_id(id),
         {:ok, _updated_subject} <-
           SubjectContext.update(subject, params) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "Subject successfully updated"}})
    end
  end

  @spec deactivate(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def deactivate(conn, %{"id" => id}) do
    with {:ok, subject} <- SubjectContext.fetch_by_id(id),
         {:ok, _deactivated_subject} <- SubjectContext.deactivate(subject) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "Subject successfully deactivated"}})
    end
  end

  @spec grade_subjects(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def grade_subjects(conn, %{"id" => id} = params) do
    {records, meta} = SubjectContext.fetch_paginated_grade_subjects(id, params)

    render(conn, "index.json", records: records, meta: meta)
  end
end
