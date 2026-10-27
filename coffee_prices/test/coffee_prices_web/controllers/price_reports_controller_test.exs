defmodule CoffeePricesWeb.PriceReportsControllerTest do
  use CoffeePricesWeb.ConnCase

  import CoffeePrices.PricingFixtures
  alias CoffeePrices.Pricing.PriceReports

  @create_attrs %{
    size: "some size",
    drink_type: "some drink_type",
    milk_type: "some milk_type",
    price: "120.5"
  }
  @update_attrs %{
    size: "some updated size",
    drink_type: "some updated drink_type",
    milk_type: "some updated milk_type",
    price: "456.7"
  }
  @invalid_attrs %{size: nil, drink_type: nil, milk_type: nil, price: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all price_reports", %{conn: conn} do
      conn = get(conn, ~p"/api/price_reports")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create price_reports" do
    test "renders price_reports when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/price_reports", price_reports: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/price_reports/#{id}")

      assert %{
               "id" => ^id,
               "drink_type" => "some drink_type",
               "milk_type" => "some milk_type",
               "price" => "120.5",
               "size" => "some size"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/price_reports", price_reports: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update price_reports" do
    setup [:create_price_reports]

    test "renders price_reports when data is valid", %{
      conn: conn,
      price_reports: %PriceReports{id: id} = price_reports
    } do
      conn = put(conn, ~p"/api/price_reports/#{price_reports}", price_reports: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/price_reports/#{id}")

      assert %{
               "id" => ^id,
               "drink_type" => "some updated drink_type",
               "milk_type" => "some updated milk_type",
               "price" => "456.7",
               "size" => "some updated size"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, price_reports: price_reports} do
      conn = put(conn, ~p"/api/price_reports/#{price_reports}", price_reports: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete price_reports" do
    setup [:create_price_reports]

    test "deletes chosen price_reports", %{conn: conn, price_reports: price_reports} do
      conn = delete(conn, ~p"/api/price_reports/#{price_reports}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/price_reports/#{price_reports}")
      end
    end
  end

  defp create_price_reports(_) do
    price_reports = price_reports_fixture()

    %{price_reports: price_reports}
  end
end
