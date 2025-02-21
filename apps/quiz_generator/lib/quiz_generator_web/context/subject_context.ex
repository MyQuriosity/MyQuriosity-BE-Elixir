defmodule QuizGenerator.SubjectContext do
  @moduledoc """
  This module is used as context for `subject` providing basic actions to controller
  """
  import Ecto.Query

  alias QuizGenerator.Subject
  alias QuizGenerator.Repo
  alias QuizGenerator.Utils.PaginationUtils

  @spec create(map()) :: {:ok, Subject.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    %Subject{}
    |> Subject.changeset(params)
    |> Repo.insert()
  end

  @spec fetch_by_id(String.t()) :: nil | Subject.t()
  def fetch_by_id(subject_id) do
    Subject
    |> where([s], s.id == ^subject_id)
    |> Repo.one()
  end

  @spec fetch_active_paginated(map()) :: {list(Subject.t()), map()}
  def fetch_active_paginated(params) do
    Subject
    |> where([s], is_nil(s.deactivated_at))
    |> preload(:grade)
    |> PaginationUtils.paginate(params)
  end

  @spec deactivate(Subject.t()) ::
          {:ok, Subject.t()} | {:error, Ecto.Changeset.t()}
  def deactivate(%Subject{} = subject) do
    now = DateTime.utc_now()

    deactivate_params = %{
      "deactivated_at" => now
    }

    subject
    |> Subject.deactivate_changeset(deactivate_params)
    |> Repo.update()
  end

  @spec fetch_paginated_grade_subjects(String.t(), map()) ::
          {list(Subject.t()), map()}
  def fetch_paginated_grade_subjects(grade_id, params) do
    Subject
    |> where([s], s.grade_id == ^grade_id)
    |> PaginationUtils.paginate(params)
  end

  @spec update(Subject.t(), map()) ::
          {:ok, Subject.t()} | {:error, Ecto.Changeset.t()}
  def update(%Subject{} = subject, params) do
    subject
    |> Subject.changeset(params)
    |> Repo.update()
  end
end
