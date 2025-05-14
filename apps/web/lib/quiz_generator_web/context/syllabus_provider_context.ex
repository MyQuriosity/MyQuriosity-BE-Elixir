defmodule Web.SyllabusProviderContext do
  @moduledoc """
  This module is used as context for `syllabus_provider` providing basic actions to controller
  """
  import Ecto.Query

  alias Web.Repo
  alias Web.SyllabusProvider
  alias Web.SyllabusProviderFilterContext
  alias Web.Utils.PaginationUtils

  @spec create(map()) :: {:ok, SyllabusProvider.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    %SyllabusProvider{}
    |> SyllabusProvider.changeset(params)
    |> Repo.insert()
  end

  def apply_filter(params) do
    params
    |> SyllabusProviderFilterContext.filtered_query()
    |> PaginationUtils.paginate(params)
  end

  @spec fetch_by_id(String.t()) :: nil | SyllabusProvider.t()
  def fetch_by_id(syllabus_provider_id) do
    SyllabusProvider
    |> where([s], s.id == ^syllabus_provider_id)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      syllabus_provider -> {:ok, syllabus_provider}
    end
  end

  @spec fetch_active_paginated(map()) :: {list(SyllabusProvider.t()), map()}
  def fetch_active_paginated(params) do
    SyllabusProvider
    |> where([s], is_nil(s.deactivated_at))
    |> PaginationUtils.paginate(params)
  end

  @spec deactivate(SyllabusProvider.t()) ::
          {:ok, SyllabusProvider.t()} | {:error, Ecto.Changeset.t()}
  def deactivate(%SyllabusProvider{} = syllabus_provider) do
    now = DateTime.utc_now()

    deactivate_params = %{
      "deactivated_at" => now
    }

    syllabus_provider
    |> SyllabusProvider.deactivate_changeset(deactivate_params)
    |> Repo.update()
  end

  @spec update(SyllabusProvider.t(), map()) ::
          {:ok, SyllabusProvider.t()} | {:error, Ecto.Changeset.t()}
  def update(%SyllabusProvider{} = syllabus_provider, params) do
    syllabus_provider
    |> SyllabusProvider.changeset(params)
    |> Repo.update()
  end
end
