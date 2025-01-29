defmodule QuizGeneratorWeb.MCQsController do
  use QuizGeneratorWeb, :controller

  alias QuizGenerator.MCQs

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"questions" => questions_params, "additional_info" => additional_info}) do
    case MCQs.create_mcq_paper(questions_params, additional_info) do
      {:ok, :mcqs_paper_created} ->
        conn
        |> put_status(:created)
        |> json(%{message: "MCQ paper created successfully"})

      error ->
        Campus.FallbackController.call(conn, error)
    end
  end

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    {records, meta} = MCQs.fetch_paginated(params)
    render(conn, "index.json", records: records, meta: meta)
  end
end
