# defmodule Data.Context.TenantInfoFiltersContext do
#   @moduledoc """
#   Filter context for tenant information
#   """
#   import Ecto.Query
#   alias Data.TenantInformation
#   alias Data.User

#   def query_for(claims, %{"status" => "deleted"}) do
#     query =
#       from(req in TenantInformation,
#         join: sft in Core.SettingsForAllTenants,
#         on: req.tenant_prefix == sft.schema_prefix,
#         where: is_nil(sft.tenant_deactivated_at),
#         preload: [:inserted_by]
#       )

#     query_for_filter(query, claims)
#   end

#   def query_for(claims, %{"status" => "deactivated"}) do
#     query =
#       from(req in TenantInformation,
#         preload: [:inserted_by],
#         where: is_nil(req.tenant_deleted_at)
#       )

#     query_for_filter(query, claims)
#   end

#   def query_for(claims, %{"status" => "all"}) do
#     query =
#       from(req in TenantInformation,
#         preload: [:inserted_by]
#       )

#     query_for_filter(query, claims)
#   end

#   def query_for(claims, _params) do
#     query =
#       from(req in TenantInformation,
#         preload: [:inserted_by],
#         where: is_nil(req.tenant_deleted_at)
#       )

#     query_for_filter(query, claims)
#   end

#   def query_for_filter(query, %{"is_admin" => true} = _claims), do: query

#   def query_for_filter(query, claims) do
#     from(q in query,
#       join: user in User,
#       on: user.id == q.inserted_by_id,
#       where: user.team_user_id == ^claims["sub"] and user.can_team_user_access_tenant
#     )
#   end

#   @spec filter(Ecto.Query.t(), map()) :: Ecto.Query.t()
#   def filter(query, %{"status" => "pending"} = params) do
#     {_value, params} = Map.pop(params, "status")

#     query =
#       from(q in query,
#         join: sft in Core.SettingsForAllTenants,
#         on: q.tenant_prefix == sft.schema_prefix,
#         where:
#           is_nil(sft.approved_at) and is_nil(q.rejected_at) and is_nil(sft.tenant_deactivated_at) and
#             is_nil(q.tenant_deleted_at)
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"status" => "activated"} = params) do
#     {_value, params} = Map.pop(params, "status")

#     query
#     |> join(:inner, [q], sft in Core.SettingsForAllTenants,
#       on: q.tenant_prefix == sft.schema_prefix,
#       as: :sft
#     )
#     |> where(
#       [q, sft: sft],
#       is_nil(q.tenant_deleted_at) and is_nil(sft.tenant_deactivated_at) and is_nil(q.rejected_at) and
#         not is_nil(sft.approved_at)
#     )
#     |> filter(params)
#   end

#   def filter(query, %{"status" => "approved"} = params) do
#     {_value, params} = Map.pop(params, "status")

#     query =
#       from(q in query,
#         join: sft in Core.SettingsForAllTenants,
#         on: q.tenant_prefix == sft.schema_prefix,
#         where: not is_nil(sft.approved_at)
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"status" => "rejected"} = params) do
#     {_value, params} = Map.pop(params, "status")

#     query =
#       from(q in query,
#         where: not is_nil(q.rejected_at)
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"status" => "deactivated"} = params) do
#     {_value, params} = Map.pop(params, "status")

#     query =
#       from(q in query,
#         join: sft in Core.SettingsForAllTenants,
#         on: q.tenant_prefix == sft.schema_prefix,
#         where: not is_nil(sft.tenant_deactivated_at)
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"status" => "deleted"} = params) do
#     {_value, params} = Map.pop(params, "status")

#     query =
#       from(q in query,
#         where: not is_nil(q.tenant_deleted_at)
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"email" => email} = params) do
#     {_value, params} = Map.pop(params, "email")

#     query =
#       from(q in query,
#         join: u in User,
#         on: q.inserted_by_id == u.id,
#         where: ilike(u.email, ^"%#{email}%")
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"phone" => phone} = params) do
#     {_value, params} = Map.pop(params, "phone")

#     query =
#       from(q in query,
#         join: u in User,
#         on: q.inserted_by_id == u.id,
#         where: ilike(u.phone, ^"%#{phone}%")
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"username" => username} = params) do
#     {_value, params} = Map.pop(params, "username")

#     query =
#       from(q in query,
#         join: u in User,
#         on: q.inserted_by_id == u.id,
#         where: ilike(u.username, ^"%#{username}%")
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"search" => search} = params) do
#     {_value, params} = Map.pop(params, "search")

#     query
#     |> join(:inner, [q], u in User, on: q.inserted_by_id == u.id, as: :user)
#     |> where(
#       [user: user],
#       ilike(fragment("CONCAT(?, ' ', ?)", user.first_name, user.last_name), ^"%#{search}%") or
#         ilike(user.first_name, ^"%#{search}%") or ilike(user.last_name, ^"%#{search}%")
#     )
#     |> filter(params)
#   end

#   def filter(query, %{"institute_name" => institute_name} = params) do
#     {_value, params} = Map.pop(params, "institute_name")

