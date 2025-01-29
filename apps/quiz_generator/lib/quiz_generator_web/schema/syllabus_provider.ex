defmodule QuizGenerator.SyllabusProvider do
  @moduledoc """
  This module is used as schema for question bank syllabus provider.
  """
  use Core.Macros.PK
  use QuizGeneratorWeb, :model

  # @schema_prefix "quiz_generator"
  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "syllabus_providers" do
    field(:title, :string)
    field(:description, :string)
    field(:deactivated_at, :utc_datetime)

    has_many :grades, QuizGenerator.Grade

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = syllabus_provider, params) do
    syllabus_provider
    |> cast(params, [:title, :description])
    |> validate_required([:title])
    |> validate_length(:title, max: 255)
  end

  @spec deactivate_changeset(t(), map()) :: Ecto.Changeset.t()
  def deactivate_changeset(%__MODULE__{} = syllabus_provider, params) do
    syllabus_provider
    |> cast(params, [:deactivated_at])
    |> validate_required([:deactivated_at])
  end
end
