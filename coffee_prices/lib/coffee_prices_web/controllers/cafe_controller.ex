defmodule CoffeePricesWeb.CafeController do
  use CoffeePricesWeb, :controller

  alias CoffeePrices.Cafes
  alias CoffeePrices.Cafes.Cafe

  action_fallback CoffeePricesWeb.FallbackController

  def index(conn, _params) do
    cafes = Cafes.list_cafes()
    render(conn, :index, cafes: cafes)
  end

  def create(conn, %{"cafe" => cafe_params}) do
    with {:ok, %Cafe{} = cafe} <- Cafes.create_cafe(cafe_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/cafes/#{cafe}")
      |> render(:show, cafe: cafe)
    end
  end

  def show(conn, %{"id" => id}) do
    cafe = Cafes.get_cafe!(id)
    render(conn, :show, cafe: cafe)
  end

  def update(conn, %{"id" => id, "cafe" => cafe_params}) do
    cafe = Cafes.get_cafe!(id)

    with {:ok, %Cafe{} = cafe} <- Cafes.update_cafe(cafe, cafe_params) do
      render(conn, :show, cafe: cafe)
    end
  end

  def delete(conn, %{"id" => id}) do
    cafe = Cafes.get_cafe!(id)

    with {:ok, %Cafe{}} <- Cafes.delete_cafe(cafe) do
      send_resp(conn, :no_content, "")
    end
  end
end
