defmodule Core.Utils.TenantSiteUtils do
  @moduledoc false

  @doc false
  @spec endpoint_configs :: list()
  def endpoint_configs do
    Application.get_env(:core, ENDPOINT)
  end

  @spec site_base_url_without_sub_domain :: String.t()
  def site_base_url_without_sub_domain do
    String.replace(endpoint_configs()[:url_host], "be.", "")
  end

  @doc false
  @spec myqampus_site(String.t()) :: String.t()
  def myqampus_site(sub_domain) do
    "#{endpoint_configs()[:url_scheme]}://#{sub_domain}.#{site_base_url_without_sub_domain()}"
  end
end
