defmodule QuizGeneratorWeb.SyllabusProviderControllerTest do
  use QuizGeneratorWeb.ConnCase
  import Phoenix.ConnTest

  alias QuizGenerator.Guardian.Plug, as: GuardianPlug

  describe "filter syllabus_provider" do
    setup [
      :create_user,
      :create_conn,
      :create_syllabus_provider
    ]

    test "filter syllabus_provider with title",
         %{
           conn: conn,
           user: user
         } do

      _resp =
        conn
        |> post("/api/v1/syllabus_providers/filters", %{"title" => %{"$ILIKE" => "%a%"}})
    end
  end

  defp create_syllabus_provider(_) do
    {:ok, syllabus_provider: insert(:syllabus_provider)}
  end

  defp create_user(_) do
    {:ok, user: insert(:user)}
  end

  defp create_conn(context) do
    {:ok, conn: GuardianPlug.sign_in(build_conn(), context.user)}
  end
end
