defmodule QuizGeneratorWeb.PublicInfoController do
  use QuizGeneratorWeb, :controller

  def read_version_info(app) do
    file_path = Path.join(Application.app_dir(app, "priv"), "version_info.json")

    case File.read(file_path) do
      {:ok, content} -> Jason.decode!(content)
      {:error, error} ->
        {:error, error}
    end
  end

  def version_info(conn, _params) do
    version_info = read_version_info(:core)
    json(conn, version_info)
  end
end
