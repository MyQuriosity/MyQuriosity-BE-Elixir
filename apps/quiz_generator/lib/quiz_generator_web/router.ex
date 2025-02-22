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
    get("/syllabus_providers", SyllabusProviderController, :index)
    get("/syllabus_providers/:id", SyllabusProviderController, :show)
    put("/syllabus_providers/:id", SyllabusProviderController, :update)
    delete("/syllabus_providers/:id", SyllabusProviderController, :deactivate)

    post("/grades", GradeController, :create)
    get("/grades", GradeController, :index)
    get("/grades/:id", GradeController, :show)
    put("/grades/:id", GradeController, :update)
    delete("/grades/:id", GradeController, :deactivate)

    post("/subjects", SubjectController, :create)
    get("/subjects", SubjectController, :index)
    get("/subjects/:id", SubjectController, :show)
    put("/subjects/:id", SubjectController, :update)
    delete("/subjects/:id", SubjectController, :deactivate)
    get("/syllabus_providers/subjects/:id", SubjectController, :syllabus_provider_subjects)

    post("/chapters", ChapterController, :create)
    get("/chapters", ChapterController, :index)
    get("/chapters/:id", ChapterController, :show)
    put("/chapters/:id", ChapterController, :update)
    delete("/chapters/:id", ChapterController, :deactivate)
    get("/subjects/chapters/:id", ChapterController, :subject_chapters)

    post("/topics", TopicController, :create)
    get("/topics", TopicController, :index)
    get("/topics/:id", TopicController, :show)
    put("/topics/:id", TopicController, :update)
    delete("/topics/:id", TopicController, :deactivate)
    get("/chapters/topics/:id", TopicController, :chapter_topics)

    post("/mcqs", MCQsController, :create)
    post("/mcqs/filters", MCQsController, :index)
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
