defmodule QuizGenerator.TopicContext do
  @moduledoc """
  This module is used as context for `Topic` providing basic actions to controller
  """
  import Ecto.Query

  alias QuizGenerator.Topic
  alias QuizGenerator.Repo
  alias QuizGenerator.Utils.PaginationUtils

  @spec create(map()) :: {:ok, Topic.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    %Topic{}
    |> Topic.changeset(params)
    |> Repo.insert()
  end

  @spec fetch_by_id(String.t()) :: nil | Topic.t()
  def fetch_by_id(topic_id) do
    Topic
    |> where([s], s.id == ^topic_id)
    |> Repo.one()
  end

  @spec fetch_active_paginated(map()) :: {list(Topic.t()), map()}
  def fetch_active_paginated(params) do
    base_query()
    |> where([s], is_nil(s.deactivated_at))
    |> preload(chapter: [subject: :grade])
    |> PaginationUtils.paginate(params)
  end

  @spec deactivate(Topic.t()) ::
          {:ok, Topic.t()} | {:error, Ecto.Changeset.t()}
  def deactivate(%Topic{} = topic) do
    now = DateTime.utc_now()

    deactivate_params = %{
      "deactivated_at" => now
    }

    topic
    |> Topic.deactivate_changeset(deactivate_params)
    |> Repo.update()
  end

  @spec fetch_paginated_chapter_topics(String.t(), map()) :: {list(Topic.t()), map()}
  def fetch_paginated_chapter_topics(chapter_id, params) do
    Topic
    |> where([s], s.chapter_id == ^chapter_id)
    |> PaginationUtils.paginate(params)
  end

  @spec update(Topic.t(), map()) ::
          {:ok, Topic.t()} | {:error, Ecto.Changeset.t()}
  def update(%Topic{} = topic, params) do
    topic
    |> Topic.changeset(params)
    |> Repo.update()
  end

  defp base_query, do: preload(Topic, chapter: :subject)
end
