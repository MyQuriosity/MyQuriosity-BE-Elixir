defmodule Data.Question do
  @moduledoc """
  This module is used as schema for question.
  """
  use Core.Macros.PK
  use Data.Web, :model
  alias Data.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: %__MODULE__{}
  schema "questions" do
    field(:title, :string)
    field(:deactivated_at, :utc_datetime)

    belongs_to(:topic, Data.Topic,
      foreign_key: :topic_id,
      references: :id,
      type: :binary_id
    )

    belongs_to(:chapter, Data.Chapter,
      foreign_key: :chapter_id,
      references: :id,
      type: :binary_id
    )

    belongs_to(:subject, Data.Subject,
      foreign_key: :subject_id,
      references: :id,
      type: :binary_id
    )

    has_many :options, Data.Option, on_replace: :delete
    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = question, params) do
    question
    |> cast(params, [:title, :topic_id, :chapter_id, :subject_id, :deactivated_at])
    |> validate_required([:title, :subject_id])
    |> validate_question()
    |> validate_length(:title, max: 255)
    |> foreign_key_constraint(:topic_id)
    |> unique_constraint([:topic_id, :title],
      name: :unique_questions_topic_index,
      message: "Question already exists for this topic"
    )
    |> unique_constraint([:chapter_id, :title],
      name: :unique_questions_chapter_index,
      message: "Question already exists for this chapter"
    )
    |> unique_constraint([:subject_id, :title],
      name: :unique_questions_subject_index,
      message: "Question already exists for this subject"
    )
  end

  def insertion_changeset(%__MODULE__{} = question, params) do
    question
    |> cast(params, [:title, :topic_id, :chapter_id, :subject_id, :deactivated_at])
    |> validate_required([:title, :subject_id])
    |> validate_question()
    |> validate_length(:title, max: 255)
    |> foreign_key_constraint(:topic_id)
    |> unique_constraint([:topic_id, :title],
      name: :unique_questions_topic_index,
      message: "Question already exists for this topic"
    )
    |> unique_constraint([:chapter_id, :title],
      name: :unique_questions_chapter_index,
      message: "Question already exists for this chapter"
    )
    |> unique_constraint([:subject_id, :title],
      name: :unique_questions_subject_index,
      message: "Question already exists for this subject"
    )
    |> validate_question_uniqueness(params)
  end

  defp validate_question_uniqueness(changeset, params) do
    topic_id = get_field(changeset, :topic_id)

    if is_nil(topic_id) do
      changeset
    else
      title = get_field(changeset, :title)
      options = params["options"]

      option_values =
        Enum.map(options, fn {_key, opt} ->
          opt
        end)
        |> Enum.sort()

      query =
        from q in __MODULE__,
          join: o in assoc(q, :options),
          where: q.title == ^title and q.topic_id == ^topic_id and is_nil(q.deactivated_at),
          where: o.title in ^option_values,
          group_by: q.id

      case Repo.exists?(query) do
        true ->
          add_error(changeset, :title, "Question with same options already exists")

        false ->
          changeset
      end
    end
  end

  defp validate_question(changeset) do
    topic_id = get_field(changeset, :topic_id)
    chapter_id = get_field(changeset, :chapter_id)

    if topic_id && is_nil(chapter_id) do
      add_error(changeset, :chapter_id, "chapter must be present when topic is selected")
    else
      changeset
    end
  end
end
