defmodule Core.Utils.HelperUtils do
  @moduledoc """
  Provides utility functions for pagination.
  """

  require Ecto.Query

  @min_limit 0
  @min_skip 0
  @default_skip 0
  @max_limit 100
  @default_limit 10

  @spec get_skip_value(keyword()) :: {any(), keyword()}
  def get_skip_value(params) do
    {skip, params} = Keyword.pop(params, :skip, @min_skip)
    skip = parse_integer!(skip)
    skip = if skip > @default_skip, do: skip, else: @default_skip
    {skip, params}
  end

  @spec get_limit_value(keyword(), nil | keyword() | map()) :: {any(), keyword()}
  def get_limit_value(params, options \\ []) do
    {max_limit, default_limit} = get_limit_bounds(options)
    {limit, params} = Keyword.pop(params, :limit, default_limit)
    limit = parse_integer!(limit)

    if is_nil(limit) do
      {default_limit, params}
    else
      limit = if limit > @min_limit, do: limit, else: @min_limit
      limit = if limit > max_limit, do: max_limit, else: limit
      {limit, params}
    end
  end

  defp parse_integer!(int_str) do
    if is_integer(int_str) do
      int_str
    else
      case int_str && Integer.parse(int_str) do
        {integer, _} ->
          integer

        _whatever ->
          nil
      end
    end
  end

  @spec get_primary_keys(map()) :: any
  def get_primary_keys(query) do
    %{source: {_table, model}} = query.from

    case model do
      nil ->
        nil

      _ ->
        model.__schema__(:primary_key)
    end
  end

  defp get_limit_bounds(options) do
    max_limit = options[:max_limit] || @max_limit
    default_limit = options[:default_limit] || @default_limit
    {max_limit, default_limit}
  end
end
