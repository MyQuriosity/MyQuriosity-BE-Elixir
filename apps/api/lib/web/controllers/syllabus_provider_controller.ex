defmodule Api.SyllabusProviderController do
  use MyQuriosityWeb, :controller

  alias Api.SharedView
  alias Api.SyllabusProviderContext
  alias Data.SyllabusProvider

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    {:ok, result} = SyllabusProviderContext.apply_filter(params)

    render(conn, "index.json", records: result.records, meta: result.meta)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, _syllabus_provider} <- SyllabusProviderContext.create(params) do
      conn |> put_view(SharedView) |> render("success.json", %{data: %{message: "Created"}})
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, %SyllabusProvider{} = syllabus_provider} <- SyllabusProviderContext.fetch_by_id(id) do
      render(conn, "show.json", syllabus_provider: syllabus_provider)
    end
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id} = params) do
    with {:ok, %SyllabusProvider{} = syllabus_provider} <-
           SyllabusProviderContext.fetch_by_id(id),
         {:ok, _updated_syllabus_provider} <-
           SyllabusProviderContext.update(syllabus_provider, params) do
      conn |> put_view(SharedView) |> render("success.json", %{data: %{message: "Updated"}})
    end
  end

  @spec deactivate(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def deactivate(conn, %{"id" => id}) do
    with {:ok, %SyllabusProvider{} = syllabus_provider} <-
           SyllabusProviderContext.fetch_by_id(id),
         {:ok, _updated_syllabus_provider} <-
           SyllabusProviderContext.deactivate(syllabus_provider) do
      conn |> put_view(SharedView) |> render("success.json", %{data: %{message: "Deactivated"}})
    end
  end
end
