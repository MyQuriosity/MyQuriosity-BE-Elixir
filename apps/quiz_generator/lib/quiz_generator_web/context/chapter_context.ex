defmodule QuizGeneratorWeb.Context.ChapterContext do
  @moduledoc """
  This module is used as context for `Chapter` providing basic actions to controller
  """
  import Ecto.Query

  alias QuizGenerator.Chapter
  alias QuizGenerator.Repo
  alias QuizGenerator.Utils.PaginationUtils

  @spec create(map()) :: {:ok, Chapter.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    %Chapter{}
    |> Chapter.changeset(params)
    |> Repo.insert()
  end

  @spec fetch_by_id(String.t()) :: nil | Chapter.t()
  def fetch_by_id(chapter_id) do
    Chapter
    |> where([s], s.id == ^chapter_id and is_nil(s.deactivated_at))
    |> Repo.one()
  end

  @spec fetch_active_paginated(map()) :: {list(Chapter.t()), map()}
  def fetch_active_paginated(params) do
    base_query()
    |> where([s], is_nil(s.deactivated_at))
    |> preload(subject: :grade)
    |> PaginationUtils.paginate(params)
  end

  @spec deactivate(Chapter.t()) ::
          {:ok, Chapter.t()} | {:error, Ecto.Changeset.t()}
  def deactivate(%Chapter{} = chapter) do
    now = DateTime.utc_now()

    deactivate_params = %{
      "deactivated_at" => now
    }

    chapter
    |> Chapter.deactivate_changeset(deactivate_params)
    |> Repo.update()
  end

  @spec fetch_paginated_subject_chapters(String.t(), map()) :: {list(Chapter.t()), map()}
  def fetch_paginated_subject_chapters(subject_id, params) do
    Chapter
    |> where([s], s.subject_id == ^subject_id)
    |> PaginationUtils.paginate(params)
  end

  @spec update(Chapter.t(), map()) ::
          {:ok, Chapter.t()} | {:error, Ecto.Changeset.t()}
  def update(%Chapter{} = chapter, params) do
    chapter
    |> Chapter.changeset(params)
    |> Repo.update()
  end

  defp base_query, do: preload(Chapter, [:subject])
end
