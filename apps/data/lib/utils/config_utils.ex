defmodule Data.Utils.ConfigUtils do
  @moduledoc """
    Provides utility functions for email.
  """

  @doc """
    This method is used to default email set in config
  """
  @spec from_email() :: String.t() | nil
  def from_email do
    Application.get_env(:data, Data.Mailer)[:from_email]
  end
end
