defmodule Data.User do
  @moduledoc """
  This module is used as schema for quiz generator users.
  """
  use Core.Macros.PK
  use Data.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:email_verify_token, :string)
    field(:password, :string, virtual: true)
    field(:hashed_password, :string)
    field(:gender, :string)
    field(:email_verified_at, :utc_datetime)
    field(:deactivated_at, :utc_datetime)
    field(:institute_name, :string)
    field(:is_admin, :boolean, default: false)
    field(:designation, :string)
    field(:teach_subject, :string)

    belongs_to(:syllabus_provider, Data.SyllabusProvider,
      foreign_key: :syllabus_provider_id,
      type: :binary_id,
      references: :id
    )

    timestamps()
  end

  @spec signup_changeset(t(), map()) :: Ecto.Changeset.t()
  def signup_changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, [
      :first_name,
      :last_name,
      :email,
      :institute_name,
      :gender,
      :syllabus_provider_id
    ])
    |> validate_required([:first_name, :last_name, :email])
    |> validate_format(:email, ~r/@/, message: "Invalid email format.")
    |> unique_constraint(:email, name: :unique_email_per_user, message: "Email is already taken.")
  end

  @spec update_changeset(t(), map()) :: Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, [
      :first_name,
      :last_name,
      :email,
      :email_verified_at,
      :email_verify_token,
      :institute_name,
      :gender,
      :is_admin,
      :hashed_password,
      :password,
      :designation,
      :teach_subject,
      :syllabus_provider_id
    ])
    |> unique_constraint(:email, name: :unique_email_per_user, message: "Email is already taken.")
  end

  @spec update_password_changeset(t(), map()) :: Ecto.Changeset.t()
  def update_password_changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, [:password, :hashed_password, :designation, :teach_subject])
    |> validate_required([:password])
    |> validate_length(:password, min: 8, message: "Password must be at least 8 characters long.")
    |> hash_password()
  end

  @spec deactivate_changeset(t(), map()) :: Ecto.Changeset.t()
  def deactivate_changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, [:deactivated_at])
    |> validate_required([:deactivated_at])
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        hashed_password = Bcrypt.hash_pwd_salt(password)
        put_change(changeset, :hashed_password, hashed_password)
    end
  end
end
