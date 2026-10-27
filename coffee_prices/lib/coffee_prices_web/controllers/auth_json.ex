defmodule CoffeePricesWeb.AuthJSON do
  def user_with_token(%{user: user, token: token}) do
    %{
      data: %{
        token: token,
        user: %{
          id: user.id,
          username: user.username,
          email: user.email
        }
      }
    }
  end
end
