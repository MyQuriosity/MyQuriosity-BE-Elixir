defmodule Core.FormatterTest do
  use ExUnit.Case
  alias Formatter.Log

  test "Log format when message is string" do
    level = :info
    message = "Running ApiWeb.Endpoint with cowboy 2.9.0 at 0.0.0.0:4000 (http)"
    timestamp = {{2022, 6, 20}, {11, 33, 3, 543}}

    metadata = [
      pid: 123_245,
      file: "lib/phoenix/endpoint/cowboy2_adapter.ex",
      line: 96,
      function: "start_link/3",
      module: Phoenix.Endpoint.Cowboy2Adapter,
      application: :phoenix
    ]

    assert Log.format(level, message, timestamp, metadata) ==
             "{\"function\":\"start_link/3\",\"line\":96,\"message\":\"Running ApiWeb.Endpoint with cowboy 2.9.0 at 0.0.0.0:4000 (http)\",\"module\":\"Elixir.Phoenix.Endpoint.Cowboy2Adapter\",\"timestamp\":\"2022-06-20T11:33:03.543Z\",\"file\":\"lib/phoenix/endpoint/cowboy2_adapter.ex\",\"level\":\"info\",\"application\":\"phoenix\"}\n"
  end

  test "Log format when message is number" do
    level = :info
    message = 12_345_678
    timestamp = {{2022, 6, 20}, {11, 33, 3, 543}}

    metadata = [
      pid: 123_245,
      file: "lib/phoenix/endpoint/cowboy2_adapter.ex",
      line: 96,
      function: "start_link/3",
      module: Phoenix.Endpoint.Cowboy2Adapter,
      application: :phoenix
    ]

    assert Log.format(level, message, timestamp, metadata) ==
             "{\"function\":\"start_link/3\",\"line\":96,\"message\":12345678,\"module\":\"Elixir.Phoenix.Endpoint.Cowboy2Adapter\",\"timestamp\":\"2022-06-20T11:33:03.543Z\",\"file\":\"lib/phoenix/endpoint/cowboy2_adapter.ex\",\"level\":\"info\",\"application\":\"phoenix\"}\n"
  end

  test "Log format when message is float" do
    level = :info
    message = 234_234.234
    timestamp = {{2022, 6, 20}, {11, 33, 3, 543}}

    metadata = [
      pid: 123_245,
      file: "lib/phoenix/endpoint/cowboy2_adapter.ex",
      line: 96,
      function: "start_link/3",
      module: Phoenix.Endpoint.Cowboy2Adapter,
      application: :phoenix
    ]

    assert Log.format(level, message, timestamp, metadata) ==
             "{\"function\":\"start_link/3\",\"line\":96,\"message\":234234.234,\"module\":\"Elixir.Phoenix.Endpoint.Cowboy2Adapter\",\"timestamp\":\"2022-06-20T11:33:03.543Z\",\"file\":\"lib/phoenix/endpoint/cowboy2_adapter.ex\",\"level\":\"info\",\"application\":\"phoenix\"}\n"
  end

  test "Log format when message is struct" do
    level = :info
    message = "%Data.TeamUser{email: asdasdasd}"
    timestamp = {{2022, 6, 20}, {11, 33, 3, 543}}

    metadata = [
      pid: 123_245,
      file: "lib/phoenix/endpoint/cowboy2_adapter.ex",
      line: 96,
      function: "start_link/3",
      module: Phoenix.Endpoint.Cowboy2Adapter,
      application: :phoenix
    ]

    assert Log.format(level, message, timestamp, metadata) ==
             "{\"function\":\"start_link/3\",\"line\":96,\"message\":\"%Data.TeamUser{email: asdasdasd}\",\"module\":\"Elixir.Phoenix.Endpoint.Cowboy2Adapter\",\"timestamp\":\"2022-06-20T11:33:03.543Z\",\"file\":\"lib/phoenix/endpoint/cowboy2_adapter.ex\",\"level\":\"info\",\"application\":\"phoenix\"}\n"
  end

  test "Log format when message is list" do
    level = :info

    message = [
      "Processing with ",
      "TenantApiWeb.CampusController",
      [46, "index", 47, 50],
      10,
      "  Parameters: ",
      "%{}",
      10,
      "  Pipelines: ",
      "[:tenant_api, :token_auth, :prefix, :institute_privelage, :roles_123456789]"
    ]

    timestamp = {{2022, 6, 20}, {11, 33, 3, 543}}

    metadata = [
      pid: 123_245,
      file: "lib/phoenix/endpoint/cowboy2_adapter.ex",
      line: 96,
      function: "start_link/3",
      module: Phoenix.Endpoint.Cowboy2Adapter,
      application: :phoenix
    ]

    assert Log.format(level, message, timestamp, metadata) ==
             "{\"function\":\"start_link/3\",\"line\":96,\"message\":{\"msg\":[\"Processing with \",\"TenantApiWeb.CampusController\",[46,\"index\",47,50],10,\"  Parameters: \",\"%{}\",10,\"  Pipelines: \",\"[:tenant_api, :token_auth, :prefix, :institute_privelage, :roles_123456789]\"]},\"module\":\"Elixir.Phoenix.Endpoint.Cowboy2Adapter\",\"timestamp\":\"2022-06-20T11:33:03.543Z\",\"file\":\"lib/phoenix/endpoint/cowboy2_adapter.ex\",\"level\":\"info\",\"application\":\"phoenix\"}\n"
  end
end
