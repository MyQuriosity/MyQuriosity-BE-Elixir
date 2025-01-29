defmodule Core.Utils.ChangesetUtils do
  @moduledoc """
    Provides utility functions for changeset.
  """
  import Ecto.Changeset

  @doc """
    This method is used to trim changeset fields from leading and trailing sides
  """
  @spec trim(Ecto.Changeset.t(), list()) :: Ecto.Changeset.t()
  def trim(changeset, trimming_keys) do
    Enum.reduce(trimming_keys, changeset, fn trimming_key, changeset ->
      trimming_value = get_field(changeset, trimming_key)

      put_change(
        changeset,
        trimming_key,
        if(is_nil(trimming_value), do: trimming_value, else: String.trim(trimming_value))
      )
    end)
  end
end
