defmodule Core.Utils.AuthUtils do
  @moduledoc """
  Utility functions related to auth
  which are shared among apps
  """

  @doc """
  for merging hash password into user params used in create/update of institute_user
  """
  @spec merge_hash_password(map()) :: map()
  def merge_hash_password(%{"password" => password} = params) when not is_nil(password) do
    Map.merge(params, %{"hashed_password" => hash_password(password)})
  end

  def merge_hash_password(params), do: params

  @spec hash_password(binary) :: any
  def hash_password(plaintext) do
    IO.inspect("hhhs")
    Bcrypt.hash_pwd_salt(plaintext)
  end
end
