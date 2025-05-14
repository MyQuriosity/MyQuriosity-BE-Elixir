defmodule Api.QuestionControllerTest do
  use Api.ConnCase
  import Phoenix.ConnTest

  alias Api.Guardian.Plug, as: GuardianPlug

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
          "topic_id" => topic.id,
          "questions" => [
            %{
              "question_number" => 1,
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

      assert %{"error" => %{"code" => 422, "message" => "Some parameters are missing"}} ==
               json_response(resp, 422)
    end
  end

  describe "Delete question" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject,
      :create_chapter,
      :create_topic,
      :create_question,
      :create_option
    ]

    test "Returns created message", %{conn: conn, question: question} do
      resp = post(conn, "/api/v1/mcqs/filters", %{"id" => %{"$EQUAL" => question.id}})
      %{"meta" => _meta, "records" => records} = json_response(resp, 200)
      fetched_question = List.first(records)
      assert is_nil(fetched_question["deactivated_at"])

      assert Enum.all?(fetched_question["options"], fn option ->
               is_nil(option["deactivated_at"])
             end)

      assert %{"message" => "Question deleted successfully"} ==
               conn |> delete("/api/v1/mcqs/#{question.id}") |> json_response(200)

      resp = post(conn, "/api/v1/mcqs/filters", %{"id" => %{"$EQUAL" => question.id}})
      %{"meta" => _meta, "records" => records} = json_response(resp, 200)
      assert records == []
    end
  end

  describe "filter questions" do
    setup [
      :create_user,
      :create_syllabus_provider,
      :create_conn,
      :create_grade,
      :create_subject,
      :create_chapter,
      :create_topic,
      :create_question
    ]

    test "filter question with title", %{
      conn: conn,
      topic: topic,
      chapter: chapter,
      subject: subject,
      syllabus_provider: syllabus_provider,
      grade: grade,
      question: question
    } do
      resp =
        post(conn, "/api/v1/mcqs/filters", %{"title" => %{"$ILIKE" => "%the following elements%"}})

      assert %{
               "meta" => %{"limit" => 10, "pages" => 1, "skip" => 0, "total_records" => 1},
               "records" => [
                 %{
                   "id" => question.id,
                   "title" =>
                     "Which of the following elements has the highest electronegativity?",
                   "topic" => %{
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
                           "syllabus_provider" => nil,
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
                     "chapter_id" => chapter.id,
                     "description" => nil,
                     "number" => 1,
                     "id" => topic.id,
                     "title" => "The Riding Hood"
                   },
                   "topic_id" => topic.id,
                   "options" => [],
                   "deactivated_at" => nil
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
      topic: topic,
      syllabus_provider: syllabus_provider
    } do
      question_2 =
        insert(:question,
          title: "What is the primary purpose of narow growth in crystal formation?",
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
                   "id" => question_2.id,
                   "title" => "What is the primary purpose of narow growth in crystal formation?",
                   "topic" => %{
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
                           "syllabus_provider" => nil,
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
                     "chapter_id" => chapter.id,
                     "description" => nil,
                     "number" => 1,
                     "id" => topic.id,
                     "title" => "The Riding Hood"
                   },
                   "topic_id" => topic.id,
                   "options" => [],
                   "deactivated_at" => nil
                 }
               ]
             } == json_response(resp, 200)
    end
  end

  defp create_option(context) do
    {:ok,
     option_1: insert(:option, question_id: context.question.id, title: "Oxygen"),
     option_2:
       insert(:option, question_id: context.question.id, title: "Fluorine", is_correct: true),
     option_3: insert(:option, question_id: context.question.id, title: "Chlorine"),
     option_4: insert(:option, question_id: context.question.id, title: "Nitrogen")}
  end

  defp create_question(context) do
    {:ok,
     question:
       insert(:question, %{
         topic_id: context.topic.id,
         title: "Which of the following elements has the highest electronegativity?"
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
