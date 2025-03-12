defmodule QuizGenerator.EmailUtils do
  @moduledoc """
  Email utility functions, which can be used by any app
  depending on :data app.
  """
  use Bamboo.Template,
    view: Data.Email.AuthView

  alias QuizGenerator.Utils.ConfigUtils

  require Logger

  def send_email(params, action) do
    params
    |> email_with_layout(action)
    |> QuizGenerator.Mailer.deliver_now()
    |> case do
      {:ok, email} ->
        {:ok, email}

      {:error, %Bamboo.ApiError{message: message} = error} ->
        Logger.info("[send_template_mail], Bamboo error: #{message}")
        {:error, error}
    end
  end

  @doc """
    This method is used for send html email on tenant/institute approval
  """
  @spec send_institute_approval_email(String.t(), struct(), String.t(), String.t()) ::
          {:ok, Bamboo.Email.t()} | {:error, any()}
  def send_institute_approval_email(url, %{email: email} = user, tenant, password)
      when is_binary(email) do
    email_params = %{
      "to" => email,
      "subject" => "Registeration Completed",
      "name" => "#{user.first_name} #{user.last_name}",
      "email" => email,
      "phone" => user.phone,
      "username" => user.username,
      "password" => password,
      "sub_domain" => tenant,
      "link" => url
    }

    send_email(email_params, :registeration_complete)
  end

  def send_institute_approval_email(_url, _user, _tenant, _password), do: :ok

  @doc """
    This method is used to send email for email verification
  """
  @spec send_email_verification(map(), struct()) :: {:ok, Bamboo.Email.t()} | {:error, any()}
  def send_email_verification(
        %{"redirect_path" => _redirect_path, "to" => _to} = email_params,
        _user
      ) do
    email_params
    |> Map.put("subject", "Email Verify")
    |> send_email(:verify_email)
  end

  defp email_with_layout(params, :verify_email) do
    params
    |> email()
    |> put_html_layout({Data.Email.LayoutView, "verify_email_layout.html"})
    |> assign(%{redirect_path: params["redirect_path"], institute_name: params["institute_name"]})
    |> render("verify_email.html")
  end

  defp email_with_layout(params, :registeration_complete) do
    params
    |> email()
    |> put_html_layout({Data.Email.LayoutView, "registeration_complete_layout.html"})
    |> assign(%{
      name: params["name"],
      phone: params["phone"],
      username: params["username"],
      password: params["password"],
      sub_domain: params["sub_domain"],
      email: params["email"],
      link: params["link"]
    })
    |> render("registeration_complete.html")
  end

  @spec email(map()) :: Bamboo.Email.t()
  def email(%{"to" => _} = params) do
    new_email(
      to: params["to"],
      from: ConfigUtils.from_email(),
      subject: params["subject"],
      text_body: params["text_body"]
    )
  end
end
