defmodule CoffeePrices.Pricing do
  @moduledoc """
  The Pricing context.
  """

  import Ecto.Query, warn: false
  alias CoffeePrices.Repo

  alias CoffeePrices.Pricing.PriceReports
  alias CoffeePrices.Pricing.Confirmation

  @doc """
  Returns the list of price_reports.

  ## Examples

      iex> list_price_reports()
      [%PriceReports{}, ...]

  """
  def list_price_reports do
    Repo.all(PriceReports)
  end

  def list_price_reports_using_cafe(cafe_id) do
    PriceReports
    |> where([p], p.cafe_id == ^cafe_id)
    |> preload(:cafe)
    |> preload(:user)
    |> Repo.all()
  end

  def list_price_reports_using_user(user_id) do
    PriceReports
    |> where([p], p.user_id == ^user_id)
    |> preload(:cafe)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Gets a single price_reports.

  Raises `Ecto.NoResultsError` if the Price reports does not exist.

  ## Examples

      iex> get_price_reports!(123)
      %PriceReports{}

      iex> get_price_reports!(456)
      ** (Ecto.NoResultsError)

  """
  def get_price_reports!(id), do: Repo.get!(PriceReports, id)

  @doc """
  Creates a price_reports.

  ## Examples

      iex> create_price_reports(%{field: value})
      {:ok, %PriceReports{}}

      iex> create_price_reports(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_price_reports(attrs) do
    result =
      %PriceReports{}
      |> PriceReports.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, price_report} ->
        {:ok, Repo.preload(price_report, :user)}

      error ->
        error
    end
  end

  @doc """
  Updates a price_reports.

  ## Examples

      iex> update_price_reports(price_reports, %{field: new_value})
      {:ok, %PriceReports{}}

      iex> update_price_reports(price_reports, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_price_reports(%PriceReports{} = price_reports, attrs) do
    price_reports
    |> PriceReports.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a price_reports.

  ## Examples

      iex> delete_price_reports(price_reports)
      {:ok, %PriceReports{}}

      iex> delete_price_reports(price_reports)
      {:error, %Ecto.Changeset{}}

  """
  def delete_price_reports(%PriceReports{} = price_reports) do
    Repo.delete(price_reports)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking price_reports changes.

  ## Examples

      iex> change_price_reports(price_reports)
      %Ecto.Changeset{data: %PriceReports{}}

  """
  def change_price_reports(%PriceReports{} = price_reports, attrs \\ %{}) do
    PriceReports.changeset(price_reports, attrs)
  end

  alias CoffeePrices.Pricing.Confirmation

  @doc """
  Returns the list of confirmations.

  ## Examples

      iex> list_confirmations()
      [%Confirmation{}, ...]

  """
  def list_confirmations do
    Repo.all(Confirmation)
  end

  @doc """
  Gets a single confirmation.

  Raises `Ecto.NoResultsError` if the Confirmation does not exist.

  ## Examples

      iex> get_confirmation!(123)
      %Confirmation{}

      iex> get_confirmation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_confirmation!(id), do: Repo.get!(Confirmation, id)

  @doc """
  Creates a confirmation.

  ## Examples

      iex> create_confirmation(%{field: value})
      {:ok, %Confirmation{}}

      iex> create_confirmation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_confirmation(attrs) do
    price_report_id = attrs["price_report_id"]
    user_id = attrs["user_id"]

    price_report_id_int =
      if is_binary(price_report_id),
        do: String.to_integer(price_report_id),
        else: price_report_id

    try do
      price_report = get_price_reports!(price_report_id_int)

      if price_report.user_id == user_id do
        {:error, :conflict}
      else
        %Confirmation{}
        |> Confirmation.changeset(attrs)
        |> Repo.insert()
      end
    rescue
      Ecto.NoResultsError -> {:error, :not_found}
    end
  end

  @doc """
  Updates a confirmation.

  ## Examples

      iex> update_confirmation(confirmation, %{field: new_value})
      {:ok, %Confirmation{}}

      iex> update_confirmation(confirmation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_confirmation(%Confirmation{} = confirmation, attrs) do
    confirmation
    |> Confirmation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a confirmation.

  ## Examples

      iex> delete_confirmation(confirmation)
      {:ok, %Confirmation{}}

      iex> delete_confirmation(confirmation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_confirmation(%Confirmation{} = confirmation) do
    Repo.delete(confirmation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking confirmation changes.

  ## Examples

      iex> change_confirmation(confirmation)
      %Ecto.Changeset{data: %Confirmation{}}

  """
  def change_confirmation(%Confirmation{} = confirmation, attrs \\ %{}) do
    Confirmation.changeset(confirmation, attrs)
  end
end
