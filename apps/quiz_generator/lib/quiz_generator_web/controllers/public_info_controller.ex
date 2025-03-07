defmodule QuizGeneratorWeb.PublicInfoController do
  use QuizGeneratorWeb, :controller

  # @file_path "version_info.json"

  def load do
    # Get the path to the priv directory
    file_path = Path.join(Application.app_dir(:core, "priv"), "version_info.json")

    case File.read(file_path) do
      {:ok, content} -> Jason.decode!(content)
      {:error, _} ->
        IO.inspect("Error reading file")
        %{}
    end
  end

  def read_version_info(app) do
    file_path = Path.join(Application.app_dir(app, "priv"), "version_info.json")

    case File.read(file_path) do
      {:ok, content} -> Jason.decode!(content)
      {:error, error} ->
        {:error, error}
    end
  end

  def version_info(conn, _params) do
    # priv_path = to_string(:code.priv_dir(:core))
    # version_info = Version.read_version_info(priv_path)

    # render(conn, "version_info.json", version_info: version_info)
    # version_info = load()
    version_info = read_version_info(:core)
    IO.inspect("version_info:: #{inspect(version_info)}")
    json(conn, version_info)
  end
end