#     query =
#       from(q in query,
#         where: ilike(q.institute_name, ^"%#{institute_name}%")
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"sub_domain" => sub_domain} = params) do
#     {_value, params} = Map.pop(params, "sub_domain")

#     query =
#       from(q in query,
#         where: ilike(q.sub_domain, ^"%#{sub_domain}%")
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"site_url" => site_url} = params) do
#     {_value, params} = Map.pop(params, "site_url")

#     query =
#       from(q in query,
#         where: ilike(q.site_url, ^"%#{site_url}%")
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"pending_before" => date} = params) do
#     {_value, params} = Map.pop(params, "pending_before")

#     date = Date.from_iso8601!(date)

#     query =
#       from(q in query,
#         join: sft in Core.SettingsForAllTenants,
#         on: q.tenant_prefix == sft.schema_prefix,
#         where:
#           is_nil(sft.approved_at) and is_nil(q.rejected_at) and is_nil(sft.tenant_deactivated_at) and
#             is_nil(q.tenant_deleted_at) and
#             fragment("?::date", q.inserted_at) <= ^date
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"pending_after" => date} = params) do
#     {_value, params} = Map.pop(params, "pending_after")

#     date = Date.from_iso8601!(date)

#     query =
#       from(q in query,
#         join: sft in Core.SettingsForAllTenants,
#         on: q.tenant_prefix == sft.schema_prefix,
#         where:
#           is_nil(sft.approved_at) and is_nil(q.rejected_at) and is_nil(sft.tenant_deactivated_at) and
#             is_nil(q.tenant_deleted_at) and
#             fragment("?::date", q.inserted_at) >= ^date
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"approved_before" => date} = params) do
#     {_value, params} = Map.pop(params, "approved_before")

#     date = Date.from_iso8601!(date)

#     query =
#       from(q in query,
#         join: sft in Core.SettingsForAllTenants,
#         on: q.tenant_prefix == sft.schema_prefix,
#         where: not is_nil(sft.approved_at) and fragment("?::date", sft.approved_at) <= ^date
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"approved_after" => date} = params) do
#     {_value, params} = Map.pop(params, "approved_after")

#     date = Date.from_iso8601!(date)

#     query =
#       from(q in query,
#         join: sft in Core.SettingsForAllTenants,
#         on: q.tenant_prefix == sft.schema_prefix,
#         where: not is_nil(sft.approved_at) and fragment("?::date", sft.approved_at) >= ^date
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"rejected_before" => date} = params) do
#     {_value, params} = Map.pop(params, "rejected_before")

#     date = Date.from_iso8601!(date)

#     query =
#       from(q in query,
#         where: not is_nil(q.rejected_at) and fragment("?::date", q.rejected_at) <= ^date
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"rejected_after" => date} = params) do
#     {_value, params} = Map.pop(params, "rejected_after")

#     date = Date.from_iso8601!(date)

#     query =
#       from(q in query,
#         where: not is_nil(q.rejected_at) and fragment("?::date", q.rejected_at) >= ^date
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"deactivated_before" => date} = params) do
#     {_value, params} = Map.pop(params, "deactivated_before")

#     date = Date.from_iso8601!(date)

#     query =
#       from(q in query,
#         join: sft in Core.SettingsForAllTenants,
#         on: q.tenant_prefix == sft.schema_prefix,
#         where:
#           not is_nil(sft.tenant_deactivated_at) and
#             fragment("?::date", sft.tenant_deactivated_at) <= ^date
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"deactivated_after" => date} = params) do
#     {_value, params} = Map.pop(params, "deactivated_after")

#     date = Date.from_iso8601!(date)

#     query =
#       from(q in query,
#         join: sft in Core.SettingsForAllTenants,
#         on: q.tenant_prefix == sft.schema_prefix,
#         where:
#           not is_nil(sft.tenant_deactivated_at) and
#             fragment("?::date", sft.tenant_deactivated_at) >= ^date
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"sort_by" => "approved"} = params) do
#     {_value, params} = Map.pop(params, "sort_by")

#     query =
#       from(q in query,
#         order_by: [:approved_at]
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"sort_by" => "rejected"} = params) do
#     {_value, params} = Map.pop(params, "sort_by")

#     query =
#       from(q in query,
#         order_by: [:rejected_at]
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"sort_by" => "deactivated"} = params) do
#     {_value, params} = Map.pop(params, "sort_by")

#     query =
#       from(q in query,
#         order_by: [:tenant_deactivated_at]
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"sort_by" => "inserted_at"} = params) do
#     {_value, params} = Map.pop(params, "sort_by")

#     query =
#       from(q in query,
#         order_by: [:inserted_at]
#       )

#     filter(query, params)
#   end

#   def filter(query, %{"sort_by" => "updated_at"} = params) do
#     {_value, params} = Map.pop(params, "sort_by")

#     query =
#       from(q in query,
#         order_by: [:updated_at]
#       )

#     filter(query, params)
#   end

#   def filter(query, _params) do
#     query
#   end
# end
