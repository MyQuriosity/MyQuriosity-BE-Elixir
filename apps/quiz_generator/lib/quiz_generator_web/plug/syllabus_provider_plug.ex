defmodule QuizGenerator.Plug.SyllabusProviderPlug do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    IO.inspect(conn, label: "conn----")

    syllabus_provider_id =
      List.first(get_req_header(conn, "x-syllabus-provider-id"))

    updated_params =
      case syllabus_provider_id do
        nil -> conn.params
        id -> Map.put(conn.params, "syllabus_provider_id", id)
      end

    %{conn | params: updated_params}
  end
end
