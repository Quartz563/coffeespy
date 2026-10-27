defmodule CoffeePrices.Repo.Migrations.CreateConfirmations do
  use Ecto.Migration

  def change do
    create table(:confirmations) do
      add :price_report_id, references(:price_reports, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:confirmations, [:price_report_id])
    create index(:confirmations, [:user_id])
  end
end
