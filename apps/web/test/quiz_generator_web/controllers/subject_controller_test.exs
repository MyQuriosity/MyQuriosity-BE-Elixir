defmodule Web.SubjectControllerTest do
  use Web.ConnCase
  import Phoenix.ConnTest

  alias Web.Guardian.Plug, as: GuardianPlug

  describe "create subject" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade
    ]

    test "Returns created message", %{conn: conn, grade: grade} do
      resp =
        post(conn, "/api/v1/subjects", %{
          "title" => "Science",
          "course_code" => "Sci",
          "grade_id" => grade.id
        })

      assert %{"message" => "Created"} == json_response(resp, 200)
    end

    test "Return error without title", %{conn: conn} do
      resp = post(conn, "/api/v1/subjects", %{"description" => "Punjab Textbook Board"})

      assert %{
               "error" => %{
                 "code" => 422,
                 "errors" => %{
                   "title" => ["can't be blank"],
                   "course_code" => ["can't be blank"],
                   "grade_id" => ["can't be blank"]
                 },
                 "message" => "Unprocessable entity"
               }
             } ==
               json_response(resp, 422)
    end
  end

  describe "update subject" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject
    ]

    test "Returns updated message", %{conn: conn, subject: subject} do
      resp =
        put(conn, "/api/v1/subjects/#{subject.id}", %{
          title: "Updated Subject",
          description: "Updated Description"
        })

      assert %{"message" => "Subject successfully updated"} == json_response(resp, 200)
    end

    test "Return error with incorrect id", %{conn: conn, user: user} do
      resp =
        put(conn, "/api/v1/subjects/#{user.id}", %{
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

  describe "filter subject" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject
    ]

    test "filter subject with title", %{
      conn: conn,
      subject: subject,
      grade: grade,
      syllabus_provider: syllabus_provider
    } do
      resp =
        conn
        |> post("/api/v1/subjects/filters", %{"title" => %{"$ILIKE" => "%eng%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "id" => subject.id,
                   "title" => "English",
                   "color" => "primary-purple",
                   "course_code" => "Eng",
                   "grade_id" => grade.id,
                   "grade" => %{
                     "description" => "Primary class",
                     "id" => grade.id,
                     "syllabus_provider" => %{
                       "description" => "For Punjab schools",
                       "id" => syllabus_provider.id,
                       "title" => "Punjab Textbook Board"
                     },
                     "syllabus_provider_id" => syllabus_provider.id,
                     "title" => "Grade 1"
                   }
                 }
               ]
             } ==
               json_response(resp, 200)
    end

    test "filter subject with wrong title word", %{conn: conn} do
      resp =
        conn
        |> post("/api/v1/subjects/filters", %{"title" => %{"$ILIKE" => "%sci%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 0, "skip" => 0, "total_records" => 0},
               "records" => []
             } ==
               json_response(resp, 200)
    end

    test "filter subject with course_code", %{
      conn: conn,
      subject: subject,
      grade: grade,
      syllabus_provider: syllabus_provider
    } do
      resp =
        conn
        |> post("/api/v1/subjects/filters", %{"course_code" => %{"$ILIKE" => "%eng%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "id" => subject.id,
                   "title" => "English",
                   "color" => "primary-purple",
                   "course_code" => "Eng",
                   "grade" => %{
                     "description" => "Primary class",
                     "id" => grade.id,
                     "syllabus_provider" => %{
                       "description" => "For Punjab schools",
                       "id" => syllabus_provider.id,
                       "title" => "Punjab Textbook Board"
                     },
                     "syllabus_provider_id" => syllabus_provider.id,
                     "title" => "Grade 1"
                   },
                   "grade_id" => grade.id
                 }
               ]
             } ==
               json_response(resp, 200)
    end

    test "filter subject with inserted_at", %{
      conn: conn,
      grade: grade,
      syllabus_provider: syllabus_provider
    } do
      subject_2 =
        insert(:subject,
          title: "Science",
          course_code: "sci",
          grade_id: grade.id,
          inserted_at: DateTime.add(DateTime.utc_now(), 2, :day)
        )

      resp =
        conn
        |> post("/api/v1/subjects/filters", %{
          "inserted_at" => %{"$GT" => DateTime.utc_now()}
        })

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "id" => subject_2.id,
                   "title" => "Science",
                   "color" => "primary-purple",
                   "course_code" => "sci",
                   "grade_id" => grade.id,
                   "grade" => %{
                     "description" => "Primary class",
                     "id" => grade.id,
                     "syllabus_provider" => %{
                       "description" => "For Punjab schools",
                       "id" => syllabus_provider.id,
                       "title" => "Punjab Textbook Board"
                     },
                     "syllabus_provider_id" => syllabus_provider.id,
                     "title" => "Grade 1"
                   }
                 }
               ]
             } == json_response(resp, 200)
    end
  end

  describe "Deactivate subject" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject
    ]

    test "Returns deactivated message", %{conn: conn, subject: subject} do
      resp = delete(conn, "/api/v1/subjects/#{subject.id}")
      assert %{"message" => "Subject successfully deactivated"} == json_response(resp, 200)
    end

    test "Return error with incorrect id", %{conn: conn, user: user} do
      resp = delete(conn, "/api/v1/subjects/#{user.id}")

      assert %{
               "error" => %{
                 "code" => 404,
                 "message" => "Not found"
               }
             } == json_response(resp, 404)
    end
  end

  defp create_subject(context) do
    {:ok, subject: insert(:subject, grade_id: context.grade.id)}
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
