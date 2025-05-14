defmodule Api.GradeFilterContext do
  @moduledoc """
  This module provides context functions for filtering Grade.
  """

  alias Api.Grade
  alias Api.Filterable.GradeFilter

  import Ecto.Query

  @spec filtered_query(map()) :: Ecto.Query.t()
  def filtered_query(params) do
    dynamic = GradeFilter.build(params)
    where(Grade, ^dynamic)
  end
end
