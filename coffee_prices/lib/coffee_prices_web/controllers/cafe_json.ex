defmodule CoffeePricesWeb.CafeJSON do
  alias CoffeePrices.Cafes.Cafe

  @doc """
  Renders a list of cafes.
  """
  def index(%{cafes: cafes}) do
    %{data: for(cafe <- cafes, do: data(cafe))}
  end

  @doc """
  Renders a single cafe.
  """
  def show(%{cafe: cafe}) do
    %{data: data(cafe)}
  end

  defp data(%Cafe{} = cafe) do
    %{
      id: cafe.id,
      name: cafe.name,
      address: cafe.address,
      latitude: cafe.latitude,
      longitude: cafe.longitude
    }
  end
end
