defmodule QuizGenerator.UserRoleEntityContext do
  @moduledoc """
  This module provides context functions for managing UserRoleEntity records.
  """
  alias QuizGenerator.Repo
  alias QuizGenerator.UserRoleEntity

  @spec create(map()) :: {:ok, UserRoleEntity.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    %UserRoleEntity{}
    |> UserRoleEntity.changeset(params)
    |> Repo.insert()
  end
end
