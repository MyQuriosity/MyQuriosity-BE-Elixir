defmodule QuizGenerator.Quiz do
  @moduledoc """
  This module is used as schema for quiz.
  """
  use Core.Macros.PK
  use QuizGeneratorWeb, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "quizzes" do
    field(:title, :string)

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
    |> foreign_key_constraint(:topic_id)
  end
end
