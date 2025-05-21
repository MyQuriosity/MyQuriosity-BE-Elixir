defmodule Api.TopicControllerTest do
  use Api.ConnCase
  import Phoenix.ConnTest

  alias Api.Guardian.Plug, as: GuardianPlug

  describe "create topic" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject,
      :create_chapter
    ]

    test "Returns created message", %{conn: conn, chapter: chapter} do
      resp =
        post(conn, "/api/v1/topics", %{
          "title" => "The Riding Hood",
          "number" => 1,
          "chapter_id" => chapter.id
        })

      assert %{"message" => "Created"} == json_response(resp, 200)
    end

    test "Return error without title", %{conn: conn} do
      resp = post(conn, "/api/v1/topics", %{"description" => "Short story"})

      assert %{
               "error" => %{
                 "code" => 422,
                 "errors" => %{
                   "title" => ["can't be blank"],
                   "chapter_id" => ["can't be blank"],
                   "number" => ["can't be blank"]
                 },
                 "message" => "Unprocessable entity"
               }
             } ==
               json_response(resp, 422)
    end
  end

  describe "update topic" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject,
      :create_chapter,
      :create_topic
    ]

    test "Returns updated message", %{conn: conn, topic: topic} do
      resp =
        put(conn, "/api/v1/topics/#{topic.id}", %{
          title: "Updated Topic",
          description: "Updated Description"
        })

      assert %{"message" => "Topic successfully updated"} == json_response(resp, 200)
    end

    test "Return error with incorrect id", %{conn: conn, user: user} do
      resp =
        put(conn, "/api/v1/topics/#{user.id}", %{
          title: "Updated Topic",
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

  describe "filter topic" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject,
      :create_chapter,
      :create_topic
    ]

    test "filter topic with title", %{
      conn: conn,
      topic: topic,
      chapter: chapter,
      subject: subject,
      grade: grade,
      syllabus_provider: syllabus_provider
    } do
      resp =
        conn
        |> post("/api/v1/topics/filters", %{"title" => %{"$ILIKE" => "%hood%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "description" => nil,
                   "id" => topic.id,
                   "title" => "The Riding Hood",
                   "number" => 1,
                   "chapter" => %{
                     "description" => nil,
                     "id" => chapter.id,
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
                     "subject_id" => subject.id,
                     "title" => "Short Tales"
                   },
                   "chapter_id" => chapter.id
                 }
               ]
             } ==
               json_response(resp, 200)
    end

    test "filter topic with wrong title word", %{conn: conn} do
      resp =
        conn
        |> post("/api/v1/topics/filters", %{"title" => %{"$ILIKE" => "%primary%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 0, "skip" => 0, "total_records" => 0},
               "records" => []
             } ==
               json_response(resp, 200)
    end

    test "filter topic with inserted_at", %{
      conn: conn,
      chapter: chapter,
      grade: grade,
      subject: subject,
      syllabus_provider: syllabus_provider
    } do
      topic_2 =
        insert(:topic,
          title: "Hansel and Gretel",
          chapter_id: chapter.id,
          inserted_at: DateTime.add(DateTime.utc_now(), 2, :day)
        )

      resp =
        conn
        |> post("/api/v1/topics/filters", %{
          "inserted_at" => %{"$GT" => DateTime.utc_now()}
        })

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "description" => nil,
                   "id" => topic_2.id,
                   "title" => "Hansel and Gretel",
                   "number" => 1,
                   "chapter" => %{
                     "description" => nil,
                     "id" => chapter.id,
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
                     "subject_id" => subject.id,
                     "title" => "Short Tales"
                   },
                   "chapter_id" => chapter.id
                 }
               ]
             } == json_response(resp, 200)
    end
  end

  describe "Deactivate topic" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject,
      :create_chapter,
      :create_topic
    ]

    test "Returns deactivated message", %{conn: conn, topic: topic} do
      resp = delete(conn, "/api/v1/topics/#{topic.id}")
      assert %{"message" => "Topic successfully deactivated"} == json_response(resp, 200)
    end

    test "Return error with incorrect id", %{conn: conn, user: user} do
      resp = delete(conn, "/api/v1/topics/#{user.id}")

      assert %{
               "error" => %{
                 "code" => 404,
                 "message" => "Not found"
               }
             } == json_response(resp, 404)
    end
  end

  defp create_topic(context) do
    {:ok, topic: insert(:topic, chapter_id: context.chapter.id)}
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
