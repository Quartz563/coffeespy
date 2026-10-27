defmodule CoffeePrices.Repo.Migrations.CreateConfirmationIndex do
  use Ecto.Migration

  def change do
    create unique_index(:confirmations, [:user_id, :price_report_id])
  end
end
