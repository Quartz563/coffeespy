defmodule CoffeePrices.Pricing.Confirmation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "confirmations" do
    belongs_to :price_report, CoffeePrices.Pricing.PriceReports
    belongs_to :user, CoffeePrices.Accounts.User
    timestamps(type: :utc_datetime)
  end

  def changeset(confirmation, attrs) do
    confirmation
    |> cast(attrs, [:price_report_id, :user_id])
    |> validate_required([:price_report_id, :user_id])
    |> unique_constraint(:user_id, name: :confirmations_user_id_price_report_id_index)
  end
end
