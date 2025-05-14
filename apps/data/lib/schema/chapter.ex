defmodule Data.Chapter do
  @moduledoc """
  This module is used as schema for question bank chapter.
  """
  use Core.Macros.PK
  use Data.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "chapters" do
    field(:title, :string)
    field(:description, :string)
    field(:number, :integer)
    field(:deactivated_at, :utc_datetime)

    belongs_to(:subject, Data.Subject,
      type: :binary_id,
      foreign_key: :subject_id,
      references: :id
    )

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = syllabus_provider, params) do
    syllabus_provider
    |> cast(params, [:title, :description, :number, :subject_id])
    |> validate_required([:title, :subject_id])
    |> validate_length(:title, max: 255)
    |> validate_length(:description, max: 255)
    |> foreign_key_constraint(:subject_id)
    |> unique_constraint(:title,
      name: :unique_chapters_subject_index,
      message: "Chapter already exists for this topic"
    )
  end

  @spec deactivate_changeset(t(), map()) :: Ecto.Changeset.t()
  def deactivate_changeset(%__MODULE__{} = syllabus_provider, params) do
    syllabus_provider
    |> cast(params, [:deactivated_at])
    |> validate_required([:deactivated_at])
  end
end
