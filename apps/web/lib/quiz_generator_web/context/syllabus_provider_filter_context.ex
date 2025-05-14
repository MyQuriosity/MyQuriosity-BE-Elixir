defmodule Web.SyllabusProviderFilterContext do
  @moduledoc """
  This module provides context functions for filtering Syllabus Provider.
  """

  alias Web.SyllabusProvider
  alias Web.Filterable.SyllabusProviderFilter

  import Ecto.Query

  @spec filtered_query(map()) :: Ecto.Query.t()
  def filtered_query(params) do
    result = SyllabusProviderFilter.build(params)
    where(SyllabusProvider, ^result)
  end
end
