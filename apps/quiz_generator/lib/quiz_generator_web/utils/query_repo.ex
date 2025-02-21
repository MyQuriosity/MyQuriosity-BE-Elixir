defmodule QuizGenerator.QueryRepo do
  @moduledoc """
  This repo is used for quering data based on deactivation
  Usage: TenantData.QueryRepo.all(with_deactivated: true)
  """

  import Ecto.Query

  alias QuizGenerator.QueryUtils
  alias QuizGenerator.Repo

  @doc """
  This function returns all record of a module
  """
  @spec all(Ecto.Query.t(), keyword()) :: [Ecto.Schema.t()]
  def all(query, options \\ []) do
    {query, options} = prepare_query(:all, query, options)
    Repo.all(query, options)
  end

  @doc """
  This function returns a single record of a module
  """
  @spec one(Ecto.Query.t(), keyword()) :: nil | Ecto.Schema.t()
  def one(query, options \\ []) do
    {query, options} = prepare_query(:one, query, options)
    Repo.one(query, options)
  end

  defp prepare_query(_operation, query, opts) do
    schema_module = QueryUtils.get_schema_module_from_query(query)
    fields = if schema_module, do: schema_module.__schema__(:fields), else: []
    soft_deactivateable? = Enum.member?(fields, :deactivated_at)

    if QueryUtils.has_include_deactivated_at_clause?(query) || opts[:with_deactivated] ||
         !soft_deactivateable? do
      {query, opts}
    else
      query = from(q in query, where: is_nil(q.deactivated_at))
      {query, opts}
    end
  end
end
