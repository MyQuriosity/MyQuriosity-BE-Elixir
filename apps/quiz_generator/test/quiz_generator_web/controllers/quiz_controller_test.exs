defmodule QuizGeneratorWeb.QuizControllerTest do
  use QuizGeneratorWeb.ConnCase
  import Phoenix.ConnTest

  alias QuizGenerator.Guardian.Plug, as: GuardianPlug

  describe "create quiz" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject,
      :create_chapter,
      :create_topic
    ]

    test "Returns created message", %{conn: conn, topic: topic} do
      resp =
        post(conn, "/api/v1/generate_quiz", %{
          "additional_info" => %{"title" => "Quiz 1", "topic_id" => topic.id},
          "questions" => [
            %{
              "title" => "What is the primary purpose of narow growth in crystal formation?",
              "options" => %{
                "A" => "Random arrangement of atoms",
                "B" => "Controlled directional growth",
                "C" => "Rapid uncontrolled growth",
                "D" => "Spherical expansion"
              },
              "answers" => [
                "A",
                "B"
              ]
            }
          ]
        })

      assert %{"message" => "Quiz created successfully"} == json_response(resp, 201)
    end

    test "Return error without title", %{conn: conn} do
      resp =
        post(conn, "/api/v1/generate_quiz", %{
          "additional_info" => %{"title" => "Quiz 1"},
          "questions" => []
        })

      assert %{
               "error" => %{
                 "code" => 422,
                 "errors" => %{
                   "topic_id" => ["can't be blank"]
                 },
                 "message" => "Unprocessable entity",
                 "index" => "quiz"
               }
             } ==
               json_response(resp, 422)
    end
  end

  describe "filter quiz" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject,
      :create_chapter,
      :create_topic,
      :create_quiz
    ]

    test "filter quiz with title", %{
      conn: conn,
      topic: topic,
      chapter: chapter,
      subject: subject,
      grade: grade,
      quiz: quiz
    } do
      resp = post(conn, "/api/v1/mcqs/filters", %{"title" => %{"$ILIKE" => "%quiz%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "id" => quiz.id,
                   "title" => "Quiz 1",
                   "questions" => [],
                   "topic" => %{
                     "chapter" => %{
                       "description" => nil,
                       "id" => chapter.id,
                       "number" => 1,
                       "subject" => %{
                         "color" => "primary-purple",
                         "course_code" => "Eng",
                         "grade" => nil,
                         "grade_id" => grade.id,
                         "id" => subject.id,
                         "title" => "English"
                       },
                       "subject_id" => subject.id,
                       "title" => "Short Tales"
                     },
                     "chapter_id" => chapter.id,
                     "description" => nil,
                     "id" => topic.id,
                     "title" => "The Riding Hood"
                   },
                   "topic_id" => topic.id
                 }
               ]
             } ==
               json_response(resp, 200)
    end

    test "filter topic with wrong title word", %{conn: conn} do
      resp =
        conn
        |> post("/api/v1/mcqs/filters", %{"title" => %{"$ILIKE" => "%quiz 2%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 0, "skip" => 0, "total_records" => 0},
               "records" => []
             } ==
               json_response(resp, 200)
    end

    test "filter quiz with inserted_at", %{
      conn: conn,
      chapter: chapter,
      grade: grade,
      subject: subject,
      topic: topic
    } do
      quiz_2 =
        insert(:quiz,
          title: "Quiz 2",
          topic_id: topic.id,
          inserted_at: DateTime.add(DateTime.utc_now(), 2, :day)
        )

      resp =
        conn
        |> post("/api/v1/mcqs/filters", %{
          "inserted_at" => %{"$GT" => DateTime.utc_now()}
        })

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "id" => quiz_2.id,
                   "title" => "Quiz 2",
                   "questions" => [],
                   "topic" => %{
                     "chapter" => %{
                       "description" => nil,
                       "id" => chapter.id,
                       "number" => 1,
                       "subject" => %{
                         "color" => "primary-purple",
                         "course_code" => "Eng",
                         "grade" => nil,
                         "grade_id" => grade.id,
                         "id" => subject.id,
                         "title" => "English"
                       },
                       "subject_id" => subject.id,
                       "title" => "Short Tales"
                     },
                     "chapter_id" => chapter.id,
                     "description" => nil,
                     "id" => topic.id,
                     "title" => "The Riding Hood"
                   },
                   "topic_id" => topic.id
                 }
               ]
             } == json_response(resp, 200)
    end
  end

  defp create_quiz(context) do
    {:ok,
     quiz:
       insert(:quiz, %{
         topic_id: context.topic.id,
         title: "Quiz 1"
       })}
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
