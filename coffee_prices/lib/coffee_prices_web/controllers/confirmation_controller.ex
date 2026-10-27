defmodule CoffeePricesWeb.ConfirmationController do
  use CoffeePricesWeb, :controller

  alias CoffeePrices.Pricing
  alias CoffeePrices.Pricing.Confirmation

  action_fallback CoffeePricesWeb.FallbackController

  def create(conn, %{"price_report_id" => price_report_id}) do
    current_user = Guardian.Plug.current_resource(conn)

    attrs = %{
      "price_report_id" => price_report_id,
      "user_id" => current_user.id
    }

    with {:ok, %Confirmation{} = confirmation} <- Pricing.create_confirmation(attrs) do
      conn
      |> put_status(:created)
      |> render(:show, confirmation: confirmation)
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
