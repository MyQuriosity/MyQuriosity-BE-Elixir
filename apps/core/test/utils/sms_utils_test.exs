defmodule Core.Utils.SMSUtilsTest do
  use Core.DataCase

  import Mock

  # with_mock Core.SMS, [:send_local_sms: fn get_sms_params -> %{"code" => "204", "response" => "Invalid SMS masking for
  # the customer.", "type" => "Error"}] do

  @number "03331234567"
  describe "send_local_sms/1" do
    setup [:get_sms_params]

    test "send sms to phone number", %{sms_params: params} do
      with_mock Core.SMS,
        send_local_sms: fn
          _params ->
            %{
              "code" => "300",
              "response" => "Message Sent to Telecom.",
              "type" => "Success"
            }
        end do
        assert params |> Core.SMS.send_local_sms() |> Map.drop(["transactionID"]) ==
                 %{
                   "code" => "300",
                   "response" => "Message Sent to Telecom.",
                   "type" => "Success"
                 }
      end
    end
  end

  defp get_sms_params(_) do
    {:ok,
     sms_params: %{
       "to" => @number,
       "text" => "Welcome to MyQampus"
     }}
  end
end
