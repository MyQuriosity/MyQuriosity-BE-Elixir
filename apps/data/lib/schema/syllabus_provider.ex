defmodule Data.SyllabusProvider do
  @moduledoc """
  This module is used as schema for question bank syllabus provider.
  """
  use Core.Macros.PK
  use Data.Web, :model

  # @schema_prefix "quiz_generator"
  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "syllabus_providers" do
    field(:title, :string)
    field(:description, :string)
    field(:deactivated_at, :utc_datetime)

    has_many :grades, Data.Grade

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = syllabus_provider, params) do
    syllabus_provider
    |> cast(params, [:title, :description])
    |> validate_required([:title])
    |> validate_length(:title, max: 255)
    |> unique_constraint(:title,
      name: :unique_syllabus_providers_title,
      message: "of Syllabus provider already exists"
    )
  end

  @spec deactivate_changeset(t(), map()) :: Ecto.Changeset.t()
  def deactivate_changeset(%__MODULE__{} = syllabus_provider, params) do
    syllabus_provider
    |> cast(params, [:deactivated_at])
    |> validate_required([:deactivated_at])
  end
end
