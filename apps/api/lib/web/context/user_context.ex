defmodule Api.UserContext do
  @moduledoc """
  This module provides context functions for managing User records.
  It handles user creation, verification, password management, and user lookup operations.
  """
  alias Data.Repo
  alias Data.User

  import Ecto.Query

  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(params) do
    %User{}
    |> User.signup_changeset(params)
    |> Repo.insert()
  end

  @spec update(User.t(), map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update(user, params) do
    user
    |> User.update_changeset(params)
    |> Repo.update()
  end

  @doc """
  This function is used to update the password of a user
  """
  @spec update_password(User.t(), map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update_password(user, params) do
    user
    |> User.update_password_changeset(params)
    |> Repo.update()
  end

  @doc """
  This function is used to get the user by email_verify_token
  """
  @spec get_user_by_token(String.t()) :: User.t() | nil
  def get_user_by_token(token) do
    User
    |> where(
      [user],
      user.email_verify_token == ^token and is_nil(user.deactivated_at)
    )
    |> Repo.one()
  end

  def get_user_by_id(id) do
    User
    |> Repo.get(id)
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def verify_new_password(password, confirmed_password) do
    if password == confirmed_password,
      do: {:ok, true},
      else: {:error, "Password and confirmed password does not match"}
  end

  def validate_password(current_user_id, plain_password) do
    with {:ok, hashed_password} <- get_user_hashed_password(current_user_id),
         {:ok, _} = response <- verify_user_password(hashed_password, plain_password) do
      response
    else
      error -> error
    end
  end

  @spec verify_user_password(String.t(), String.t()) ::
          {:ok, :password_verified} | {:error, String.t()}
  defp verify_user_password(hashed_password, password) do
    if Bcrypt.verify_pass(password, hashed_password) do
      {:ok, :password_verified}
    else
      {:error, "Incorrect Password"}
    end
  end

  def get_user_hashed_password(current_user_id) do
    query =
      from(q in Data.User,
        where: q.id == ^current_user_id,
        select: q.hashed_password
      )

    case Repo.one(query) do
      nil ->
        {:error, "User not found"}

      hashed_password ->
        {:ok, hashed_password}
    end
  end
end
