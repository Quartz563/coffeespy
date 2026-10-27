defmodule CoffeePricesWeb.Auth.Guardian do
  use Guardian, otp_app: :coffee_prices

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(claims) do
    try do
      result = CoffeePrices.Accounts.get_user!(String.to_integer(claims["sub"]))
      {:ok, result}
    rescue
      Ecto.NoResultsError -> {:error, :not_found}
    end
  end
end
