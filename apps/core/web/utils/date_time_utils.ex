defmodule Campus.DateTimeUtils do
  @moduledoc """
  This module is used as utils for datetime functionalities
  """

  @week_first_day 1
  @week_last_day 7
  @spec utc_datetime(String.t(), integer()) :: DateTime.t()
  def utc_datetime(time, days \\ 0) do
    {:ok, time} = Time.from_iso8601(time)
    {:ok, datetime} = Date.utc_today() |> Date.add(days) |> DateTime.new(time, "Etc/UTC")
    datetime
  end

  @spec utc_datetime(Time.t(), map(), integer()) :: DateTime.t()
  def utc_datetime(time, date, days) do
    {:ok, datetime} = date |> Date.add(days) |> DateTime.new(time, "Etc/UTC")
    datetime
  end

  @spec utc_time(String.t()) :: Time.t()
  def utc_time(time) do
    {:ok, time} = Time.from_iso8601(time)
    time
  end

  @spec month_name_by_number(integer()) :: String.t()
  def month_name_by_number(number \\ 1) do
    month = %{
      "1" => "January",
      "2" => "Feburary",
      "3" => "March",
      "4" => "April",
      "5" => "May",
      "6" => "June",
      "7" => "July",
      "8" => "August",
      "9" => "September",
      "10" => "October",
      "11" => "November",
      "12" => "December"
    }

    month["#{number}"]
  end

  @doc """
  for getting month shortname by month number
  """
  @spec month_shortname_by_number(integer()) :: String.t()
  def month_shortname_by_number(number \\ 1) do
    month = %{
      "1" => "Jan",
      "2" => "Feb",
      "3" => "Mar",
      "4" => "Apr",
      "5" => "May",
      "6" => "Jun",
      "7" => "Jul",
      "8" => "Aug",
      "9" => "Sep",
      "10" => "Oct",
      "11" => "Nov",
      "12" => "Dec"
    }

    month["#{number}"]
  end

  @spec week_day_name_by_date(map(), integer()) :: String.t()
  def week_day_name_by_date(date, number \\ 0) do
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

  @spec week_day_number_by_day_name(String.t()) :: integer()
  def week_day_number_by_day_name(day) do
    days = %{
      "sunday" => 7,
      "monday" => 1,
      "tuesday" => 2,
      "wednesday" => 3,
      "thursday" => 4,
      "friday" => 5,
      "saturday" => 6
    }

    days["#{day}"]
  end

  @doc """
    This function returns the previous day of week as per the current day is given
  """
  @spec week_previous_day(String.t()) :: String.t()
  def week_previous_day(current_day_name) do
    day_number = week_day_number_by_day_name(current_day_name)

    previous_day =
      if day_number - 1 < @week_first_day,
        do: @week_last_day,
        else: day_number - 1

    week_day_name_by_number(previous_day)
  end

  @doc """
    This function returns the next day of week as per the current day is given
  """
  @spec week_next_day(String.t()) :: String.t()
  def week_next_day(current_day_name) do
    day_number = week_day_number_by_day_name(current_day_name)

    next_day =
      if day_number + 1 > @week_last_day,
        do: @week_first_day,
        else: day_number + 1

    week_day_name_by_number(next_day)
  end

  @spec current_datetime(:naive | :utc, :date | :datetime) :: DateTime.t() | NaiveDateTime.t()
  def current_datetime(type, return) do
    datetime =
      case type do
        :utc -> DateTime.utc_now()
        :naive -> NaiveDateTime.utc_now()
      end

    case return do
      :datetime ->
        datetime

      :date ->
        if type == :utc, do: DateTime.to_date(datetime), else: NaiveDateTime.to_date(datetime)
    end
  end

  # TODO: needs to be refertored
  @spec get_date_by_day(String.t(), Time.t() | nil) :: Date.t()
  def get_date_by_day(day, time \\ nil) do
    date = current_datetime(:utc, :date)

    days = %{
      "sunday" => 7,
      "monday" => 1,
      "tuesday" => 2,
      "wednesday" => 3,
      "thursday" => 4,
      "friday" => 5,
      "saturday" => 6
    }

    day_num = [1, 2, 3, 4, 5, 6, 7]
    current_day = Date.day_of_week(date)
    x = Enum.map(1..current_day, fn x -> x end)
    y = day_num -- x
    day_num = y ++ x

    if current_day == days["#{day}"] do
      if !is_nil(time) && Time.compare(Time.utc_now(), time) == :gt do
        Date.add(date, Enum.find_index(day_num, fn x -> x == days["#{day}"] end) + 1)
      else
        Date.add(date, 0)
      end
    else
      Date.add(date, Enum.find_index(day_num, fn x -> x == days["#{day}"] end) + 1)
    end
  end

  @doc """
   This function checks if the given string containts Date & Time
  """
  @spec contains_date_and_time?(String.t()) :: boolean()
  def contains_date_and_time?(date_time) do
    regex = ~r/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/

    case Regex.run(regex, date_time) do
      [_datetime] -> true
      _ -> false
    end
  end

  @doc """
   This function checks if the given string is the date_time
  """
  @spec check_if_value_is_date_time?(String.t()) :: boolean()
  def check_if_value_is_date_time?(datetime) do
    case DateTime.from_iso8601(datetime) do
      {:ok, _, _} -> true
      _ -> false
    end
  end

  @doc """
   This function checks if the given string containts Time
  """
  @spec contains_time?(String.t()) :: boolean()
  def contains_time?(time) do
    regex = ~r/\d{2}:\d{2}:\d{2}/

    case Regex.run(regex, time) do
      [_time] -> true
      _ -> false
    end
  end

  @doc """
   This function checks if the given string is the time
  """
  @spec check_if_value_is_time?(String.t()) :: boolean()
  def check_if_value_is_time?(time) do
    case Time.from_iso8601(time) do
      {:ok, _} -> true
      _ -> false
    end
  end

  defp week_day_name_by_number(day_number) do
    days = %{
      "7" => "sunday",
      "1" => "monday",
      "2" => "tuesday",
      "3" => "wednesday",
      "4" => "thursday",
      "5" => "friday",
      "6" => "saturday"
    }

    days["#{day_number}"]
  end
end
