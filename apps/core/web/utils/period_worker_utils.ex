defmodule Campus.PeriodWorkerUtils do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  # TODO: create a Campus.Clock module, with utc_today and utc_now methods
  # TODO: and dont over use this module. only use it where you need to test time traveling
  @generate_before_in_days 14
  @generate_for_in_days 7

  @spec utc_today :: Date.t()
  def utc_today do
    Date.utc_today()
  end

  @doc """
    get generate_before_in_days and generate_for_in_days
  """
  @spec get_period_generation_days :: %{
          generate_before_in_days: integer(),
          generate_for_in_days: integer()
        }
  def get_period_generation_days do
    %{
      generate_before_in_days: @generate_before_in_days,
      generate_for_in_days: @generate_for_in_days
    }
  end
end
