defmodule Web.Utils.PaginationUtils do
  @moduledoc """
  PaginationUtils keeps the general pagination
  context in it.
  All other apps can use this for pagination purposes.
  """
  import Ecto.Query
  alias Core.Paginator
  alias Web.Repo

  @spec paginate(Ecto.Query.t(), maybe_improper_list | map) ::
          {[struct()], map()}
  def paginate(query, params) do
    query =
      from(q in query,
        where: is_nil(q.deactivated_at),
        offset: ^(params["skip"] || 0),
        limit: ^(params["limit"] || 10)
      )

    {query, meta} = paginator(query, params)
    records = Repo.all(query)
    {records, meta}
  end

  defp paginator(query, params) do
    limit = params["limit"]
    skip = params["skip"]
    skip = if is_nil(skip), do: 0, else: skip

    %{
      data_query: query,
      skip: skip,
      limit: limit,
      count_query: count_query
    } = Paginator.paginate(query, skip: skip, limit: limit)

    total_records = count_records(count_query)

    meta = %{
      skip: skip,
      limit: limit,
      total_records: total_records,
      pages: trunc(Float.ceil(total_records / limit))
    }

    {query, meta}
  end

  defp count_records(%{select: nil} = count_query) do
    Repo.aggregate(count_query, :count, hd(get_primary_keys(count_query)))
  end

  defp count_records(count_query) do
    Repo.one(count_query)
  end

  defp get_primary_keys(query) do
    %{source: {_table, model}} = query.from

    case model do
      nil ->
        nil

      _ ->
        model.__schema__(:primary_key)
    end
  end
end
