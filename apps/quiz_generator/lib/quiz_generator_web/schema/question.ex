defmodule QuizGenerator.Question do
  @moduledoc """
  This module is used as schema for question.
  """
  use Core.Macros.PK
  use QuizGeneratorWeb, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "questions" do
    field(:title, :string)
    field(:deactivated_at, :utc_datetime)

    belongs_to(:topic, QuizGenerator.Topic,
      foreign_key: :topic_id,
      references: :id,
      type: :binary_id
    )

    has_many(:options, QuizGenerator.Option)
    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = question, params) do
    question
    |> cast(params, [:title, :topic_id, :deactivated_at])
    |> validate_required([:title, :topic_id])
    |> validate_length(:title, max: 255)
    |> foreign_key_constraint(:topic_id)
    |> unique_constraint([:topic_id, :title],
      name: :unique_questions_topic_index,
      message: "Question already exists for this topic"
    )
  end
end
