defmodule CoffeePricesWeb.PriceReportsJSON do
  alias CoffeePrices.Pricing.PriceReports

  @doc """
  Renders a list of price_reports.
  """
  def index(%{price_reports: price_reports}) do
    %{data: for(price_reports <- price_reports, do: data(price_reports))}
  end

  @doc """
  Renders a single price_reports.
  """
  def show(%{price_reports: price_reports}) do
    %{data: data(price_reports)}
  end

  defp data(%PriceReports{} = price_reports) do
    %{
      id: price_reports.id,
      drink_type: price_reports.drink_type,
      milk_type: price_reports.milk_type,
      size: price_reports.size,
      price: price_reports.price,
      user: %{
        id: price_reports.user.id,
        username: price_reports.user.username
      },
      cafe: %{
        id: price_reports.cafe.id,
        name: price_reports.cafe.name,
        address: price_reports.cafe.address,
        latitude: price_reports.cafe.latitude,
        longitude: price_reports.cafe.longitude
      }
    }
  end
end
