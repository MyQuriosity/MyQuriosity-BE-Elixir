defmodule Formatter.Log do
  @moduledoc """
   This is a good resource to learn about formatters
   https://timber.io/blog/the-ultimate-guide-to-logging-in-elixir/
  """

  @spec format(atom(), String.t(), tuple(), list()) :: String.t()
  def format(level, message, timestamp, metadata) do
    message
    |> decode()
    |> case do
      {:ok, msg} -> msg
      {:error, _} -> %{msg: message}
    end
    |> json_msg_format(level, timestamp, metadata)
    |> new_line()
  end

  defp decode(message) when is_binary(message) do
    {:ok, message}
  end

  defp decode(message) when is_number(message) do
    {:ok, message}
  end

  defp decode(message) do
    Jason.decode(message)
  end

  defp json_msg_format(message, level, timestamp, metadata) do
    base = %{
      timestamp: fmt_timestamp(timestamp),
      level: level,
      message: message
    }

    metadata =
      if is_list(metadata) do
        Keyword.drop(metadata, [:level, :pid])
      else
        metadata
      end

    metadata
    |> Enum.reduce(base, fn {k, v}, acc ->
      if is_pid(v) do
        Map.put(acc, k, inspect(v))
      else
        Map.put(acc, k, v)
      end
    end)
    |> Jason.encode()
    |> case do
      {:ok, msg} -> msg
      {:error, reason} -> Jason.encode(%{error: reason})
    end
  end

  defp new_line(msg), do: "#{msg}\n"

  defp fmt_timestamp({date, {hh, mm, ss, ms}}) do
    with {:ok, timestamp} <- NaiveDateTime.from_erl({date, {hh, mm, ss}}, {ms * 1000, 3}),
         result <- NaiveDateTime.to_iso8601(timestamp) do
      "#{result}Z"
    end
  end
end
