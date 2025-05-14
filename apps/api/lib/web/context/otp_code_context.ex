defmodule Api.OtpCodeContext do
  @moduledoc """
  This module is used as context for otp code core functionalities
  """
  import Ecto.Query
  alias Api.OtpUtils
  alias Data.OtpCode
  alias Data.Repo
  alias Data.User

  @hash_algorithm :sha256
  @token_validity_in_days 1

  @doc """
   This function generate unique otp for the given user and reason and save to database
   returns tuple containing otp string and the created otp entity.
  """
  @spec create_unique_otp(String.t(), String.t()) ::
          {:ok, {String.t(), OtpCode.t()}} | {:error, Ecto.Changeset.t()}
  def create_unique_otp(user_id, reason) do
    otp = OtpUtils.generate_otp()
    hashed_otp = :crypto.hash(@hash_algorithm, otp)

    if otp_code_exist?(hashed_otp, reason) do
      create_unique_otp(user_id, reason)
    else
      do_create_otp_code(otp, %{
        otp: hashed_otp,
        reason: reason,
        user_id: user_id
      })
    end
  end

  @doc """
   This function is used to verify the otp
  """
  @spec verify_otp(String.t(), String.t(), String.t()) :: {:error, :not_found} | {:ok, struct}
  def verify_otp(otp, user_identifier, reason) do
    hashed_otp = :crypto.hash(@hash_algorithm, "#{otp}")

    OtpCode
    |> join(:inner, [otp_code], iu in InstituteUser, as: :user, on: iu.id == otp_code.user_id)
    |> where([otp_code], otp_code.otp == ^hashed_otp and otp_code.reason == ^reason)
    |> where([otp_code], otp_code.inserted_at > ago(^@token_validity_in_days, "day"))
    |> where([user: user], user.email == ^user_identifier or user.phone == ^user_identifier)
    |> preload(:user)
    |> Repo.one()
  end

  @spec deactivate_user_otps(User.t(), String.t()) :: {non_neg_integer(), nil | [term()]}
  def deactivate_user_otps(%User{id: user_id} = _user, reason) do
    OtpCode
    |> where([oc], oc.user_id == ^user_id and oc.reason == ^reason)
    |> Repo.update_all(set: [deactivated_at: DateTime.utc_now()])
  end

  defp otp_code_exist?(hashed_otp, reason) do
    OtpCode
    |> where([otp_code], otp_code.otp == ^hashed_otp and otp_code.reason == ^reason)
    |> Repo.one()
    |> case do
      nil -> false
      _ -> true
    end
  end

  defp do_create_otp_code(otp, params) do
    %OtpCode{}
    |> OtpCode.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, otp_code} -> {:ok, {otp, otp_code}}
      error -> error
    end
  end
end
