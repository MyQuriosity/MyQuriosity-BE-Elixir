defmodule QuizGenerator.GradeContext do
  @moduledoc """
  This module is used as context for `subject` providing basic actions to controller
  """
  import Ecto.Query

  alias QuizGenerator.GradeFilterContext
  alias QuizGenerator.Grade
  alias QuizGenerator.Repo
  alias QuizGenerator.Utils.PaginationUtils

  @spec create(map()) :: {:ok, Grade.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    %Grade{}
    |> Grade.changeset(params)
    |> Repo.insert()
  end

  @spec fetch_by_id(String.t()) :: nil | Grade.t()
  def fetch_by_id(grade_id) do
    Grade
    |> where([g], g.id == ^grade_id)
    |> Repo.one()
  end

  @spec deactivate(Grade.t()) ::
          {:ok, Grade.t()} | {:error, Ecto.Changeset.t()}
  def deactivate(%Grade{} = subject) do
    now = DateTime.utc_now()

    deactivate_params = %{
      "deactivated_at" => now
    }

    subject
    |> Grade.deactivate_changeset(deactivate_params)
    |> Repo.update()
  end

  @spec fetch_paginated_grade(String.t(), map()) ::
          {list(Grade.t()), map()}
  def fetch_paginated_grade(grade_id, params) do
    Grade
    |> where([s], s.grade_id == ^grade_id)
    |> PaginationUtils.paginate(params)
  end

  def apply_filter(%{"$where" => _} = params) do
    params =
      update_in(
        params["$where"],
        &Map.put(&1, "syllabus_provider_id", %{"$equal" => params["syllabus_provider_id"]})
      )

    params
    |> GradeFilterContext.filtered_query()
    |> PaginationUtils.paginate(params)
  end

  def apply_filter(params) do
    params =
      Map.put(params, "$where", %{
        "syllabus_provider_id" => %{"$equal" => params["syllabus_provider_id"]}
      })

    params
    |> GradeFilterContext.filtered_query()
    |> PaginationUtils.paginate(params)
  end

  @spec update(Grade.t(), map()) ::
          {:ok, Grade.t()} | {:error, Ecto.Changeset.t()}
  def update(%Grade{} = subject, params) do
    subject
    |> Grade.changeset(params)
    |> Repo.update()
  end
end
