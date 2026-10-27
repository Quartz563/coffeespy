defmodule CoffeePricesWeb.CafeControllerTest do
  use CoffeePricesWeb.ConnCase

  import CoffeePrices.CafesFixtures
  alias CoffeePrices.Cafes.Cafe

  @create_attrs %{
    name: "some name",
    address: "some address",
    latitude: 120.5,
    longitude: 120.5
  }
  @update_attrs %{
    name: "some updated name",
    address: "some updated address",
    latitude: 456.7,
    longitude: 456.7
  }
  @invalid_attrs %{name: nil, address: nil, latitude: nil, longitude: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all cafes", %{conn: conn} do
      conn = get(conn, ~p"/api/cafes")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create cafe" do
    test "renders cafe when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/cafes", cafe: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/cafes/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some address",
               "latitude" => 120.5,
               "longitude" => 120.5,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/cafes", cafe: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update cafe" do
    setup [:create_cafe]

    test "renders cafe when data is valid", %{conn: conn, cafe: %Cafe{id: id} = cafe} do
      conn = put(conn, ~p"/api/cafes/#{cafe}", cafe: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/cafes/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some updated address",
               "latitude" => 456.7,
               "longitude" => 456.7,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, cafe: cafe} do
      conn = put(conn, ~p"/api/cafes/#{cafe}", cafe: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete cafe" do
    setup [:create_cafe]

    test "deletes chosen cafe", %{conn: conn, cafe: cafe} do
      conn = delete(conn, ~p"/api/cafes/#{cafe}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/cafes/#{cafe}")
      end
    end
  end

  defp create_cafe(_) do
    cafe = cafe_fixture()

    %{cafe: cafe}
  end
end
