defmodule CoffeePrices.Repo.Migrations.CreateCafeRoasters do
  use Ecto.Migration

  def change do
    create table(:cafe_roasters) do
      add :is_current, :boolean, default: false, null: false
      add :cafe_id, references(:cafes, on_delete: :nothing)
      add :roaster_id, references(:roasters, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:cafe_roasters, [:cafe_id])
    create index(:cafe_roasters, [:roaster_id])
  end
end
