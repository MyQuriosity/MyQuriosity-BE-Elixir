defmodule QuizGeneratorWeb.QuestionController do
  use QuizGeneratorWeb, :controller

  alias QuizGenerator.QuestionContext

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"questions" => questions_params, "topic_id" => topic_id}) do
    with {:ok, _} <-
           QuestionContext.create_quiz_with_questions_and_options(
             questions_params,
             topic_id
           ) do
      conn
      |> put_status(:created)
      |> json(%{message: "Quiz created successfully"})
    end
  end

  def create(_conn, _params), do: {:error, "Some parameters are missing"}

  def update(conn, %{"id" => id} = params) do
   with {:ok, question} <- QuestionContext.get_question_by_id(id),
    {:ok, _} <- QuestionContext.update_question(question, params) do
      json(conn, %{message: "Question updated successfully"})
  end
end

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    {records, meta} = QuestionContext.fetch_paginated(params)
    render(conn, "index.json", records: records, meta: meta)
  end
end
