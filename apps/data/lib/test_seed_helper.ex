defmodule TestSeedHelper do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  def utc_datetime(time, days \\ 0) do
    {:ok, time} = Time.from_iso8601(time)
    {:ok, datetime} = Date.utc_today() |> Date.add(days) |> DateTime.new(time, "Etc/UTC")
    datetime
  end

  def utc_time(time) do
    {:ok, time} = Time.from_iso8601(time)
    time
  end

  def week_day(date \\ Date.utc_today(), number \\ 0) do
    days = %{
      "7" => "sunday",
      "1" => "monday",
      "2" => "tuesday",
      "3" => "wednesday",
      "4" => "thursday",
      "5" => "friday",
      "6" => "saturday"
    }

    day = date |> Date.add(number) |> Date.day_of_week()
    days["#{day}"]
  end

  def current_datetime(type, return, time \\ 0) do
    datetime =
      case type do
        :utc -> DateTime.add(DateTime.utc_now(), time)
        :naive -> NaiveDateTime.add(NaiveDateTime.utc_now(), time)
      end

    case return do
      :datetime ->
        datetime

      :date ->
        if type == :utc, do: DateTime.to_date(datetime), else: NaiveDateTime.to_date(datetime)
    end
  end

  def current_time(time \\ 0) do
    DateTime.utc_now() |> DateTime.add(time) |> DateTime.to_time()
  end

  def default_time_zone, do: "+0500"

  def upcoming_datetime do
    Timex.now()
    |> Timex.shift(days: 1)
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_iso8601()
  end
end
