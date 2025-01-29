# defmodule Data.Utils.TenantInfoUtils do
#   @moduledoc """
#   Utility functions over tenant's settings via TenantInformation
#   """

#   import Ecto.Query
#   alias Campus.StringUtils
#   alias Core.SettingsForAllTenants
#   alias Data.TenantInformation

#   @doc """
#   Check if tenant is approved, via SettingsForAllTenants
#   """
#   @spec is_institute_approved?(TenantInformation.t()) :: boolean()
#   def is_institute_approved?(%TenantInformation{id: tenant_info_id}) do
#     try do
#       query =
#         from(q in SettingsForAllTenants,
#           where: q.tenant_information_id == ^tenant_info_id and not is_nil(q.approved_at),
#           select: count(q)
#         )

#       records_count =
#         Data.Repo.one(query)

#       records_count > 0
#     rescue
#       _ -> false
#     end
#   end

#   @doc """
#   Get tenant's approved_at timestamp, via SettingsForAllTenants
#   """
#   @spec get_institute_approved_at(TenantInformation.t()) :: String.t()
#   def get_institute_approved_at(%TenantInformation{id: tenant_info_id}) do
#     try do
#       from(q in SettingsForAllTenants,
#         where: q.tenant_information_id == ^tenant_info_id
#       )
#       |> Data.Repo.one()
#       |> case do
#         nil ->
#           nil

#         record ->
#           record.approved_at
#       end
#     rescue
#       # in case given tenant is not migrated, above query will fail
#       # giving error
#       _ ->
#         nil
#     end
#   end

#   @doc """
#   Get tenant's deactivated_at timestamp , via SettingsForAllTenants
#   """
#   @spec get_institute_deactivated_at(TenantInformation.t()) :: boolean()
#   def get_institute_deactivated_at(%TenantInformation{id: tenant_info_id}) do
#     try do
#       from(q in SettingsForAllTenants,
#         where: q.tenant_information_id == ^tenant_info_id
#       )
#       |> Data.Repo.one()
#       |> case do
#         nil ->
#           nil

#         record ->
#           record.tenant_deactivated_at
#       end
#     rescue
#       _ -> nil
#     end
#   end

#   @doc """
#   Check if tenant is active. An active institute is on which is approved and
#   is not deactivated
#   """
#   @spec fetch_tenant_setting(TenantInformation.t()) :: SettingsForAllTenants.t() | nil

#   def fetch_tenant_setting(%TenantInformation{id: tenant_info_id}) do
#     SettingsForAllTenants
#     |> where(
#       [q],
#       q.tenant_information_id == ^tenant_info_id and not is_nil(q.approved_at) and
#         is_nil(q.tenant_deactivated_at)
#     )
#     |> Data.Repo.one()
#   end

#   @doc """
#   Check if external_site is approved for given tenant
#   """
#   @spec is_external_site_approved?(TenantInformation.t()) :: boolean()
#   def is_external_site_approved?(%TenantInformation{id: tenant_info_id}) do
#     try do
#       from(q in SettingsForAllTenants,
#         where: q.tenant_information_id == ^tenant_info_id and not is_nil(q.approved_at),
#         select: count(q)
#       )
#       |> Data.Repo.one()
#       |> case do
#         0 ->
#           false

#         _ ->
#           true
#       end
#     rescue
#       _ -> false
#     end
#   end

#   @doc """
#   Check if tenant is approved, via SettingsForAllTenants
#   """
#   @spec is_institute_deactivated?(TenantInformation.t()) :: boolean()
#   def is_institute_deactivated?(%TenantInformation{id: tenant_info_id}) do
#     try do
#       query =
#         from(q in SettingsForAllTenants,
#           where:
#             q.tenant_information_id == ^tenant_info_id and not is_nil(q.tenant_deactivated_at),
#           select: count(q)
#         )

#       records_count =
#         Data.Repo.one(query)

#       records_count > 0
#     rescue
#       _ -> false
#     end
#   end

#   @doc """
#   Check if setup has ran for given institute
#   """
#   @spec is_institute_set_up?(String.t()) :: boolean()
#   def is_institute_set_up?(tenant_info_id) do
#     try do
#       query =
#         from(q in SettingsForAllTenants,
#           where:
#             q.tenant_information_id == ^tenant_info_id and is_nil(q.tenant_deactivated_at) and
#               not is_nil(q.tenant_information_id),
#           select: count(q)
#         )

#       records_count =
#         Data.Repo.one(query)

#       records_count > 0
#     rescue
#       _ -> false
#     end
#   end

#   @doc """
#   Returns a list of all created prefixes
#   """
#   @spec get_subdomains() :: [String.t()]
#   def get_subdomains do
#     Data.TenantInformation
#     |> Data.Repo.all()
#     |> Enum.reduce([], fn tenant_info, acc ->
#       [tenant_info.sub_domain | acc]
#     end)
#   end

#   @doc """
#   In case we are creating a sub_domain ourselves, make sure that sub_domain
#   is uniq and does not exists in the
#   """
#   @spec get_uniq_sub_domain([String.t()], String.t()) :: String.t()
#   def get_uniq_sub_domain(existing_sub_domains, seed_string) do
#     generated_sub_domain = StringUtils.generate_sub_domain(seed_string)

