defmodule QuizGeneratorWeb.PublicInfoController do
  use QuizGeneratorWeb, :controller
  alias FatUtils.Version

  def version_info(conn, _params) do
    priv_path = to_string(:code.priv_dir(:core))
    version_info = Version.read_version_info(priv_path)

    render(conn, "version_info.json", version_info: version_info)
  end
end
