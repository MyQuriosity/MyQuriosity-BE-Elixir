defmodule QuizGenerator.Option do
  @moduledoc """
  This module is used as schema for question bank `options`.
  """
  use Core.Macros.PK
  use QuizGeneratorWeb, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "options" do
    field(:title, :string)
    field(:is_correct, :boolean, default: false)
    field(:deactivated_at, :utc_datetime)

    belongs_to(:question, QuizGenerator.Question,
      foreign_key: :question_id,
      type: :binary_id,
      references: :id
    )

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = option, params) do
    option
    |> cast(params, [:title, :is_correct, :question_id, :deactivated_at])
    |> validate_required([:title, :is_correct, :question_id])
    |> validate_length(:title, max: 255)
    |> unique_constraint([:title, :question_id],
      name: :unique_title_questions_index
    )
  end
end
