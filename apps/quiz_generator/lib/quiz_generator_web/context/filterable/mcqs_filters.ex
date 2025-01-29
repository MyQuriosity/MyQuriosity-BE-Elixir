defmodule QuizGenerator.MCQsFilters do
  @moduledoc """
  This module provides filtering functionality for Multiple Choice Questions (MCQs).
  """
  use FatEcto.FatQuery.Filterable,
    fields_allowed: %{
      "syllabus_provider_id" => "$equal",
      "subject_id" => "$equal",
      "chapter_id" => "$equal",
      "topic_id" => "$equal"
    },
    ignoreable_fields_values: %{
      "syllabus_provider_id" => ["", nil],
      "subject_id" => ["", nil],
      "chapter_id" => ["", nil],
      "topic_id" => ["", nil]
    }
end
