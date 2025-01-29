defmodule Core.Utils.StripeUtils do
  @moduledoc """
    contain methods for stripe
  """

  alias Stripe.Connect.OAuth

  @doc """
    create stripe customer
  """
  @spec create_customer(map()) :: {:ok, map() | struct()} | {:error, any()}
  def create_customer(params) do
    Stripe.Customer.create(params)
  end

  @doc """
    create paymentmethod
  """
  @spec create_payment_method(map()) :: {:ok, map() | struct()} | {:error, any()}
  def create_payment_method(params) do
    Stripe.PaymentMethod.create(params)
  end

  @doc """
    create setupintent for recurring payments
  """
  @spec create_setup_intent(map()) :: {:ok, any()} | {:error, any()}
  def create_setup_intent(params) do
    Stripe.SetupIntent.create(params)
  end

  @doc """
    attach paymentmethod to customer
  """
  @spec attach_payment_method(map()) :: {:ok, any()} | {:error, any()}
  def attach_payment_method(params) do
    Stripe.PaymentMethod.attach(params)
  end

  @doc """
    detach paymentmethod from customer
  """
  @spec detach_payment_method(map()) :: {:ok, any()} | {:error, any()}
  def detach_payment_method(params) do
    Stripe.PaymentMethod.detach(params)
  end

  @doc """
    create paymentintent for customer
  """
  @spec create_payment_intent(map()) :: {:ok, any()} | {:error, any()}
  def create_payment_intent(params) do
    Stripe.PaymentIntent.create(params)
  end

  @doc """
    reterive paymentintent for customer
  """
  @spec reterive_payment_intent(String.t(), String.t()) :: {:ok, any()} | {:error, any()}
  def reterive_payment_intent(intent_id, account_id) do
    Stripe.PaymentIntent.retrieve(intent_id, %{}, connect_account: account_id)
  end

  @doc """
    authorize standard account
  """
  @spec authorize_standard_account(String.t()) :: {:ok, String.t()}
  def authorize_standard_account(redirect_uri) do
    {:ok,
     OAuth.authorize_url(%{
       redirect_uri: redirect_uri,
       client_id: Application.get_env(:stripity_stripe, :connect_client_id),
       scope: "read_write"
     })}
  end

  @doc """
    create standard account
  """
  @spec create_standard_account(String.t()) :: {:ok, any()} | {:error, any()}
  def create_standard_account(tenant_prefix) do
    Stripe.Account.create(%{
      type: "standard",
      metadata: %{tenant_prefix: tenant_prefix}
    })
  end

  @doc """
    create standard account link for onboarding process
  """
  @spec create_standard_account_link(map()) :: {:ok, any()}
  def create_standard_account_link(params) do
    Stripe.AccountLink.create(params)
  end

  @doc """
    deauthorize standard account
  """
  @spec deauthorize_standard_account(String.t()) :: {:ok, any()} | {:error, any()}
  def deauthorize_standard_account(account_id) do
    OAuth.deauthorize(account_id)
  end

  @doc """
    create oauth token
  """
  @spec create_oauth_token(map()) :: {:ok, any()} | {:error, any()}
  def create_oauth_token(%{"code" => code} = _params) do
    OAuth.token(code)
  end

  @doc """
    create checkout session
  """
  @spec checkout_session(map(), String.t()) :: {:ok, any()} | {:error, any()}
  def checkout_session(params, account_id) do
    Stripe.Session.create(params, connect_account: account_id)
  end

  @doc """
   get connected account
  """
  @spec retrive_account(keyword) :: {:error, Stripe.Error.t()} | {:ok, Stripe.Account.t()}
  def retrive_account(account_id) do
    Stripe.Account.retrieve(account_id)
  end

  @doc """
    convert to default_currency
  """
  @spec convert_to_default_currency(integer(), String.t()) :: integer()
  def convert_to_default_currency(amount, currency) do
    if String.upcase(currency) in get_zero_decimal_currencies() do
      amount
    else
      amount * 100
    end
  end

  defp get_zero_decimal_currencies do
    [
      "BIF",
      "CLP",
      "DJF",
      "GNF",
      "JPY",
      "KMF",
      "KRW",
      "MGA",
      "PYG",
      "RWF",
      "UGX",
      "VND",
      "VUV",
      "XAF",
      "XOF",
      "XPF"
    ]
  end
end
