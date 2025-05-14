defmodule Api.GradeControllerTest do
  use Api.ConnCase
  import Phoenix.ConnTest

  alias Api.Guardian.Plug, as: GuardianPlug

  describe "create grade" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn
    ]

    test "Returns created message", %{conn: conn} do
      resp = post(conn, "/api/v1/grades", %{"title" => "Grade 1"})
      assert %{"message" => "Created"} == json_response(resp, 200)
    end

    test "Return error without title", %{conn: conn} do
      resp = post(conn, "/api/v1/grades", %{"description" => "Punjab Textbook Board"})

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

  describe "update grade" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade
    ]

    test "Returns updated message", %{conn: conn, grade: grade} do
      resp =
        put(conn, "/api/v1/grades/#{grade.id}", %{
          title: "Updated Grade",
          description: "Updated Description"
        })

      assert %{"message" => "Grade successfully updated"} == json_response(resp, 200)
    end

    test "Return error with incorrect id", %{conn: conn, user: user} do
      resp =
        put(conn, "/api/v1/grades/#{user.id}", %{
          title: "updated_grade",
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
      :create_syllabus_provider,
      :create_conn,
      :create_grade
    ]

    test "filter grade with title", %{
      conn: conn,
      grade: grade,
      syllabus_provider: syllabus_provider
    } do
      resp =
        conn
        |> post("/api/v1/grades/filters", %{"title" => %{"$ILIKE" => "%a%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "description" => "Primary class",
                   "id" => grade.id,
                   "title" => "Grade 1",
                   "syllabus_provider_id" => syllabus_provider.id,
                   "syllabus_provider" => nil
                 }
               ]
             } ==
               json_response(resp, 200)
    end

    test "filter grade with wrong title word", %{conn: conn} do
      resp =
        conn
        |> post("/api/v1/grades/filters", %{"title" => %{"$ILIKE" => "%primary%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 0, "skip" => 0, "total_records" => 0},
               "records" => []
             } ==
               json_response(resp, 200)
    end

    test "filter grade with inserted_at", %{conn: conn, syllabus_provider: syllabus_provider} do
      grade_2 =
        insert(:grade,
          title: "Grade 2",
          syllabus_provider_id: syllabus_provider.id,
          inserted_at: DateTime.add(DateTime.utc_now(), 2, :day)
        )

      resp =
        conn
        |> post("/api/v1/grades/filters", %{
          "inserted_at" => %{"$GT" => DateTime.utc_now()}
        })

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "description" => "Primary class",
                   "id" => grade_2.id,
                   "title" => "Grade 2",
                   "syllabus_provider_id" => syllabus_provider.id,
                   "syllabus_provider" => nil
                 }
               ]
             } ==
               json_response(resp, 200)
    end
  end

  describe "Deactivate syllabus_provider" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade
    ]

    test "Returns deactivated message", %{conn: conn, grade: grade} do
      resp = delete(conn, "/api/v1/grades/#{grade.id}")
      assert %{"message" => "Grade deactivated successfully"} == json_response(resp, 200)
    end

    test "Return error with incorrect id", %{conn: conn, user: user} do
      resp = delete(conn, "/api/v1/grades/#{user.id}")

      assert %{
               "error" => %{
                 "code" => 404,
                 "message" => "Not found"
               }
             } == json_response(resp, 404)
    end
  end

  defp create_grade(context) do
    {:ok, grade: insert(:grade, syllabus_provider_id: context.syllabus_provider.id)}
  end

  defp create_syllabus_provider(_) do
    {:ok, syllabus_provider: insert(:syllabus_provider)}
  end

  defp create_user(_) do
    {:ok, user: insert(:user)}
  end

  defp create_conn(context) do
    {:ok,
     conn:
       build_conn()
       |> GuardianPlug.sign_in(context.user)
       |> put_req_header("x-syllabus-provider-id", "#{context.syllabus_provider.id}")}
  end
end
