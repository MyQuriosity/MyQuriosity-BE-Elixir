defmodule QuizGenerator.MCQsFilterContext do
  @moduledoc """
  This module provides context functions for filtering Multiple Choice Questions (MCQs).
  """
  import Ecto.Query

  alias QuizGenerator.Question
  alias QuizGenerator.MCQsFilters

  def filtered_query(params) do
    query = base_query()
    MCQsFilters.build(query, params["$where"] || %{})
  end

  defp base_query do
    preload(Question, [:options])
  end
end
