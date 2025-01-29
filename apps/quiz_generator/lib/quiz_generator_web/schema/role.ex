defmodule QuizGenerator.Role do
  @moduledoc """
  This module is used as schema for quiz generator roles.
  """
  use Core.Macros.PK
  use QuizGeneratorWeb, :model

  @primary_key {:id, :string, autogenerate: false}
  @type t :: %__MODULE__{}
  schema "roles" do
    field(:is_active, :boolean, default: true)
    field(:description, :string)
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = role, params) do
    role
    |> cast(params, [
      :id,
      :is_active,
      :description
    ])
    |> unique_constraint(:id, name: :roles_pkey)
    |> validate_required([:id])
    |> validate_format(:id, ~r/^([a-z0-9A-Z(-_ )])+$/i, message: "only alphanumaric allowed")
  end
end
