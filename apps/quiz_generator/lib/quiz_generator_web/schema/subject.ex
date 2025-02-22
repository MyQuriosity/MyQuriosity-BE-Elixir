defmodule QuizGenerator.Subject do
  @moduledoc """
  This module is used as schema for question bank subject.
  """
  use Core.Macros.PK
  use QuizGeneratorWeb, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "subjects" do
    field(:title, :string)
    field(:course_code, :string)
    field(:color, :string)
    field(:deactivated_at, :utc_datetime)

    belongs_to(:grade, QuizGenerator.Grade,
      foreign_key: :grade_id,
      type: :binary_id,
      references: :id
    )

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = subject, params) do
    subject
    |> cast(params, [:title, :course_code, :color, :grade_id])
    |> validate_required([:title])
    |> validate_length(:title, max: 255)
    |> validate_length(:course_code, max: 255)
    |> validate_length(:color, max: 255)
    |> foreign_key_constraint(:grade_id)
  end

  @spec deactivate_changeset(t(), map()) :: Ecto.Changeset.t()
  def deactivate_changeset(%__MODULE__{} = subject, params) do
    subject
    |> cast(params, [:deactivated_at])
    |> validate_required([:deactivated_at])
  end
end
