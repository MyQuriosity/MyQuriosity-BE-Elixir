defmodule Core.Utils.CsvUtils do
  @moduledoc """
    Provides utility functions for csv.
  """
  alias Campus.StringUtils

  @doc """
    This method is used to generate csv from data
  """
  @spec generate_csv(list(), map()) :: String.t()
  def generate_csv(records, csv_headers) do
    headers =
      csv_headers
      |> Map.values()
      |> Enum.sort()

    csv_file =
      records
      |> filter_columns_by_headers(headers)
      |> CSV.encode()
      |> Enum.to_list()
      |> to_string()

    headers = Enum.join(headers, ",")
    "#{headers}\r\n#{csv_file}"
  end

  @doc """
    This method is used to filter csv headers
  """
  @spec filter_csv_headers(map(), map()) :: String.t()
  def filter_csv_headers(csv_headers, default_headers) when csv_headers == %{} do
    default_headers
  end

  def filter_csv_headers(csv_headers, default_headers) do
    csv_headers
    |> Enum.filter(fn {k, _} -> Map.has_key?(default_headers, k) end)
    |> Enum.into(%{})
  end

  @doc """
    This method is used to reject the keys having empty values("", nil)
    and also trim the white spaces and replace the space between the key with underscore
    For example
    input => %{"first name" => "John  ", "last name" => "Mark", "email" => "", "age" => 34}
    out => %{"first_name" => "John", "last_name" => "Mark", "age" => 34}
  """
  @spec reject_empty_values_keys(map()) :: map()
  def reject_empty_values_keys(map) do
    map
    |> Enum.reduce(%{}, fn {key, value}, response ->
      if value in ["", nil] do
        response
      else
        key = StringUtils.replace_non_empty_key(key, " ", "_")
        value = StringUtils.trim_non_empty_field(value, " ")
        Map.put(response, key, value)
      end
    end)
    |> Enum.into(%{})
  end

  defp filter_columns_by_headers(records, headers) do
    Enum.map(records, fn record ->
      record
      |> Map.take(headers)
      |> Map.values()
    end)
  end
end
