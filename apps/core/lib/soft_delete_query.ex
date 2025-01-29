defmodule Ecto.SoftDelete.Query do
  @moduledoc """
  functions for querying data that is (or is not) soft deleted
  """

  import Ecto.Query

  @doc """
  Returns a query that searches only for deleted items
      query = from(u in User, select: u)
      |> with_undeleted
      results = Repo.all(query)
  """
  @spec with_deactivated(Ecto.Queryable.t()) :: Ecto.Queryable.t()
  def with_deactivated(query) do
    where(query, [t], not is_nil(t.deactivated_at))
  end
end
