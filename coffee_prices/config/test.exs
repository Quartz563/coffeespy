import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :coffee_prices, CoffeePrices.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "coffee_prices_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :coffee_prices, CoffeePricesWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "pngNqbmAGct7DNH8arC8tob/x3BEwSgRNXigArqJ5lh69Gg7YakZv3kqXB1NJtD+",
  server: false

# Test-only JWT signing key.
config :coffee_prices, CoffeePricesWeb.Auth.Guardian,
  secret_key: "cZuL_Hrt4YTAsmHG9N_BF8B7oNpNbMYpc-QB3-d5phUOh6dYGUZAslonMQcy0wIP"

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
