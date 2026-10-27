defmodule CoffeePrices.PricingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CoffeePrices.Pricing` context.
  """

  @doc """
  Generate a price_reports.
  """
  def price_reports_fixture(attrs \\ %{}) do
    {:ok, price_reports} =
      attrs
      |> Enum.into(%{
        drink_type: "some drink_type",
        milk_type: "some milk_type",
        price: "120.5",
        size: "some size"
      })
      |> CoffeePrices.Pricing.create_price_reports()

    price_reports
  end

  @doc """
  Generate a confirmation.
  """
  def confirmation_fixture(attrs \\ %{}) do
    {:ok, confirmation} =
      attrs
      |> Enum.into(%{})
      |> CoffeePrices.Pricing.create_confirmation()

    confirmation
  end
end
