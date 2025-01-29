defmodule Campus.InstituteUtils do
  @moduledoc """
  # TODO: Write proper moduledoc
  """

  @spec generate_random_password :: String.t()
  def generate_random_password do
    "abcdefghijklmnopqrstuvwxyz123456789*&!"
    |> String.split("", trim: true)
    |> Enum.shuffle()
    |> Enum.take(8)
    |> Enum.join()
  end

  @spec send_mail(String.t(), map(), String.t(), String.t()) ::
          nil | {:error, String.t() | map()} | {:ok, Bamboo.Email.t()} | map()
  def send_mail(url, user, tenant, password) do
    try do
      if not is_nil(user.email) do
        %{
          "to" => user.email,
          "subject" => "Institute #{tenant} Super Admin Credentials",
          "text_body" => """
          Please login with these credentials in your new sub_domain
          sub_domain: #{tenant}
          Email:  #{user.email}
          password: #{password}
          link: #{url}/signin
          """
        }
        |> Data.Email.email()
        |> Data.Mailer.deliver_now()
      end
    rescue
      e in Bamboo.ApiError -> e
    end
  end

  @spec send_sms(String.t(), map(), String.t(), String.t()) :: nil
  def send_sms(url, user, tenant, password) do
    if not is_nil(user.phone) and Application.get_env(:api, :env)[:e2e_enabled] == "false" do
      sms_params = %{
        "to" => user.phone,
        "text" => """
        Institute #{tenant} Super Admin Credentials:
        Please login with these credentials in your new sub_domain
        sub_domain: #{tenant}
        Phone:  #{user.phone}
        password: #{password}
        link: #{url}/signin
        """
      }

      Core.SMS.send_local_sms(sms_params)
    end
  end

  @spec send_institute_mail(String.t(), String.t(), map()) ::
          {:error, String.t() | map()} | {:ok, Bamboo.Email.t()} | map()
  def send_institute_mail(to_email, template, params) do
    email_subject_body = generate_email_subject_body(template, params)

    try do
      %{
        "to" => to_email,
        "subject" => email_subject_body.subject,
        "text_body" => email_subject_body.text_body
      }
      |> Data.Email.email()
      |> Data.Mailer.deliver_now()
    rescue
      e in [Bamboo.ApiError] -> e
    end
  end

  @spec generate_email_subject_body(String.t(), map()) :: %{
          subject: String.t(),
          text_body: String.t()
        }
  def generate_email_subject_body(template, params) do
    case template do
      "institutes" ->
        %{
          subject: "Institute #{params.tenant} Super Admin Credentials",
          text_body: """
          Please login with these credentials in your new sub_domain
          sub_domain: #{params.tenant}
          Email:  #{params.email}
          password: #{params.password}
          link: #{params.url}/signin
          """
        }

      "institute_user_creation" ->
        %{
          subject: "Institute #{params.tenant} User Credentials",
          text_body: """
          Please login with these credentials in your Institute sub_domain
          sub_domain: #{params.tenant}
          Email:  #{params.email}
          password: #{params.password}
          link: #{params.url}/signin
          """
        }

      _ ->
        %{
          subject: "No Subject",
          text_body: "No Body"
        }
    end
  end
end
