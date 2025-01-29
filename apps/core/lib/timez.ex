defmodule Core.Timez do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  use Ecto.Type
  @spec type :: :time
  def type, do: :time

  @doc """
  Provide custom casting rules.
  Cast string into time to be used at runtime
  """
  @spec cast(String.t()) :: {:ok, Time.t()} | :error
  def cast(time) do
    validate_and_parse_time(time)
  end

  @doc """
  When loading data from the database, as long as it's a time,
  We just put the data back into a time to be stored in the loaded string.
  """
  @spec load(Time.t()) :: {:ok, Time.t()}
  def load(time) do
    time = Time.truncate(time, :second)
    {:ok, time}
  end

  @doc """
  When dumping data to the database, we *expect* a Time type
  """
  @spec dump(Time.t()) :: {:ok, Time.t()} | :error
  def dump(%Time{} = time) do
    {:ok, time}
  end

  def dump(_), do: :error

  @doc """
  Validate time and check time field have zone included in time e.g +0500
  """
  @spec validate_and_parse_time(String.t()) :: String.t() | :error
  def validate_and_parse_time(value) do
    if Regex.match?(~r/^\d{2}:\d{2}:\d{2}[\+|\-]\d{4}$/, value) do
      parse_time(value)
    else
      :error
    end
  end

  @doc """
  Parse time according to operator
  Operator are + or - only. Other are not allowed
  """
  @spec parse_time(String.t()) :: {:ok, Time.t()} | :error
  def parse_time(value) do
    operator =
      cond do
        String.contains?(value, "+") -> "+"
        String.contains?(value, "-") -> "-"
        true -> nil
      end

    do_parse_time(operator, value)
  end

  defp do_parse_time(nil, _value), do: :error

  defp do_parse_time(operator, value) do
    date = Date.to_iso8601(Date.utc_today())
    [time, zone] = String.split(value, operator)
    datetime = "#{date}T#{time}#{operator}#{zone}"

    case DateTime.from_iso8601(datetime) do
      {:ok, datetime, _} ->
        {:ok, DateTime.to_time(datetime)}

      _whatever ->
        :error
    end
  end
end
