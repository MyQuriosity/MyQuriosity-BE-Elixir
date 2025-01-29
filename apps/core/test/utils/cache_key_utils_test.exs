defmodule Core.Utils.CacheKeyUtilsTest do
  use Core.DataCase

  alias Core.Utils.CacheKeyUtils

  setup [
    :get_institue_user_payload
  ]

  describe "cache key generator" do
    test "generate key for institue user activity cache", %{institue_user: institue_user} do
      result =
        CacheKeyUtils.tenant_user_endpoint_activity_key(
          institue_user.tenant_prefix,
          institue_user.role,
          institue_user.tenant_user_id,
          institue_user.request_path
        )

      assert result == "test_123::section_teacher::5455-4545-4554-34ed-23de::section/:id"
    end
  end

  defp get_institue_user_payload(_) do
    {:ok,
     institue_user: %{
       tenant_prefix: "test_123",
       role: "section_teacher",
       tenant_user_id: "5455-4545-4554-34ed-23de",
       request_path: "section/:id"
     }}
  end
end
