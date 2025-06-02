defmodule Api.GradeController do
  use MyQuriosityWeb, :controller

  alias Api.GradeContext
  alias Api.SharedView

  plug Api.Plug.SyllabusProviderPlug when action in [:create]

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    {:ok, result} = GradeContext.apply_filter(params)

    render(conn, "index.json", records: result.records, meta: result.meta)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, _grade} <- GradeContext.create(params) do
      conn |> put_view(SharedView) |> render("success.json", %{data: %{message: "Created"}})
    end
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, grade} <- GradeContext.fetch_by_id(id) do
      render(conn, "show.json", grade: grade)
    end
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id} = params) do
    with {:ok, grade} <- GradeContext.fetch_by_id(id),
         {:ok, _updated_grade} <- GradeContext.update(grade, params) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "Grade successfully updated"}})
    end
  end

  @spec deactivate(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def deactivate(conn, %{"id" => id}) do
    with {:ok, grade} <- GradeContext.fetch_by_id(id),
         {:ok, _deactivated_grade} <- GradeContext.deactivate(grade) do
      conn
      |> put_view(SharedView)
      |> render("success.json", %{data: %{message: "Grade deactivated successfully"}})
    end
  end

  def filter(conn, params) do
    {:ok, result} = GradeContext.apply_filter(params)
    render(conn, "index.json", records: result.records, meta: result.meta)
  end
end
