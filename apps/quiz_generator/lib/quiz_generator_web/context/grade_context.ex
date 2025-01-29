defmodule QuizGenerator.GradeContext do
  @moduledoc """
  This module is used as context for `subject` providing basic actions to controller
  """
  import Ecto.Query

  alias QuizGenerator.Grade
  alias QuizGenerator.Repo
  alias QuizGenerator.Utils.PaginationUtils

  @spec create(map()) :: {:ok, Grade.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    QuizGeneratorWeb.SyllabusProviderContext.fetch_by_id(params["syllabus_provider_id"])
    |> IO.inspect()

    %Grade{}
    |> IO.inspect()
    |> Grade.changeset(params)
    |> IO.inspect()
    |> Repo.insert()
  end

  @spec fetch_by_id(String.t()) :: nil | Grade.t()
  def fetch_by_id(grade_id) do
    Grade
    |> where([g], g.id == ^grade_id)
    |> Repo.one()
  end

  @spec fetch_active_paginated(map()) :: {list(Grade.t()), map()}
  def fetch_active_paginated(params) do
    Grade
    |> where([s], is_nil(s.deactivated_at))
    |> PaginationUtils.paginate(params)
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

  @spec fetch_paginated_grade_subjects(String.t(), map()) ::
          {list(Grade.t()), map()}
  def fetch_paginated_grade_subjects(grade_id, params) do
    Grade
    |> where([s], s.grade_id == ^grade_id)
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
