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
    field(:is_correct, :boolean)

    belongs_to(:question, QuizGenerator.Question,
      foreign_key: :question_id,
      type: :binary_id,
      references: :id
    )

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = question_option, params) do
    question_option
    |> cast(params, [:title, :is_correct])
    |> validate_required([:title, :is_correct])
    |> validate_length(:title, max: 255)
  end
end
