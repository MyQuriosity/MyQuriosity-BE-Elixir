defmodule QuizGenerator.SubjectContext do
  @moduledoc """
  This module is used as context for `subject` providing basic actions to controller
  """
  import Ecto.Query

  alias QuizGenerator.Subject
  alias QuizGenerator.SubjectFilterContext
  alias QuizGenerator.Repo
  alias QuizGenerator.Utils.PaginationUtils

  @colors [
    "primary-purple",
    "success",
    "warning",
    "secondary-blue-gray",
    "secondary-blue-light",
    "secondary-orange",
    "secondary-indigo"
  ]

  @spec create(map()) :: {:ok, Subject.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    case maybe_color_in_params(params) do
      {:error, message} ->
        {:error, message}

      params ->
        %Subject{}
        |> Subject.changeset(params)
        |> Repo.insert()
    end
  end

  @spec fetch_by_id(String.t()) :: {:error, :not_found} | {:ok, Subject.t()}
  def fetch_by_id(subject_id) do
    Subject
    |> where([s], s.id == ^subject_id)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      subject -> {:ok, subject}
    end
  end

  def apply_filter(params) do
    params
    |> SubjectFilterContext.filtered_query()
    |> PaginationUtils.paginate(params)
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

  defp maybe_color_in_params(%{"color" => color} = params) when not is_nil(color), do: params

  defp maybe_color_in_params(params) do
    colors =
      params
      |> get_last_seven_subject_colors()
      |> Enum.filter(&(&1 !== nil))

    if length(colors) < 7 and length(colors) > 0 do
      color = get_unique_color(colors)
      Map.put(params, "color", color)
    else
      Map.put(params, "color", Enum.random(@colors))
    end
  end

  defp get_last_seven_subject_colors(%{"grade_id" => grade_id}) do
    last_seven_subjects_query()
    |> where([s], s.grade_id == ^grade_id)
    |> Repo.all()
  end

  defp get_last_seven_subject_colors(_), do: Repo.all(last_seven_subjects_query())

  defp last_seven_subjects_query do
    Subject
    |> select([s], s.color)
    |> order_by([s], desc: s.inserted_at)
    |> limit(7)
  end

  defp get_unique_color(colors) do
    @colors
    |> remove_elements(colors)
    |> Enum.random()
  end

  defp remove_elements(list1, list2) do
    Enum.reject(list1, &Enum.member?(list2, &1))
  end
end
