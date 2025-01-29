defmodule Campus.Context do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  use FatEcto.FatContext, repo: Data.Repo

  @doc """
  This function returns a single record of a module
  """
  @spec one(Ecto.Query.t()) ::
          {:error, :not_found} | {:ok, integer()} | {:ok, struct()}
  def one(query) do
    case Data.Repo.one(query) do
      nil -> {:error, :not_found}
      record -> {:ok, record}
    end
  end
end
