defmodule Web.Utils.DataMasking do
  @moduledoc """
    Provides utility functions for masking sensitive user data such as email addresses
  """

  @doc """
    This method is used to masking the email
  """
  def convert_email_hidden(nil), do: ""

  def convert_email_hidden(email) do
    {index, _len} = :binary.match(email, "@")
    str_end = String.slice(email, index..String.length(email))
    str_start = String.slice(email, 0..3)
    email = String.replace(email, str_end, "")
    email = String.replace(email, str_start, "")
    str = String.duplicate("*", String.length(email))
    str_start <> str <> str_end
  end
end
