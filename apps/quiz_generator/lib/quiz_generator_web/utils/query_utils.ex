defmodule QuizGenerator.QueryUtils do
  @moduledoc """
   This module contain methods to deal with queries i.e build dunamic query etc.
  """
  import Ecto.Query

  @doc """
    This function build dynamic quey on basis of dynamic source field provided and the min & max value
    i.e finding records inserted between min and max dates
  """
  @spec find_between_query(
          Ecto.Query.t(),
          atom(),
          String.t() | integer(),
          String.t() | integer(),
          integer() | atom()
        ) ::
          Ecto.Query.t()
  def find_between_query(
        query,
        dynamic_field,
        min_value,
        max_value,
        binding_position \\ 0
      )

  def find_between_query(
        query,
        dynamic_field,
        min_value,
        max_value,
        :last = _binding_position
      ) do
    where(
      query,
      [..., q],
      field(q, ^dynamic_field) >= ^min_value and field(q, ^dynamic_field) <= ^max_value
    )
  end

  def find_between_query(
        query,
        dynamic_field,
        min_value,
        max_value,
        binding_position
      ) do
    where(
      query,
      [{q, binding_position}],
      field(q, ^dynamic_field) >= ^min_value and field(q, ^dynamic_field) <= ^max_value
    )
  end

  @doc """
    This function Checks the query to see if it contains a where not is_nil(deactivated_at)
  """
  @spec has_include_deactivated_at_clause?(Ecto.Query.t()) :: boolean() | Ecto.Query.t()
  def has_include_deactivated_at_clause?(%Ecto.Query{wheres: wheres}) do
    Enum.any?(wheres, fn %{expr: expr} ->
      expr = inspect(expr, limit: :infinity)

      String.contains?(
        expr,
        "{:not, [], [{:is_nil, [], [{{:., [], [{:&, [], [0]}, :deactivated_at]}, [], []}]}]}"
      )
    end)
  end

  def has_include_deactivated_at_clause?(query), do: query

  @doc """
    This function gets the schema module from the query
  """
  @spec get_schema_module_from_query(Ecto.Query.t()) :: any()
  def get_schema_module_from_query(%Ecto.Query{from: %{source: {_name, module}}}) do
    module
  end

  def get_schema_module_from_query(_), do: nil
end
