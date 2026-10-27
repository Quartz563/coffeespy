defmodule CoffeePricesWeb.PriceReportsController do
  use CoffeePricesWeb, :controller

  alias CoffeePrices.Pricing
  alias CoffeePrices.Pricing.PriceReports

  action_fallback CoffeePricesWeb.FallbackController

  def index(conn, %{"cafe_id" => cafe_id}) do
    price_reports = Pricing.list_price_reports_using_cafe(cafe_id)
    render(conn, :index, price_reports: price_reports)
  end

  def index(conn, %{"user_id" => user_id}) do
    price_reports = Pricing.list_price_reports_using_user(user_id)
    render(conn, :index, price_reports: price_reports)
  end

  def create(conn, %{"cafe_id" => cafe_id} = params) do
    current_user = Guardian.Plug.current_resource(conn)

    attrs =
      params
      |> Map.put("user_id", current_user.id)

    with {:ok, %PriceReports{} = price_report} <- Pricing.create_price_reports(attrs) do
      conn
      |> put_status(:created)
      |> render(:show, price_reports: price_report)
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def show(conn, %{"id" => id}) do
    price_reports = Pricing.get_price_reports!(id)
    render(conn, :show, price_reports: price_reports)
  end

  def update(conn, %{"id" => id, "price_reports" => price_reports_params}) do
    price_reports = Pricing.get_price_reports!(id)

    with {:ok, %PriceReports{} = price_reports} <-
           Pricing.update_price_reports(price_reports, price_reports_params) do
      render(conn, :show, price_reports: price_reports)
    end
  end

  def delete(conn, %{"id" => id}) do
    price_reports = Pricing.get_price_reports!(id)

    with {:ok, %PriceReports{}} <- Pricing.delete_price_reports(price_reports) do
      send_resp(conn, :no_content, "")
    end
  end
end
