defmodule CoffeePrices.Repo do
  use Ecto.Repo,
    otp_app: :coffee_prices,
    adapter: Ecto.Adapters.Postgres
end
