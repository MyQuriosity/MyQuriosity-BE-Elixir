defmodule Core.Macros.PK do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  defmacro __using__(_) do
    quote do
      @timestamps_opts [type: :utc_datetime]
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
