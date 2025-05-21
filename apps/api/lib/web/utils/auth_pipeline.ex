defmodule Api.AuthAccessPipeline do
  @moduledoc """
   This module defines an authentication pipeline for the Web application using Guardian.
  """
  use Guardian.Plug.Pipeline, otp_app: :api

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # plug Guardian.Plug.VerifyCookie, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated

  # By default, the LoadResource plug will return an error if no resource can be found. You can override this behaviour
  # using the allow_blank: true option
  # plug Guardian.Plug.LoadResource, allow_blank: true
  plug Guardian.Plug.LoadResource
end
