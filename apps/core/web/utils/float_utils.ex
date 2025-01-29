defmodule Campus.FloatUtils do
  @moduledoc """
  This module contains utility functions related to floating numbers
  """

  @spec float_to_binary(float(), integer()) :: float()
  def float_to_binary(number, decimals \\ 1)

  def float_to_binary(nil, _), do: 0.0

  def float_to_binary(number, decimals),
    do: :erlang.float_to_binary(number, decimals: decimals)
end
