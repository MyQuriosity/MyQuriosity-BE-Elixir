defmodule Core.Utils.HtmlEmailUtilsTest do
  use Core.DataCase
  import Mock

  describe "institute approval" do
    setup [:get_institute_approval_template_id]

    test "send email successfully", %{} do
      with_mock Campus.EmailUtils,
        send_institute_approval_email: fn
          _url, _params, _tenant, _password ->
            {:ok, %Bamboo.Email{}}
        end do
        params = %{
          email: "regbits@yopmail.com"
        }

        url = "http://dev.myqampus.com/signin"
        tenant = "reg"
        password = "password"

        assert Campus.EmailUtils.send_institute_approval_email(url, params, tenant, password) ==
                 {:ok, %Bamboo.Email{}}
      end
    end

    test "check email sending for failure case", %{} do
      with_mock Campus.EmailUtils,
        send_institute_approval_email: fn
          _url, _params, _tenant, _password ->
            %Bamboo.ApiError{}
        end do
        params = %{
          email: "regbits@yopmail.com"
        }

        url = "http://dev.myqampus.com/signin"
        tenant = "reg"
        password = "password"

        assert Campus.EmailUtils.send_institute_approval_email(url, params, tenant, password) ==
                 %Bamboo.ApiError{}
      end
    end
  end

  defp get_institute_approval_template_id(_) do
    send_tenant_credentials_template_id = System.get_env("INSTITUTE_TEMPLATE_APPROVAL")
    {:ok, send_tenant_credentials_template_id: send_tenant_credentials_template_id}
  end
end
