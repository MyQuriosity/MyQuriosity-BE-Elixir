defmodule Api.Guardian do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  use Guardian, otp_app: :api

  @spec subject_for_token(map(), map()) :: {:ok, String.t()}
  def subject_for_token(resource, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    sub = to_string(resource.id)
    {:ok, sub}
  end

  # def subject_for_token(_, _) do
  #   {:error, :reason_for_error}
  # end

  @spec resource_from_claims(map()) :: {:error, :not_found} | {:ok, Data.User.t()}
  def resource_from_claims(claims) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    id = claims["sub"]

    case Data.Repo.get(Data.User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end

    # resource = MyApp.get_resource_by_id(id)
    # {:ok, Data.Repo.get(Data.InstituteUser, id)}
  end

  # def resource_from_claims(_claims) do
  #   {:error, :reason_for_error}
  # end
end
