defmodule CoffeePrices.Cafes.Roaster do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roasters" do
    field :name, :string
    field :location, :string
    field :website, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(roaster, attrs) do
    roaster
    |> cast(attrs, [:name, :location, :website])
    |> validate_required([:name, :location, :website])
  end
end
