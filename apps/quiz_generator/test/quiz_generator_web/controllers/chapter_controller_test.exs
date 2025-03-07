defmodule QuizGeneratorWeb.ChapterControllerTest do
  use QuizGeneratorWeb.ConnCase
  import Phoenix.ConnTest

  alias QuizGenerator.Guardian.Plug, as: GuardianPlug

  describe "Create chapter" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject
    ]

    test "Returns created message", %{conn: conn, subject: subject} do
      resp = post(conn, "/api/v1/chapters", %{"title" => "Short Tales", subject_id: subject.id})
      assert %{"message" => "Created"} == json_response(resp, 200)
    end

    test "Return error without title", %{conn: conn} do
      resp = post(conn, "/api/v1/chapters", %{"description" => "Punjab Textbook Board"})

      assert %{
               "error" => %{
                 "code" => 422,
                 "errors" => %{"title" => ["can't be blank"], "subject_id" => ["can't be blank"]},
                 "message" => "Unprocessable entity"
               }
             } ==
               json_response(resp, 422)
    end
  end

  describe "Update chapter" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject,
      :create_chapter
    ]

    test "Returns updated message", %{conn: conn, chapter: chapter} do
      resp =
        put(conn, "/api/v1/chapters/#{chapter.id}", %{
          title: "Updated Chapter",
          description: "Updated Description"
        })

      assert %{"message" => "Chapter successfully updated"} == json_response(resp, 200)
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

  describe "filter chapters" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject,
      :create_chapter
    ]

    test "filter chapter with title", %{
      conn: conn,
      chapter: chapter,
      subject: subject,
      syllabus_provider: syllabus_provider,
      grade: grade
    } do
      resp =
        conn
        |> post("/api/v1/chapters/filters", %{"title" => %{"$ILIKE" => "%a%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "description" => nil,
                   "id" => chapter.id,
                   "title" => "Short Tales",
                   "number" => 1,
                   "subject" => %{
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
                     "grade_id" => grade.id,
                     "id" => subject.id,
                     "title" => "English"
                   },
                   "subject_id" => subject.id
                 }
               ]
             } ==
               json_response(resp, 200)
    end

    test "filter chapter with wrong title word", %{conn: conn} do
      resp =
        conn
        |> post("/api/v1/chapters/filters", %{"title" => %{"$ILIKE" => "%primary%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 0, "skip" => 0, "total_records" => 0},
               "records" => []
             } ==
               json_response(resp, 200)
    end

    test "filter chapter with inserted_at", %{
      conn: conn,
      subject: subject,
      grade: grade,
      syllabus_provider: syllabus_provider
    } do
      chapter_2 =
        insert(:chapter,
          title: "Chapter 2",
          subject_id: subject.id,
          inserted_at: DateTime.add(DateTime.utc_now(), 2, :day)
        )

      resp =
        conn
        |> post("/api/v1/chapters/filters", %{
          "inserted_at" => %{"$GT" => DateTime.utc_now()}
        })

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "description" => nil,
                   "id" => chapter_2.id,
                   "title" => "Chapter 2",
                   "number" => 1,
                   "subject" => %{
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
                     "grade_id" => grade.id,
                     "id" => subject.id,
                     "title" => "English"
                   },
                   "subject_id" => subject.id
                 }
               ]
             } == json_response(resp, 200)
    end
  end

  describe "Deactivate chapter" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject,
      :create_chapter
    ]

    test "Returns deactivated message", %{conn: conn, chapter: chapter} do
      resp = delete(conn, "/api/v1/chapters/#{chapter.id}")
      assert %{"message" => "Chapter successfully deactivated"} == json_response(resp, 200)
    end

    test "Return error with incorrect id", %{conn: conn, user: user} do
      resp = delete(conn, "/api/v1/chapters/#{user.id}")

      assert %{
               "error" => %{
                 "code" => 404,
                 "message" => "Not found"
               }
             } == json_response(resp, 404)
    end
  end

  defp create_chapter(context) do
    {:ok, chapter: insert(:chapter, subject_id: context.subject.id)}
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
