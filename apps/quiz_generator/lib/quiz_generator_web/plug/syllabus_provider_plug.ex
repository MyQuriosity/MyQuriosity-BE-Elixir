defmodule QuizGenerator.Plug.SyllabusProviderPlug do
  @moduledoc """
  A Plug to extract the `x-syllabus-provider-id` header from the request
  and merge it into the connection parameters.
  """

  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    syllabus_provider_id =
      List.first(get_req_header(conn, "x-syllabus-provider-id"))

    updated_params =
      case syllabus_provider_id do
        nil -> conn.params
        id -> Map.merge(conn.params, %{"syllabus_provider_id" => id})
      end

    %{conn | params: updated_params}
  end
end
