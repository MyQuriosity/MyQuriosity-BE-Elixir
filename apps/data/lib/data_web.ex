defmodule Data.Web do
  @moduledoc """
  # TODO: Write proper moduledoc
  """

  def model do
    quote do
      use Ecto.Schema
      require Core.Macros.CommonField

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
