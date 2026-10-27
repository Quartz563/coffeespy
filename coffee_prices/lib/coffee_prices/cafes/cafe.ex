defmodule CoffeePrices.Cafes.Cafe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cafes" do
    field :name, :string
    field :address, :string
    field :latitude, :float
    field :longitude, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cafe, attrs) do
    cafe
    |> cast(attrs, [:name, :address, :latitude, :longitude])
    |> validate_required([:name, :address, :latitude, :longitude])
  end
end
