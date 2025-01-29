defmodule QuizGeneratorWeb.SharedView do
  use QuizGeneratorWeb, :view

  def render("delete.json", _) do
    %{"message" => "Record Deleted"}
  end

  def render("disable.json", _) do
    %{"message" => "Record Disabled"}
  end

  def render("enable.json", _) do
    %{"message" => "Record Enabled"}
  end

  def render("deactivate.json", _) do
    %{"message" => "Record Deactivated"}
  end

  def render("soft_delete.json", _) do
    %{"message" => "Record has been soft deleted"}
  end

  def render("activate.json", _) do
    %{"message" => "Record Activated"}
  end

  def render("close.json", _) do
    %{"message" => "Record Closed"}
  end

  def render("reject.json", _) do
    %{"message" => "Request Rejected"}
  end

  def render("deauthorize.json", _) do
    %{"message" => "Account Deauthorized"}
  end

  def render("success.json", %{data: data}) do
    %{message: data.message}
  end
end
