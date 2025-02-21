defmodule QuizGeneratorWeb.QuizController do
  use QuizGeneratorWeb, :controller

  alias QuizGenerator.QuizContext

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"questions" => questions_params, "additional_info" => additional_info}) do
    case QuizContext.create_quiz_with_questions_and_options(questions_params, additional_info) do
      {:ok, _} ->
        conn
        |> put_status(:created)
        |> json(%{message: "Quiz created successfully"})
    end
  end

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    {records, meta} = QuizContext.fetch_paginated(params)
    render(conn, "index.json", records: records, meta: meta)
  end
end
