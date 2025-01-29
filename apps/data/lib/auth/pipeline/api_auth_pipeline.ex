defmodule Data.Auth.Pipeline.ApiAuthAccessPipeline do
  @moduledoc """
  Pipeline for Authenticating Token, for requests
  from Api
  """
  use Guardian.Plug.Pipeline, otp_app: :data

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated

  # By default, the LoadResource plug will return an error if no resource can be found. You can override this behaviour
  # using the allow_blank: true option
  # plug Guardian.Plug.LoadResource, allow_blank: true
  plug Guardian.Plug.LoadResource
end
