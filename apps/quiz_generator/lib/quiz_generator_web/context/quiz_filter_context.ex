defmodule QuizGenerator.QuizFilterContext do
  @moduledoc """
  This module provides context functions for filtering Multiple Choice Questions (MCQs).
  """
  import Ecto.Query

  alias QuizGenerator.Quiz
  alias QuizGeneratorWeb.Filterable.QuizFilter

  def filtered_query(params) do
    query = base_query()
    QuizFilter.build(query, params["$where"] || %{})
  end

  defp base_query do
    preload(Quiz, questions: :options)
  end
end
