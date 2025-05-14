defmodule Data.Grade do
  @moduledoc """
  This module is used as schema for quiz generator grade.
  """
  use Core.Macros.PK
  use Data.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "grades" do
    field(:title, :string)
    field(:description, :string)
    field(:deactivated_at, :utc_datetime)

    belongs_to(:syllabus_provider, Data.SyllabusProvider,
      foreign_key: :syllabus_provider_id,
      type: :binary_id,
      references: :id
    )

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = grade, params) do
    grade
    |> cast(params, [:title, :description, :deactivated_at, :syllabus_provider_id])
    |> validate_required([:title, :syllabus_provider_id])
    |> validate_length(:title, max: 100)
    |> unique_constraint([:title, :syllabus_provider_id],
      name: :unique_grades_syllabus_provider_index,
      message: "Grade already exists for this syllabus provider"
    )
    |> foreign_key_constraint(:syllabus_provider_id)
  end

  @spec deactivate_changeset(t(), map()) :: Ecto.Changeset.t()
  def deactivate_changeset(%__MODULE__{} = grade, params) do
    grade
    |> cast(params, [:deactivated_at])
    |> validate_required([:deactivated_at])
  end
end
