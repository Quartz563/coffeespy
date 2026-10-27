defmodule CoffeePrices.CafesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CoffeePrices.Cafes` context.
  """

  @doc """
  Generate a cafe.
  """
  def cafe_fixture(attrs \\ %{}) do
    {:ok, cafe} =
      attrs
      |> Enum.into(%{
        address: "some address",
        latitude: 120.5,
        longitude: 120.5,
        name: "some name"
      })
      |> CoffeePrices.Cafes.create_cafe()

    cafe
  end

  @doc """
  Generate a cafe_roaster.
  """
  def cafe_roaster_fixture(attrs \\ %{}) do
    {:ok, cafe_roaster} =
      attrs
      |> Enum.into(%{
        is_current: true
      })
      |> CoffeePrices.Cafes.create_cafe_roaster()

    cafe_roaster
  end

  @doc """
  Generate a roaster.
  """
  def roaster_fixture(attrs \\ %{}) do
    {:ok, roaster} =
      attrs
      |> Enum.into(%{
        location: "some location",
        name: "some name",
        website: "some website"
      })
      |> CoffeePrices.Cafes.create_roaster()

    roaster
  end
end
