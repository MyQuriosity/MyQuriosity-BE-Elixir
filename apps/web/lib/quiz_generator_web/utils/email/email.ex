defmodule Web.Email do
  @moduledoc """
  This module is used to set Bamboo email struct
  """
  import Bamboo.Email
  alias Web.Utils.ConfigUtils

  @spec email(map()) :: Bamboo.Email.t()
  def email(%{"from" => _} = params) do
    new_email(
      to: params["to"],
      from: params["from"],
      subject: params["subject"],
      text_body: params["text_body"]
    )
  end

  def email(params) do
    new_email(
      to: params["to"],
      from: ConfigUtils.from_email(),
      subject: params["subject"],
      text_body: params["text_body"]
    )
  end
end
