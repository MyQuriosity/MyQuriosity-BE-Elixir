defmodule Core.TeamUserObanJob do
  @moduledoc """
  This schema is used for team user oban jobs
  """
  use Ecto.Schema

  @type t :: %__MODULE__{}
  @primary_key false
  schema "oban_jobs" do
    field(:state, :string)
    field(:queue, :string)
    field(:worker, :string)
    field(:args, :map)
    field(:errors, {:array, :map})
    field(:attempt, :integer)
    field(:max_attempts, :integer)
    field(:inserted_at, :utc_datetime)
    field(:scheduled_at, :utc_datetime)
    field(:attempted_at, :utc_datetime)
    field(:completed_at, :utc_datetime)
    field(:discarded_at, :utc_datetime)
    field(:cancelled_at, :utc_datetime)
    field(:attempted_by, {:array, :string})
    field(:priority, :integer)
    field(:tags, {:array, :string})
    field(:meta, :map)
  end
end
