# defmodule Data.Repo do
#   use Ecto.Repo,
#     otp_app: :data,
#     adapter: Ecto.Adapters.Postgres

#   use Ecto.SoftDelete.Repo

#   @schema_prefix {__MODULE__, :schema_prefix}
#   @public_schemas ["public", "team_user_oban", "tenant_notifire_oban"]

#   @spec put_schema_prefix(String.t()) :: nil | String.t()
#   def put_schema_prefix(schema_prefix) do
#     Process.put(@schema_prefix, schema_prefix)
#   end

#   @spec get_schema_prefix :: term()
#   def get_schema_prefix do
#     Process.get(@schema_prefix)
#   end

#   @impl true
#   def default_options(_operation) do
#     tenant_prefix = get_schema_prefix()

#     cond do
#       tenant_prefix in @public_schemas ->
#         raise RuntimeError, message: "Bad Schema Prefix"

#       tenant_prefix ->
#         [prefix: tenant_prefix]

#       true ->
#         []
#     end
#   end
# end
