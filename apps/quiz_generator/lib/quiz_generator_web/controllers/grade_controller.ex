defmodule QuizGeneratorWeb.GradeController do
  use QuizGeneratorWeb, :controller

  alias QuizGeneratorWeb.SharedView
  alias QuizGenerator.GradeContext

  plug QuizGenerator.Plug.SyllabusProviderPlug when action in [:create]

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    {records, meta} = GradeContext.apply_filter(params)

    render(conn, "index.json", records: records, meta: meta)
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
    {records, meta} = GradeContext.apply_filter(params)
    render(conn, "index.json", records: records, meta: meta)
  end
end
