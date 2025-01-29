defmodule Core.Utils.HelperUtilsTest do
  use Core.DataCase

  alias Core.Utils.HelperUtils

  #  for test cases only
  @skip_value 5
  @limit_value 10

  describe "get_skip_value/1" do
    setup [:get_skip_params, :get_default_params]

    test "returns skip value with skip params", %{skip_params: params} do
      assert {5, []} = HelperUtils.get_skip_value(params)
    end

    test "returns skip value with default params", %{default_params: params} do
      limit = params[:limit]
      assert {5, [limit: ^limit]} = HelperUtils.get_skip_value(params)
    end
  end

  describe "get_limit_value/1" do
    setup [:get_limit_params, :get_default_params]

    test "returns limit value with limit params", %{limit_params: params} do
      assert {10, []} = HelperUtils.get_limit_value(params)
    end

    test "returns limit value with default params", %{default_params: params} do
      skip = params[:skip]
      assert {10, [skip: ^skip]} = HelperUtils.get_limit_value(params)
    end
  end

  defp get_limit_params(_) do
    {:ok, limit_params: [limit: @limit_value]}
  end

  defp get_skip_params(_) do
    {:ok, skip_params: [skip: @skip_value]}
  end

  defp get_default_params(_) do
    {:ok, default_params: [skip: @skip_value, limit: @limit_value]}
  end
end
