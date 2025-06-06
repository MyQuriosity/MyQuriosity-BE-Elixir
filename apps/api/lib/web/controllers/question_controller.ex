defmodule Api.QuestionController do
  use MyQuriosityWeb, :controller

  alias Api.QuestionContext

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"questions" => questions_params, "topic_id" => topic_id}) do
    # with {:ok, _} <- QuestionContext.validate_quiz_payload?(questions_params),
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

  def deactivate(conn, %{"id" => id}) do
    with {:ok, question} <- QuestionContext.get_question_by_id(id),
         {:ok, _} <- QuestionContext.delete_question(question) do
      json(conn, %{message: "Question deleted successfully"})
    end
  end

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    {:ok, result} = QuestionContext.fetch_paginated(params)
    render(conn, "index.json", records: result.records, meta: result.meta)
  end
end
