defmodule CoffeePrices.Repo.Migrations.CreateRoasters do
  use Ecto.Migration

  def change do
    create table(:roasters) do
      add :name, :string
      add :location, :string
      add :website, :string

      timestamps(type: :utc_datetime)
    end
  end
end