#     (generated_sub_domain not in existing_sub_domains && generated_sub_domain) ||
#       get_uniq_sub_domain(existing_sub_domains, generated_sub_domain)
#   end

#   @doc """
#   takes in TenantInformation and a keyword of fields, to fetch from corresponding
#   TenantSetting and append these fields to the given tenant info which is then returned
#   """
#   @spec append_into_tenant_info(TenantInformation.t(), list()) :: map()
#   def append_into_tenant_info(tenant_info, [:schema_created | fields]) do
#     schema_created? = is_tenant_schema_created?(tenant_info)

#     tenant_info
#     |> Map.put(:schema_created, schema_created?)
#     |> append_into_tenant_info(fields)
#   end

#   def append_into_tenant_info(tenant_info, [:migrated | fields]) do
#     migrations_ran? = is_schema_fully_migrated?(tenant_info)

#     tenant_info
#     |> Map.put(:migrated, migrations_ran?)
#     |> append_into_tenant_info(fields)
#   end

#   def append_into_tenant_info(tenant_info, [:approved_at | fields]) do
#     approved_at = get_institute_approved_at(tenant_info)

#     tenant_info
#     |> Map.put(:approved_at, approved_at)
#     |> append_into_tenant_info(fields)
#   end

#   def append_into_tenant_info(tenant_info, [:is_external_site_url_approved | fields]) do
#     is_external_site_url_approved = is_external_site_approved?(tenant_info)

#     tenant_info
#     |> Map.put(:is_external_site_url_approved, is_external_site_url_approved)
#     |> append_into_tenant_info(fields)
#   end

#   def append_into_tenant_info(tenant_info, [:active | fields]) do
#     active = if fetch_tenant_setting(tenant_info), do: true, else: false

#     tenant_info
#     |> Map.put(:active, active)
#     |> append_into_tenant_info(fields)
#   end

#   def append_into_tenant_info(tenant_info, [:tenant_deactivated_at | fields]) do
#     tenant_deactivated_at = get_institute_deactivated_at(tenant_info)

#     tenant_info
#     |> Map.put(:tenant_deactivated_at, tenant_deactivated_at)
#     |> append_into_tenant_info(fields)
#   end

#   def append_into_tenant_info(tenant_info, _), do: tenant_info

#   @doc """
#   Returns a boolean tuple indicating status of schema creater and migrated
#   """
#   @spec get_tenant_created_migrated_status(TenantInformation.t()) :: {boolean(), boolean()}
#   def get_tenant_created_migrated_status(tenant_info) do
#     migrations_ran? = is_schema_fully_migrated?(tenant_info)
#     schema_created? = is_tenant_schema_created?(tenant_info)
#     {schema_created?, migrations_ran?}
#   end

#   @doc """
#   Check if schema for tenant is created or not
#   """
#   @spec is_tenant_schema_created?(TenantInformation.t()) :: boolean()
#   def is_tenant_schema_created?(%TenantInformation{tenant_prefix: nil}), do: false

#   def is_tenant_schema_created?(%TenantInformation{tenant_prefix: tenant_prefix}),
#     do: tenant_prefix in Triplex.all()

#   @doc """
#   This function checks if migrations have ran fully for a given tenant,
#   identified by `tenant_prefix`
#   This is done by getting the version for the latest migration present in
#   tenant_migrations direcory, that version is compared with the given tenant's
#   migration record, obtained from Core.MigrationsForAllTenants
#   """
#   @spec is_schema_fully_migrated?(TenantInformation.t()) :: boolean()
#   def is_schema_fully_migrated?(%TenantInformation{tenant_prefix: nil}), do: false

#   def is_schema_fully_migrated?(%TenantInformation{tenant_prefix: tenant_prefix}) do
#     if tenant_prefix in Triplex.all() do
#       {:ok, migration_files} = Path.Wildcard.list_dir(get_tenant_migrations_path())

#       migration_files
#       |> Stream.map(fn migration_file ->
#         {int_version, _} =
#           migration_file
#           # the file names returned by Path modules
#           # do not seem to be `bitstrings` or `binary`
#           # inorder to apply string ops we need to convert
#           # the file name to string explicitly
#           |> to_string()
#           |> String.split("_")
#           |> List.first()
#           |> Integer.parse()

#         int_version
#       end)
#       |> Enum.sort(:desc)
#       |> List.first()
#       |> has_migration_version?(tenant_prefix)
#     else
#       false
#     end
#   end

#   # given a tenant's prefix and a migration's versin number,
#   # this method checks if the version is present in tenant's
#   # migrations,
#   defp has_migration_version?(version, tenant_prefix) do
#     from(q in Core.MigrationsForAllTenants,
#       where: q.schema_prefix == ^tenant_prefix and q.version == ^version
#     )
#     |> Data.Repo.one()
#     |> case do
#       nil -> false
#       _records -> true
#     end
#   end

#   defp get_tenant_migrations_path,
#     do: to_string(:code.priv_dir(:tenant_data)) <> "/repo/tenant_migrations"
# end
