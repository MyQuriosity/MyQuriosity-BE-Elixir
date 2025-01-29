defmodule Core.Utils.CacheKeyUtils do
  @moduledoc "provide utility functions for cache key generation"

  @doc "generate key for institute_user cache keys"
  @spec tenant_user_endpoint_activity_key(String.t(), String.t(), String.t(), String.t()) ::
          String.t()
  def tenant_user_endpoint_activity_key(tenant_prefix, role, tenant_user_id, request_path) do
    "#{tenant_prefix}::#{role}::#{tenant_user_id}::#{request_path}"
  end

  @doc "genenrate key for feature/module action cache"
  @spec feature_action_key(String.t(), String.t(), map(), map()) :: String.t()
  def feature_action_key(TenantApiWeb.UserDetailController = feature, action, params, options)
      when action in [:user_role_details, :user_details] do
    user_params = Map.take(params, ["id"])
    action_key = :user_details
    user_params_key = map_to_key(user_params)
    params = Map.take(params, ["limit", "skip"])
    params_key = map_to_key(params)
    options_key = map_to_key(options)

    "#{feature}::#{action_key}::#{user_params_key}::#{params_key}::#{options_key}"
  end

  def feature_action_key(feature, action, params, options) do
    params_key = map_to_key(params)
    options_key = map_to_key(options)
    "#{feature}::#{action}::#{params_key}::#{options_key}"
  end

  @doc "genenrate partial for feature/module action cache"
  @spec partial_feature_action_key(String.t(), atom(), map()) :: String.t()
  def partial_feature_action_key(feature, action, params) do
    user_params_key = params |> Map.take(["id"]) |> map_to_key()
    "#{feature}::#{action}::#{user_params_key}"
  end

  defp map_to_key(payload) do
    payload_to_binary = :erlang.term_to_binary(payload)

    :sha256
    |> :crypto.hash(payload_to_binary)
    |> Base.encode16()
  end
end
