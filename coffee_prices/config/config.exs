# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :coffee_prices,
  ecto_repos: [CoffeePrices.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :coffee_prices, CoffeePricesWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: CoffeePricesWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: CoffeePrices.PubSub,
  live_view: [signing_salt: "vThKRxl8"]

# The signing key is set per environment: dev.exs and test.exs hold
# local-only keys; production reads GUARDIAN_SECRET_KEY in runtime.exs.
config :coffee_prices, CoffeePricesWeb.Auth.Guardian,
  issuer: "coffee_prices"

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
