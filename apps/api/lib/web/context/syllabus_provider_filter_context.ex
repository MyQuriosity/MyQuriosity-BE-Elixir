defmodule Api.SyllabusProviderFilterContext do
  @moduledoc """
  This module provides context functions for filtering Syllabus Provider.
  """

  alias Api.Filterable.SyllabusProviderFilter
  alias Data.SyllabusProvider

  import Ecto.Query

  @spec filtered_query(map()) :: Ecto.Query.t()
  def filtered_query(params) do
    result = SyllabusProviderFilter.build(params)
    where(SyllabusProvider, ^result)
  end
end
