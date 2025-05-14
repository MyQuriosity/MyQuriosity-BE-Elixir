defmodule Api.Router do
  use MyQuriosityWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug(Api.Plug.RequestLogger)
  end

  pipeline :token_auth do
    plug(Api.AuthAccessPipeline)
  end

  pipeline :validate_uuid do
    plug(Campus.Plug.ValidateUUID)
  end

  pipeline :syllabus_provider_filter do
    plug(Web.Plug.SyllabusProviderFilter)
  end

  scope "/", Web do
    pipe_through [:api]
    get("/info", PublicInfoController, :version_info)
  end

  scope "/api/v1", Web do
    pipe_through :api
    post("/signup", AuthController, :signup)
    post("/setup_password", AuthController, :setup_password)
    post("/syllabus_providers/filters", SyllabusProviderController, :index)
    post("/login", AuthController, :login)
    post("/forgot_password_pre_info", AuthController, :forgot_password_pre_info)
    post("/forgot_password", AuthController, :forgot_password)
    post("/reset_password", AuthController, :reset_password)
  end

  scope "/api/v1", Web do
    pipe_through [:api, :validate_uuid, :token_auth, :syllabus_provider_filter]
    post("/syllabus_providers/filters", SyllabusProviderController, :index)
    post("/grades/filters", GradeController, :index)
    post("/subjects/filters", SubjectController, :index)
    post("/chapters/filters", ChapterController, :index)
    post("/topics/filters", TopicController, :index)
    post("/mcqs/filters", QuestionController, :index)
  end

  scope "/api/v1", Web do
    pipe_through [:api, :validate_uuid, :token_auth]
    put("/user/:id", UserController, :update)
    post("/user/update_password", UserController, :update_password)
    put("/user/reset_password/:id", UserController, :reset_password)
    post("/logout", AuthController, :logout)
    post("/syllabus_providers", SyllabusProviderController, :create)
    get("/syllabus_providers", SyllabusProviderController, :index)
    get("/syllabus_providers/:id", SyllabusProviderController, :show)
    put("/syllabus_providers/:id", SyllabusProviderController, :update)
    delete("/syllabus_providers/:id", SyllabusProviderController, :deactivate)

    post("/grades", GradeController, :create)
    get("/grades/:id", GradeController, :show)
    put("/grades/:id", GradeController, :update)
    delete("/grades/:id", GradeController, :deactivate)

    post("/subjects", SubjectController, :create)
    get("/subjects/:id", SubjectController, :show)
    put("/subjects/:id", SubjectController, :update)
    delete("/subjects/:id", SubjectController, :deactivate)
    get("/grade_subjects/:id", SubjectController, :grade_subjects)

    post("/chapters", ChapterController, :create)
    get("/chapters/:id", ChapterController, :show)
    put("/chapters/:id", ChapterController, :update)
    delete("/chapters/:id", ChapterController, :deactivate)
    get("/subjects_chapters/:id", ChapterController, :subject_chapters)

    post("/topics", TopicController, :create)
    get("/topics/:id", TopicController, :show)
    put("/topics/:id", TopicController, :update)
    delete("/topics/:id", TopicController, :deactivate)
    get("/chapters_topics/:id", TopicController, :chapter_topics)

    post("/generate_quiz", QuestionController, :create)
    put("/mcqs/:id", QuestionController, :update)
    delete("/mcqs/:id", QuestionController, :deactivate)
  end
end
