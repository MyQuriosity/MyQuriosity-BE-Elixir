# defmodule Data.QueryRepo do
#   @moduledoc """
#   This repo is used for quering data based on deactivation
#   Usage: Data.QueryRepo.all(with_deactivated: true)
#   """

#   import Ecto.Query

#   @doc """
#   This function returns all record of a module
#   """
#   @spec all(Ecto.Query.t(), keyword()) :: integer() | [struct()]
#   def all(query, options \\ []) do
#     {query, options} = prepare_query(:all, query, options)
#     QuizGenerator.Repo.all(query, options)
#   end

#   @doc """
#   This function returns a single record of a module
#   """
#   @spec one(Ecto.Query.t(), keyword()) :: integer() | struct()
#   def one(query, options \\ []) do
#     {query, options} = prepare_query(:one, query, options)
#     QuizGenerator.Repo.one(query, options)
#   end

#   defp prepare_query(_operation, query, opts) do
#     schema_module = get_schema_module_from_query(query)
#     fields = if schema_module, do: schema_module.__schema__(:fields), else: []
#     soft_deactivateable? = Enum.member?(fields, :deactivated_at)

#     if has_include_deactivated_at_clause?(query) || opts[:with_deactivated] ||
#          !soft_deactivateable? do
#       {query, opts}
#     else
#       query = from(q in query, where: is_nil(q.deactivated_at))
#       {query, opts}
#     end
#   end

#   # Checks the query to see if it contains a where not is_nil(deactivated_at)
#   # if it does, we want to be sure that we don't exclude soft deactivated records
#   defp has_include_deactivated_at_clause?(%Ecto.Query{wheres: wheres}) do
#     Enum.any?(wheres, fn %{expr: expr} ->
#       expr ==
#         {:not, [], [{:is_nil, [], [{{:., [], [{:&, [], [0]}, :deactivated_at]}, [], []}]}]}
#     end)
#   end

#   defp get_schema_module_from_query(%Ecto.Query{from: %{source: {_name, module}}}) do
#     module
#   end

#   defp get_schema_module_from_query(_), do: nil
# end
