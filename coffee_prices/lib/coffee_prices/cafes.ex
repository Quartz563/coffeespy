defmodule CoffeePrices.Cafes do
  @moduledoc """
  The Cafes context.
  """

  import Ecto.Query, warn: false
  alias CoffeePrices.Repo

  alias CoffeePrices.Cafes.Cafe

  @doc """
  Returns the list of cafes.

  ## Examples

      iex> list_cafes()
      [%Cafe{}, ...]

  """
  def list_cafes do
    Repo.all(Cafe)
  end

  @doc """
  Gets a single cafe.

  Raises `Ecto.NoResultsError` if the Cafe does not exist.

  ## Examples

      iex> get_cafe!(123)
      %Cafe{}

      iex> get_cafe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cafe!(id), do: Repo.get!(Cafe, id)

  @doc """
  Creates a cafe.

  ## Examples

      iex> create_cafe(%{field: value})
      {:ok, %Cafe{}}

      iex> create_cafe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cafe(attrs) do
    %Cafe{}
    |> Cafe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cafe.

  ## Examples

      iex> update_cafe(cafe, %{field: new_value})
      {:ok, %Cafe{}}

      iex> update_cafe(cafe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cafe(%Cafe{} = cafe, attrs) do
    cafe
    |> Cafe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cafe.

  ## Examples

      iex> delete_cafe(cafe)
      {:ok, %Cafe{}}

      iex> delete_cafe(cafe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cafe(%Cafe{} = cafe) do
    Repo.delete(cafe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cafe changes.

  ## Examples

      iex> change_cafe(cafe)
      %Ecto.Changeset{data: %Cafe{}}

  """
  def change_cafe(%Cafe{} = cafe, attrs \\ %{}) do
    Cafe.changeset(cafe, attrs)
  end

  alias CoffeePrices.Cafes.CafeRoaster

  @doc """
  Returns the list of cafe_roaster.

  ## Examples

      iex> list_cafe_roaster()
      [%CafeRoaster{}, ...]

  """
  def list_cafe_roaster do
    Repo.all(CafeRoaster)
  end

  @doc """
  Gets a single cafe_roaster.

  Raises `Ecto.NoResultsError` if the Cafe roaster does not exist.

  ## Examples

      iex> get_cafe_roaster!(123)
      %CafeRoaster{}

      iex> get_cafe_roaster!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cafe_roaster!(id), do: Repo.get!(CafeRoaster, id)

  @doc """
  Creates a cafe_roaster.

  ## Examples

      iex> create_cafe_roaster(%{field: value})
      {:ok, %CafeRoaster{}}

      iex> create_cafe_roaster(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cafe_roaster(attrs) do
    %CafeRoaster{}
    |> CafeRoaster.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cafe_roaster.

  ## Examples

      iex> update_cafe_roaster(cafe_roaster, %{field: new_value})
      {:ok, %CafeRoaster{}}

      iex> update_cafe_roaster(cafe_roaster, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cafe_roaster(%CafeRoaster{} = cafe_roaster, attrs) do
    cafe_roaster
    |> CafeRoaster.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cafe_roaster.

  ## Examples

      iex> delete_cafe_roaster(cafe_roaster)
      {:ok, %CafeRoaster{}}

      iex> delete_cafe_roaster(cafe_roaster)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cafe_roaster(%CafeRoaster{} = cafe_roaster) do
    Repo.delete(cafe_roaster)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cafe_roaster changes.

  ## Examples

      iex> change_cafe_roaster(cafe_roaster)
      %Ecto.Changeset{data: %CafeRoaster{}}

  """
  def change_cafe_roaster(%CafeRoaster{} = cafe_roaster, attrs \\ %{}) do
    CafeRoaster.changeset(cafe_roaster, attrs)
  end

  alias CoffeePrices.Cafes.Roaster

  @doc """
  Returns the list of roasters.

  ## Examples

      iex> list_roasters()
      [%Roaster{}, ...]

  """
  def list_roasters do
    Repo.all(Roaster)
  end

  @doc """
  Gets a single roaster.

  Raises `Ecto.NoResultsError` if the Roaster does not exist.

  ## Examples

      iex> get_roaster!(123)
      %Roaster{}

      iex> get_roaster!(456)
      ** (Ecto.NoResultsError)

  """
  def get_roaster!(id), do: Repo.get!(Roaster, id)

  @doc """
  Creates a roaster.

  ## Examples

      iex> create_roaster(%{field: value})
      {:ok, %Roaster{}}

      iex> create_roaster(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_roaster(attrs) do
    %Roaster{}
    |> Roaster.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a roaster.

  ## Examples

      iex> update_roaster(roaster, %{field: new_value})
      {:ok, %Roaster{}}

      iex> update_roaster(roaster, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_roaster(%Roaster{} = roaster, attrs) do
    roaster
    |> Roaster.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a roaster.

  ## Examples

      iex> delete_roaster(roaster)
      {:ok, %Roaster{}}

      iex> delete_roaster(roaster)
      {:error, %Ecto.Changeset{}}

  """
  def delete_roaster(%Roaster{} = roaster) do
    Repo.delete(roaster)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking roaster changes.

  ## Examples

      iex> change_roaster(roaster)
      %Ecto.Changeset{data: %Roaster{}}

  """
  def change_roaster(%Roaster{} = roaster, attrs \\ %{}) do
    Roaster.changeset(roaster, attrs)
  end
end
