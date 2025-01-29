defmodule Core.Macros.CommonField do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  defmacro relational_fields(schema) do
    quote do
      belongs_to(:inserted_by, unquote(schema))
      belongs_to(:updated_by, unquote(schema))
      belongs_to(:deactivated_by, unquote(schema))
    end
  end
end
