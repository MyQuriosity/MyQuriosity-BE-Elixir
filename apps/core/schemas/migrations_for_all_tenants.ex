defmodule Core.MigrationsForAllTenants do
  @moduledoc """
  This schema is an interface over a database view which
  gets the union of migrations which have ran for all tenants at the instance.

  This schema is `read-only`, it defines no changeset as nothing can
  be changed in this.
  """

  use Ecto.Schema

  @type t :: %__MODULE__{}
  @primary_key false
  schema "migrations_for_all_tenants" do
    field(:schema_prefix, :string)
    field(:version, :integer)
    field(:inserted_at, :utc_datetime )
  end

end
