defmodule CoffeePrices.Pricing.PriceReports do
  use Ecto.Schema
  import Ecto.Changeset

  @drink_types [:flat_white, :long_black, :latte, :cappuccino]
  @milk_types [:whole, :skim, :oat, :almond, :none]
  @sizes [:small, :medium, :large]

  schema "price_reports" do
    field :drink_type, Ecto.Enum, values: @drink_types
    field :milk_type, Ecto.Enum, values: @milk_types
    field :size, Ecto.Enum, values: @sizes
    field :price, :decimal

    belongs_to :cafe, CoffeePrices.Cafes.Cafe
    belongs_to :user, CoffeePrices.Accounts.User

    has_many :confirmations, CoffeePrices.Pricing.Confirmation

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(price_reports, attrs) do
    price_reports
    |> cast(attrs, [:drink_type, :milk_type, :size, :price, :cafe_id, :user_id])
    |> validate_required([:drink_type, :milk_type, :size, :price, :cafe_id, :user_id])
    |> validate_inclusion(:drink_type, @drink_types)
    |> validate_inclusion(:milk_type, @milk_types)
    |> validate_inclusion(:size, @sizes)
  end
end
