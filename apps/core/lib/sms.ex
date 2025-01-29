defmodule Core.SMS do
  @moduledoc """
  This module is used for third party API for sms sending
  """

  @url "https://fastsmsalerts.com/api/composesms"

  @spec send_local_sms(map()) :: no_return()
  def send_local_sms(params) do
    @url
    |> Tesla.build_url(
      id: System.get_env("FASTSMSALERTS_ID"),
      pass: System.get_env("FASTSMSALERTS_PASS"),
      mask: System.get_env("FASTSMSALERTS_MASK"),
      to: String.replace(params["to"], ~r/[\+]/, ""),
      msg: params["text"],
      lang: "english",
      type: "json",
      portable: true
    )
    |> Tesla.get()
    |> case do
      {:ok, response} ->
        Jason.decode!(response.body)

      {:error, _error} ->
        %{"code" => 422}
    end
  end
end
