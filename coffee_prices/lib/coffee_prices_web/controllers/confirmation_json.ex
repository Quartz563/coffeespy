defmodule CoffeePricesWeb.ConfirmationJSON do
  def show(%{confirmation: confirmation}) do
    %{
      data: %{
        id: confirmation.id,
        price_report_id: confirmation.price_report_id,
        user_id: confirmation.user_id
      }
    }
  end
end
