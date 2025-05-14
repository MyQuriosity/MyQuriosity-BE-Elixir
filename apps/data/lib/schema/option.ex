defmodule Data.Option do
  @moduledoc """
  This module is used as schema for question bank `options`.
  """
  use Core.Macros.PK
  use Data.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "options" do
    field(:title, :string)
    field(:key, :string)
    field(:is_correct, :boolean, default: false)
    field(:deactivated_at, :utc_datetime)

    belongs_to(:question, Data.Question,
      foreign_key: :question_id,
      type: :binary_id,
      references: :id
    )

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = option, params) do
    option
    |> cast(params, [:title, :key, :is_correct, :question_id, :deactivated_at])
    |> validate_required([:title, :key, :is_correct, :question_id])
    |> validate_length(:title, max: 255, min: 1)
    |> unique_constraint([:title, :question_id],
      name: :unique_title_questions_index
    )
  end
end
