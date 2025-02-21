defmodule QuizGeneratorWeb.Router do
  use QuizGeneratorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :token_auth do
    plug(QuizGenerator.AuthAccessPipeline)
  end

  pipeline :validate_uuid do
    plug(Campus.Plug.ValidateUUID)
  end

  scope "/", QuizGeneratorWeb do
    pipe_through [:api]
    get("/info", PublicInfoController, :version_info)
  end

  scope "/api/v1", QuizGeneratorWeb do
    pipe_through :api
    post("/signup", AuthController, :signup)
    post("/setup_password", AuthController, :setup_password)
    post("/login", AuthController, :login)
  end

  scope "/api/v1", QuizGeneratorWeb do
    pipe_through [:api, :validate_uuid, :token_auth]

    post("/logout", AuthController, :logout)
    post("/syllabus_providers", SyllabusProviderController, :create)
    post("/syllabus_providers/filters", SyllabusProviderController, :index)
    get("/syllabus_providers", SyllabusProviderController, :index)
    get("/syllabus_providers/:id", SyllabusProviderController, :show)
    put("/syllabus_providers/:id", SyllabusProviderController, :update)
    delete("/syllabus_providers/:id", SyllabusProviderController, :deactivate)

    post("/grades", GradeController, :create)
    post("/grades/filters", GradeController, :index)
    get("/grades/:id", GradeController, :show)
    put("/grades/:id", GradeController, :update)
    delete("/grades/:id", GradeController, :deactivate)

    post("/subjects", SubjectController, :create)
    post("/subjects/filters", SubjectController, :index)
    get("/subjects/:id", SubjectController, :show)
    put("/subjects/:id", SubjectController, :update)
    delete("/subjects/:id", SubjectController, :deactivate)
    get("/grade_subjects/:id", SubjectController, :grade_subjects)

    post("/chapters", ChapterController, :create)
    post("/chapters/filters", ChapterController, :index)
    get("/chapters/:id", ChapterController, :show)
    put("/chapters/:id", ChapterController, :update)
    delete("/chapters/:id", ChapterController, :deactivate)
    get("/subjects_chapters/:id", ChapterController, :subject_chapters)

    post("/topics", TopicController, :create)
    post("/topics/filters", TopicController, :index)
    get("/topics/:id", TopicController, :show)
    put("/topics/:id", TopicController, :update)
    delete("/topics/:id", TopicController, :deactivate)
    get("/chapters_topics/:id", TopicController, :chapter_topics)

    post("/generate_quiz", QuizController, :create)
    post("/mcqs/filters", QuizController, :index)
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:quiz_generator, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: QuizGeneratorWeb.Telemetry
    end
  end
end
