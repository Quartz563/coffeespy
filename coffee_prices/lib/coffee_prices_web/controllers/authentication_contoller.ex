defmodule CoffeePricesWeb.AuthController do
  use CoffeePricesWeb, :controller

  alias CoffeePrices.Accounts
  alias CoffeePricesWeb.Auth.Guardian, as: AuthGuardian

  action_fallback CoffeePricesWeb.FallbackController

  def register(
        conn,
        %{
          "username" => username,
          "email" => email,
          "password" => password,
          "password_confirmation" => password_confirmation
        } = params
      ) do
    with {:ok, user} <- Accounts.register_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      render(conn, :user_with_token, user: user, token: token)
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def login(conn, %{"username" => username, "password" => password} = params) do
    with {:ok, user} <- Accounts.authenticate_user(username, password),
         {:ok, token, _claims} <- AuthGuardian.encode_and_sign(user) do
      render(conn, :user_with_token, user: user, token: token)
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
