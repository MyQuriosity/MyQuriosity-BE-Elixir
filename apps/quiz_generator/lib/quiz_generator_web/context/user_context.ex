defmodule QuizGenerator.UserContext do
  @moduledoc """
  This module provides context functions for managing User records.
  It handles user creation, verification, password management, and user lookup operations.
  """
  alias QuizGenerator.User
  alias QuizGenerator.Repo

  import Ecto.Query

  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(params) do
    %User{}
    |> User.signup_changeset(params)
    |> Repo.insert()
  end

  # @spec verify(User.t(), map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  # def verify(%User{} = user, params) do
  #   params
  #   |> append_hash_password()
  #   |> then(fn updated_params ->
  #     user
  #     |> User.verification_changeset(updated_params)
  #     |> Repo.update()
  #   end)
  # end

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

  # defp append_hash_password(%{"password" => password} = params) do
  #   params |> Map.put("hashed_password", AuthUtils.hash_password(password))
  # end
end
