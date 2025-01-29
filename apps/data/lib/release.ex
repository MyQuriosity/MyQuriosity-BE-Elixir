# defmodule MyQampus.Release do
#   @moduledoc """
#   # TODO: Write proper moduledoc
#   """
#   alias Data.TenantInformation
#   @db_app :data
#   @tenant_db_app :tenant_data
#   @triplex_app :triplex
#   @e2e_tenant "e2e_school"
#   @unit_test_tenant "test_sub_domain"
#   @public_schema "public"

#   def migrate do
#     Logger.add_backend(Logger.Backends.Console)
#     load_app()

#     for repo <- repos() do
#       {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
#     end
#   end

#   # NOTE: This command is only meant to be used in CI-Jenkins E2E pipeline
#   def re_create_e2e_schemas do
#     load_and_start_data_apps()
#     re_create_schema(@e2e_tenant)
#   end

#   # NOTE: This command is only meant to be used in CI-Jenkins Unit Test pipeline
#   def re_create_unit_test_schemas do
#     load_and_start_data_apps()
#     re_create_schema(@unit_test_tenant)
#     # re_create_public_schema()
#   end

#   defp load_and_start_data_apps do
#     Logger.add_backend(Logger.Backends.Console)
#     load_app()
#     load_triplex_app()
#     start_app(@db_app)
#     start_app(@tenant_db_app)
#   end

#   # NOTE: Facing issues while drop public schemas, Maybe we will do it manually.
#   def re_create_public_schema do
#     if check_schema_exists?("team_user_oban") do
#       query = """
#         DROP SCHEMA team_user_oban CASCADE;
#       """

#       Ecto.Adapters.SQL.query!(Data.Repo, query, [])
#     end

#     if check_schema_exists?(@public_schema) do
#       query = """
#         DROP SCHEMA #{@public_schema} CASCADE;
#       """

#       Ecto.Adapters.SQL.query!(Data.Repo, query, [])
#     end

#     query = """
#       CREATE SCHEMA #{@public_schema};
#     """

#     Ecto.Adapters.SQL.query!(Data.Repo, query, [])
#   end

#   defp check_schema_exists?(schema) do
#     query = """
#     SELECT schema_name FROM information_schema.schemata WHERE schema_name = '#{schema}';
#     """

#     %Postgrex.Result{num_rows: num_rows} = Ecto.Adapters.SQL.query!(Data.Repo, query, [])
#     num_rows > 0
#   end

#   defp re_create_schema(schema) do
#     if Triplex.exists?(schema) do
#       Triplex.drop(schema)
#     end

#     # Sleep 2 seconds to finish dropping of schema
#     Process.sleep(2_000)
#     Triplex.create(schema)
#     # Sleep 5 seconds to finish creating of schema
#     Process.sleep(5_000)
#   end

#   def create_e2e_tenant_info do
#     load_and_start_data_apps()
#     params = tenant_info_params()

#     %TenantInformation{}
#     |> TenantInformation.changeset(params)
#     |> Data.Repo.insert()
#   end

#   defp tenant_info_params do
#     %{
#       sub_domain: @e2e_tenant,
#       tenant_prefix: @e2e_tenant
#     }
#   end

#   def seed_admin do
#     load_app()
#     start_app(@db_app)
#     team_admin_password = System.fetch_env!("TEAM_ADMIN_PASSWORD")

#     data = [
#       %{
#         first_name: "Super",
#         last_name: "Admin",
#         username: "admin",
#         hashed_password: Core.Utils.AuthUtils.hash_password(team_admin_password),
#         email: "admin@gmail.com",
#         phone: "03001234567",
#         gender: "male",
#         is_admin: true,
#         inserted_at: DateTime.truncate(DateTime.utc_now(), :second),
#         updated_at: DateTime.truncate(DateTime.utc_now(), :second)
#       }
#     ]

#     Data.Repo.insert_all(Data.TeamUser, data,
#       on_conflict: {:replace_all_except, [:id]},
#       returning: true,
#       conflict_target: [:id]
#     )
#   end

#   def rollback(repo, version) do
#     load_app()
#     {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
#   end

#   defp repos do
#     Application.fetch_env!(@db_app, :ecto_repos)
#   end

#   defp load_app do
#     Application.load(@db_app)
#   end

#   defp load_triplex_app do
#     Application.load(@triplex_app)
#     Application.load(@tenant_db_app)
#   end

#   defp start_app(app) do
#     Application.put_env(app, :minimal, true)
#     Application.ensure_all_started(app)
#   end
# end
