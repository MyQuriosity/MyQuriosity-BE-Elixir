# lib/version_utils.ex
defmodule VersionUtils do
  # def put_version(app_version) do
  #   # release_info = %{
  #   #   release_version: System.get_env("RELEASE_VERSION") || "unknown",
  #   #   commit_hash: System.cmd("git", ["rev-parse", "HEAD"]) |> elem(0) |> String.trim(),
  #   #   commit_message: System.cmd("git", ["log", "-1", "--pretty=%B"]) |> elem(0) |> String.trim(),
  #   #   commit_author: System.cmd("git", ["log", "-1", "--pretty=%an"]) |> elem(0) |> String.trim(),
  #   #   commit_date: System.cmd("git", ["log", "-1", "--pretty=%cd"]) |> elem(0) |> String.trim(),
  #   #   commit_branch: System.cmd("git", ["rev-parse", "--abbrev-ref", "HEAD"]) |> elem(0) |> String.trim(),
  #   #   app_version: System.get_env("RELEASE_VERSION") || "unknown"
  #   # }

  #   info = FatEcto.Utils.Version.get_version_info()
  #   IO.inspect("info:: #{inspect(info)}")
  #   info = Map.put(info, :app_version, app_version)

  #   put_version_info(:core, info)
  # end


  @spec read_version_info(String.t()) :: any()
  def read_version_info(app) do
    file_path = Path.join(Application.app_dir(app, "priv"), "version_info.json")

    case File.read(file_path) do
      {:ok, content} -> Jason.decode!(content)
      {:error, error} ->
        {:error, error}
    end
  end

  # @spec put_version_info(String.t(), map()) :: any()
  # def put_version_info(app, version_info) do
  #   # Get the app's priv directory
  #   priv_dir = Application.app_dir(app, "priv")

  #   # Ensure the priv directory exists
  #   File.mkdir_p!(priv_dir)

  #   # Write the release info to the file
  #   File.write!(Path.join(priv_dir, "version_info.json"), Jason.encode!(version_info))
  # end
end
