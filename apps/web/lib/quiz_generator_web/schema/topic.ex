defmodule Web.Topic do
  @moduledoc """
  This module is used as schema for question bank topic.
  """
  use Core.Macros.PK
  use MyQuriosityWeb, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "topics" do
    field(:title, :string)
    field(:description, :string)
    field(:number, :integer)
    field(:deactivated_at, :utc_datetime)

    belongs_to(:chapter, Web.Chapter,
      foreign_key: :chapter_id,
      references: :id,
      type: :binary_id
    )

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = chapter, params) do
    chapter
    |> cast(params, [:title, :description, :number, :chapter_id, :deactivated_at])
    |> validate_required([:title, :chapter_id, :number])
    |> validate_length(:title, max: 150)
    |> validate_length(:description, max: 255)
    |> foreign_key_constraint(:chapter_id)
    |> unique_constraint(:title,
      name: :unique_title_number_index,
      message: "A title number can be assigned to 1 title"
    )
    |> unique_constraint(:title,
      name: :unique_topics_chapter_index,
      message: "A chapter cannot have 2 topics of same title"
    )
  end

  @spec deactivate_changeset(t(), map()) :: Ecto.Changeset.t()
  def deactivate_changeset(%__MODULE__{} = chapter, params) do
    chapter
    |> cast(params, [:deactivated_at])
    |> validate_required([:deactivated_at])
  end
end
