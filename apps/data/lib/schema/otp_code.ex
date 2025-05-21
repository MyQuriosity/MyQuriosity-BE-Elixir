defmodule Data.OtpCode do
  @moduledoc """
  This module is used as schema for otp codes
  """
  use Data.Web, :model
  use Core.Macros.PK

  @type t :: %__MODULE__{}
  schema "otp_codes" do
    field(:otp, :binary)
    field(:reason, :string)
    field(:deactivated_at, :utc_datetime)
    belongs_to(:user, Data.User, foreign_key: :user_id, references: :id)

    timestamps()
  end

  @spec changeset(otp_code | changeset, params) :: changeset
        when otp_code: t(),
             changeset: Ecto.Changeset.t(),
             params: map()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :otp,
      :user_id,
      :reason
    ])
    |> validate_required([:otp, :user_id, :reason])
    |> unique_constraint(:otp,
      name: :otp_codes_otp_index,
      message: "OTP Already exist"
    )
    |> validate_inclusion(:reason, ["registration", "password_reset"])
    |> foreign_key_constraint(:user_id)
  end
end
