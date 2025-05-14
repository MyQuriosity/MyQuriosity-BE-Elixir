defmodule Web.SyllabusProviderControllerTest do
  use Web.ConnCase
  import Phoenix.ConnTest

  alias Web.Guardian.Plug, as: GuardianPlug

  describe "create syllabus_provider" do
    setup [
      :create_user,
      :create_conn
    ]

    test "Returns created message", %{conn: conn} do
      resp = post(conn, "/api/v1/syllabus_providers", %{"title" => "Punjab Textbook Board"})
      assert %{"message" => "Created"} == json_response(resp, 200)
    end

    test "Return error without title", %{conn: conn} do
      resp = post(conn, "/api/v1/syllabus_providers", %{"description" => "Punjab Textbook Board"})

      assert %{
               "error" => %{
                 "code" => 422,
                 "errors" => %{"title" => ["can't be blank"]},
                 "message" => "Unprocessable entity"
               }
             } ==
               json_response(resp, 422)
    end
  end

  describe "update syllabus_provider" do
    setup [
      :create_user,
      :create_conn,
      :create_syllabus_provider
    ]

    test "Returns updated syllabus provider", %{conn: conn, syllabus_provider: syllabus_provider} do
      resp =
        put(conn, "/api/v1/syllabus_providers/#{syllabus_provider.id}", %{
          title: "Updated Syllabus Provider",
          description: "Updated Description"
        })

      assert %{"message" => "Updated"} == json_response(resp, 200)
    end

    test "Return error with incorrect id", %{conn: conn, user: user} do
      resp =
        put(conn, "/api/v1/syllabus_providers/#{user.id}", %{
          title: "updated_test_topic",
          description: "updated_test_description"
        })

      assert %{
               "error" => %{
                 "code" => 404,
                 "message" => "Not found"
               }
             } == json_response(resp, 404)
    end
  end

  describe "filter syllabus_provider" do
    setup [
      :create_user,
      :create_conn,
      :create_syllabus_provider
    ]

    test "filter syllabus_provider with title", %{
      conn: conn,
      syllabus_provider: syllabus_provider
    } do
      resp =
        conn
        |> post("/api/v1/syllabus_providers/filters", %{"title" => %{"$ILIKE" => "%a%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "description" => "For Punjab schools",
                   "id" => syllabus_provider.id,
                   "title" => "Punjab Textbook Board"
                 }
               ]
             } == json_response(resp, 200)
    end

    test "filter syllabus_provider with inserted_at", %{conn: conn} do
      syllabus_provider_2 =
        insert(:syllabus_provider, inserted_at: DateTime.add(DateTime.utc_now(), 2, :day))

      resp =
        conn
        |> post("/api/v1/syllabus_providers/filters", %{
          "inserted_at" => %{"$GT" => DateTime.utc_now()}
        })

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "description" => "For Punjab schools",
                   "id" => syllabus_provider_2.id,
                   "title" => "Punjab Textbook Board"
                 }
               ]
             } == json_response(resp, 200)
    end
  end

  describe "Deactivate syllabus_provider" do
    setup [
      :create_user,
      :create_conn,
      :create_syllabus_provider
    ]

    test "Returns updated syllabus provider", %{conn: conn, syllabus_provider: syllabus_provider} do
      resp = delete(conn, "/api/v1/syllabus_providers/#{syllabus_provider.id}")
      assert %{"message" => "Deactivated"} == json_response(resp, 200)
    end

    test "Return error with incorrect id", %{conn: conn, user: user} do
      resp = delete(conn, "/api/v1/syllabus_providers/#{user.id}")

      assert %{
               "error" => %{
                 "code" => 404,
                 "message" => "Not found"
               }
             } == json_response(resp, 404)
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
