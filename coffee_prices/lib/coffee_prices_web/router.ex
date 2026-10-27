defmodule CoffeePricesWeb.Router do
  use CoffeePricesWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug CoffeePricesWeb.Auth.Pipeline
  end

  scope "/api", CoffeePricesWeb do
    pipe_through :api
    get "/cafes", CafeController, :index
    get "/cafes/show/:id", CafeController, :show
    get "/cafes/:cafe_id/price_reports", PriceReportsController, :index
    get "/cafes/:cafe_id/price_reports/:id", PriceReportsController, :show
    get "/users/:user_id/price_reports", PriceReportsController, :index
    post "/auth/register", AuthController, :register
    post "/auth/login", AuthController, :login
  end

  scope "/api", CoffeePricesWeb do
    pipe_through [:api, :auth]
    post "/cafes/:cafe_id/price_reports/report", PriceReportsController, :create
    post "/cafes/:cafe_id/price_reports/:price_report_id/confirm", ConfirmationController, :create
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:coffee_prices, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: CoffeePricesWeb.Telemetry
    end
  end
end
