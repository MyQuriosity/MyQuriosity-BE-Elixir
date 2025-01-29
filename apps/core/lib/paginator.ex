defmodule Core.Paginator do
  @moduledoc """
  Paginator keeps the general pagination
  context in it.
  This module is used by pagination utils.
  """

  import Ecto.Query
  alias Core.Utils.HelperUtils

  @spec paginate(any, keyword) :: %{
          count_query: Ecto.Query.t(),
          data_query: Ecto.Query.t(),
          limit: number,
          skip: number
        }
  def paginate(query, params) do
    {skip, params} = HelperUtils.get_skip_value(params)
    {limit, _params} = HelperUtils.get_limit_value(params)

    %{
      data_query: data_query(query, skip, limit),
      skip: skip,
      limit: limit,
      count_query: count_query(query)
    }
  end

  defp data_query(query, skip, limit) do
    query
    |> limit([q], ^limit)
    |> offset([q], ^skip)
  end

  defp count_query(query) do
    # queryable =
    query
    |> exclude(:order_by)
    |> exclude(:preload)
    |> aggregate()

    # |> exclude(:distinct)

    # distinct(queryable, true)
  end

  defp aggregate(%{distinct: %{expr: [_ | _]}} = query) do
    query
    |> exclude(:select)
    |> count()
  end

  defp aggregate(
         %{
           group_bys: [
             %Ecto.Query.QueryExpr{
               expr: [{{:., [], [{:&, [], [source_index]}, field]}, [], []} | _]
             }
             | _
           ]
         } = query
       ) do
    query
    |> exclude(:select)
    |> select([{x, source_index}], struct(x, ^[field]))
    |> count()
  end

  defp aggregate(query) do
    primary_keys = HelperUtils.get_primary_keys(query)

    query =
      if is_nil(primary_keys) do
        exclude(query, :select)
      else
        case Enum.count(primary_keys) do
          1 ->
            exclude(query, :select)

          2 ->
            exclude(query, :select)

          # |> select(
          #   [q, ..., c],
          #   fragment(
          #     "COUNT(DISTINCT ROW(?, ?))::int",
          #     field(q, ^Enum.at(primary_keys, 0)),
          #     field(q, ^Enum.at(primary_keys, 1))
          #   )
          # )

          3 ->
            query
            |> exclude(:select)
            |> select(
              [q, ..., c],
              fragment(
                "COUNT(DISTINCT ROW(?, ?, ?))::int",
                field(q, ^Enum.at(primary_keys, 0)),
                field(q, ^Enum.at(primary_keys, 1)),
                field(q, ^Enum.at(primary_keys, 2))
              )
            )

          4 ->
            query
            |> exclude(:select)
            |> select(
              [q, ..., c],
              fragment(
                "COUNT(DISTINCT ROW(?, ?, ?, ?))::int",
                field(q, ^Enum.at(primary_keys, 0)),
                field(q, ^Enum.at(primary_keys, 1)),
                field(q, ^Enum.at(primary_keys, 2)),
                field(q, ^Enum.at(primary_keys, 3))
              )
            )

          5 ->
            query
            |> exclude(:select)
            |> select(
              [q, ..., c],
              fragment(
                "COUNT(DISTINCT ROW(?, ?, ?, ?, ?))::int",
                field(q, ^Enum.at(primary_keys, 0)),
                field(q, ^Enum.at(primary_keys, 1)),
                field(q, ^Enum.at(primary_keys, 2)),
                field(q, ^Enum.at(primary_keys, 3)),
                field(q, ^Enum.at(primary_keys, 4))
              )
            )

          _ ->
            exclude(query, :select)
        end
      end

    count(query)
  end

  defp count(query) do
    query
    |> exclude(:limit)
    |> exclude(:offset)
    |> subquery
    |> select(count("*"))
  end
end
