defmodule Api.GradeContext do
  @moduledoc """
  This module is used as context for `subject` providing basic actions to controller
  """
  import Ecto.Query

  alias Api.GradeFilterContext
  alias Api.Grade
  alias Data.Repo
  alias Api.Utils.PaginationUtils

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
    |> case do
      nil -> {:error, :not_found}
      grade -> {:ok, grade}
    end
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

  def apply_filter(params) do
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
