defmodule CoffeePrices.Cafes.CafeRoaster do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cafe_roasters" do
    field :is_current, :boolean, default: false
    field :cafe_id, :id
    field :roaster_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cafe_roaster, attrs) do
    cafe_roaster
    |> cast(attrs, [:is_current])
    |> validate_required([:is_current])
  end
end
