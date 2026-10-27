defmodule CoffeePrices.Repo.Migrations.CreatePriceReports do
  use Ecto.Migration

  def change do
    create table(:price_reports) do
      add :drink_type, :string
      add :milk_type, :string
      add :size, :string
      add :price, :decimal
      add :cafe_id, references(:cafes, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:price_reports, [:cafe_id])
    create index(:price_reports, [:user_id])
  end
end
