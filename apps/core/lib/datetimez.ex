defmodule Core.DateTimez do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  use Ecto.Type
  @spec type :: :utc_datetime
  def type, do: :utc_datetime

  @doc """
  Provide custom casting rules.
  Cast string into time to be used at runtime
  """
  @spec cast(String.t()) :: {:ok, DateTime.t()} | :error
  def cast(datetime) do
    validate_and_parse_datetime(datetime)
  end

  @doc """
  When loading data from the database, as long as it's a time,
  We just put the data back into a time to be stored in the loaded string.
  """
  @spec load(NaiveDateTime.t()) :: {:ok, DateTime.t()}
  def load(datetime) do
    {:ok, datetime} = DateTime.from_naive(datetime, "Etc/UTC")
    datetime = DateTime.truncate(datetime, :second)
    {:ok, datetime}
  end

  @doc """
  When dumping data to the database, we *expect* a Time type
  """
  @spec dump(DateTime.t()) :: {:ok, DateTime.t()} | :error
  def dump(%DateTime{} = datetime) do
    {:ok, datetime}
  end

  def dump(_), do: :error

  @doc """
  Validate time and check time field have zone included in time e.g +0500
  """
  @spec validate_and_parse_datetime(String.t()) :: String.t() | :error
  def validate_and_parse_datetime(value) do
    if Regex.match?(~r/^\d{4}-\d{2}-\d{2}[T|\s]\d{2}:\d{2}:\d{2}[\+|\-]\d{4}$/, value) do
      parse_datetime(value)
    else
      :error
    end
  end

  @doc """
  Parse time according to operator
  Operator are + or - only. Other are not allowed
  """
  @spec parse_datetime(String.t()) :: {:ok, DateTime.t()} | :error
  def parse_datetime(value) do
    operator =
      cond do
        String.contains?(value, "+") -> "+"
        String.contains?(value, "-") -> "-"
        true -> nil
      end

    do_parse_datetime(operator, value)
  end

  defp do_parse_datetime(nil, _value), do: :error

  defp do_parse_datetime(operator, value) do
    [zone, datetime] = value |> String.reverse() |> String.split(operator, parts: 2)
    datetime = String.reverse(datetime)
    zone = String.reverse(zone)
    datetime = "#{datetime}#{operator}#{zone}"

    case DateTime.from_iso8601(datetime) do
      {:ok, datetime, _} ->
        {:ok, datetime}

      _whatever ->
        :error
    end
  end
end
