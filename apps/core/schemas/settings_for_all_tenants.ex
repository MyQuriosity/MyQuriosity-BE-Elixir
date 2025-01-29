defmodule Core.SettingsForAllTenants do
  @moduledoc """
  This schema is an interface over a database view which
  gets the union of tenant_settings for all tenants at the instance.

  This schema is `read-only`, it defines no changeset as nothing can
  be changed in this.
  """

  use Ecto.Schema

  @type t :: %__MODULE__{}
  @primary_key false
  schema "settings_for_all_tenants" do
    field(:institute_name, :string)
    field(:sub_domain, :string)
    field(:schema_prefix, :string)
    field(:external_site_url, :string)
    field(:is_external_site_url_approved, :boolean)
    field(:tenant_information_id, :binary_id)
    field(:approved_at, :utc_datetime)
    field(:tenant_deactivated_at, :utc_datetime)
  end
end
