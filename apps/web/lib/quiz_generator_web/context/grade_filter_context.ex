defmodule Web.GradeFilterContext do
  @moduledoc """
  This module provides context functions for filtering Grade.
  """

  alias Web.Grade
  alias Web.Filterable.GradeFilter

  import Ecto.Query

  @spec filtered_query(map()) :: Ecto.Query.t()
  def filtered_query(params) do
    dynamic = GradeFilter.build(params)
    where(Grade, ^dynamic)
  end
end
