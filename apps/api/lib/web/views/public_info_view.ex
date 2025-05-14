defmodule Api.PublicInfoView do
  use MyQuriosityWeb, :view

  def render("version_info.json", %{version_info: version_info}), do: version_info
end
