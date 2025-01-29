defmodule QuizGenerator.Topic do
  @moduledoc """
  This module is used as schema for question bank topic.
  """
  use Core.Macros.PK
  use QuizGeneratorWeb, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "topics" do
    field(:title, :string)
    field(:description, :string)
    field(:deactivated_at, :utc_datetime)

    belongs_to(:chapter, QuizGenerator.Chapter,
      foreign_key: :chapter_id,
      references: :id,
      type: :binary_id
    )

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = chapter, params) do
    chapter
    |> cast(params, [:title, :description, :chapter_id, :deactivated_at])
    |> validate_required([:title, :chapter_id])
    |> validate_length(:title, max: 150)
    |> validate_length(:description, max: 255)
    |> foreign_key_constraint(:chapter_id)
  end

  @spec deactivate_changeset(t(), map()) :: Ecto.Changeset.t()
  def deactivate_changeset(%__MODULE__{} = chapter, params) do
    chapter
    |> cast(params, [:deactivated_at])
    |> validate_required([:deactivated_at])
  end
end
