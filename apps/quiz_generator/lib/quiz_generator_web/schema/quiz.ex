defmodule QuizGenerator.Quiz do
  @moduledoc """
  This module is used as schema for question bank `questions`.
  """
  use Core.Macros.PK
  use QuizGeneratorWeb, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "quizzes" do
    field(:title, :string)

    # belongs_to(:syllabus_provider, QuizGenerator.SyllabusProvider,
    #   foreign_key: :syllabus_provider_id,
    #   references: :id,
    #   type: :binary_id
    # )

    # belongs_to(:subject, QuizGenerator.Subject,
    #   foreign_key: :subject_id,
    #   references: :id,
    #   type: :binary_id
    # )

    # belongs_to(:chapter, QuizGenerator.Chapter,
    #   foreign_key: :chapter_id,
    #   references: :id,
    #   type: :binary_id
    # )

    belongs_to(:topic, QuizGenerator.Topic,
      foreign_key: :topic_id,
      references: :id,
      type: :binary_id
    )

    has_many(:questions, QuizGenerator.Question)
    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = question, params) do
    question
    |> cast(params, [:title, :topic_id])
    |> validate_required([:title, :topic_id])
    |> validate_length(:title, max: 255)
    # |> foreign_key_constraint(:syllabus_provider_id)
    # |> foreign_key_constraint(:subject_id)
    # |> foreign_key_constraint(:chapter_id)
    |> foreign_key_constraint(:topic_id)
    # |> cast_assoc(:options, with: &QuizGenerator.Option.changeset/2)
  end
end
