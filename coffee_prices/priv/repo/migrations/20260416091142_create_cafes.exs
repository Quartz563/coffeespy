defmodule CoffeePrices.Repo.Migrations.CreateCafes do
  use Ecto.Migration

  def change do
    create table(:cafes) do
      add :name, :string
      add :address, :string
      add :latitude, :float
      add :longitude, :float

      timestamps(type: :utc_datetime)
    end
  end
end
