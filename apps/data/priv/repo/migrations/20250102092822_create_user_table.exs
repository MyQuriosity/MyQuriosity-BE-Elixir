defmodule Data.Repo.Migrations.AddQuizGeneratorUserTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:first_name, :string, null: false)
      add(:last_name, :string, null: false)
      add(:email, :string, null: false)
      add(:email_verify_token, :string)
      add(:email_verified_at, :utc_datetime)
      add(:hashed_password, :string)
      add(:gender, :string)
      add(:deactivated_at, :utc_datetime)
      add(:institute_name, :string)
      add(:designation, :string)
      add(:teach_subject, :string)
      timestamps()
    end

    create_if_not_exists unique_index(:users, [:email],
                           name: :unique_email_per_user,
                           where: "deactivated_at IS NULL"
                         )
  end
end
