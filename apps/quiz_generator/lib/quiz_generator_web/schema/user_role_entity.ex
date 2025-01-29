defmodule QuizGenerator.UserRoleEntity do
  @moduledoc """
  This module is used as schema for quiz generator user_role_entities.
  """
  use Core.Macros.PK
  use QuizGeneratorWeb, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}

  schema "users_roles_entities" do
    field(:deactivated_at, :utc_datetime)

    belongs_to(:user, QuizGenerator.User,
      foreign_key: :user_id,
      references: :id,
      type: :binary_id
    )

    belongs_to(:role, QuizGenerator.Role,
      foreign_key: :role_id,
      references: :id,
      type: :string
    )

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = user_role_entity, params) do
    user_role_entity
    |> cast(params, [:user_id, :role_id])
    |> validate_required([:user_id, :role_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:role_id)
    |> unique_constraint(:user_id, name: :unique_role_per_user)
  end
end
