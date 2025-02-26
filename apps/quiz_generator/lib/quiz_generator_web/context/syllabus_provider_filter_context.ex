defmodule QuizGenerator.SyllabusProviderFilterContext do
  @moduledoc """
  This module provides context functions for filtering Syllabus Provider.
  """

  alias QuizGenerator.SyllabusProvider
  alias QuizGeneratorWeb.Filterable.SyllabusProviderFilter

  @spec filtered_query(any()) :: none()
  def filtered_query(params) do
    IO.inspect("params::::: #{inspect(params)}")
    restult = SyllabusProviderFilter.build(params)
    IO.inspect("restult::::: #{inspect(restult)}")
    restult
  end
end
