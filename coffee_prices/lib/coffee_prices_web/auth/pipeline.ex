defmodule CoffeePricesWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :coffee_prices,
    module: CoffeePricesWeb.Auth.Guardian,
    error_handler: CoffeePricesWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
