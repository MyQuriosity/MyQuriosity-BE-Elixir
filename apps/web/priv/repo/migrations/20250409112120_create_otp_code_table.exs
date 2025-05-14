defmodule Web.Repo.Migrations.CreateOtpCodeTable do
  use Ecto.Migration

  def change do
    create table(:otp_codes, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:otp, :binary, null: false)
      add(:reason, :string, null: false)
      add(:deactivated_at, :utc_datetime)

      add(:user_id, references(:users, column: :id, type: :uuid))

      timestamps()
    end

    create(
      unique_index(:otp_codes, [:otp],
        name: :otp_codes_otp_index,
        where: "deactivated_at IS NULL"
      )
    )
  end
end
