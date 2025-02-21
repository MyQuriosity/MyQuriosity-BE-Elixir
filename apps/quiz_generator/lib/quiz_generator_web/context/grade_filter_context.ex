defmodule QuizGenerator.GradeFilterContext do
  @moduledoc """
  This module provides context functions for filtering Grade.
  """

  alias QuizGenerator.Grade
  alias QuizGeneratorWeb.Filterable.GradeFilter

  def filtered_query(params) do
    GradeFilter.build(Grade, params["$where"] || %{})
  end
end
