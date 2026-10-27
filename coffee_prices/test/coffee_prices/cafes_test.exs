defmodule CoffeePrices.CafesTest do
  use CoffeePrices.DataCase

  alias CoffeePrices.Cafes

  describe "cafes" do
    alias CoffeePrices.Cafes.Cafe

    import CoffeePrices.CafesFixtures

    @invalid_attrs %{name: nil, address: nil, latitude: nil, longitude: nil}

    test "list_cafes/0 returns all cafes" do
      cafe = cafe_fixture()
      assert Cafes.list_cafes() == [cafe]
    end

    test "get_cafe!/1 returns the cafe with given id" do
      cafe = cafe_fixture()
      assert Cafes.get_cafe!(cafe.id) == cafe
    end

    test "create_cafe/1 with valid data creates a cafe" do
      valid_attrs = %{
        name: "some name",
        address: "some address",
        latitude: 120.5,
        longitude: 120.5
      }

      assert {:ok, %Cafe{} = cafe} = Cafes.create_cafe(valid_attrs)
      assert cafe.name == "some name"
      assert cafe.address == "some address"
      assert cafe.latitude == 120.5
      assert cafe.longitude == 120.5
    end

    test "create_cafe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cafes.create_cafe(@invalid_attrs)
    end

    test "update_cafe/2 with valid data updates the cafe" do
      cafe = cafe_fixture()

      update_attrs = %{
        name: "some updated name",
        address: "some updated address",
        latitude: 456.7,
        longitude: 456.7
      }

      assert {:ok, %Cafe{} = cafe} = Cafes.update_cafe(cafe, update_attrs)
      assert cafe.name == "some updated name"
      assert cafe.address == "some updated address"
      assert cafe.latitude == 456.7
      assert cafe.longitude == 456.7
    end

    test "update_cafe/2 with invalid data returns error changeset" do
      cafe = cafe_fixture()
      assert {:error, %Ecto.Changeset{}} = Cafes.update_cafe(cafe, @invalid_attrs)
      assert cafe == Cafes.get_cafe!(cafe.id)
    end

    test "delete_cafe/1 deletes the cafe" do
      cafe = cafe_fixture()
      assert {:ok, %Cafe{}} = Cafes.delete_cafe(cafe)
      assert_raise Ecto.NoResultsError, fn -> Cafes.get_cafe!(cafe.id) end
    end

    test "change_cafe/1 returns a cafe changeset" do
      cafe = cafe_fixture()
      assert %Ecto.Changeset{} = Cafes.change_cafe(cafe)
    end
  end

  describe "cafe_roaster" do
    alias CoffeePrices.Cafes.CafeRoaster

    import CoffeePrices.CafesFixtures

    @invalid_attrs %{is_current: nil}

    test "list_cafe_roaster/0 returns all cafe_roaster" do
      cafe_roaster = cafe_roaster_fixture()
      assert Cafes.list_cafe_roaster() == [cafe_roaster]
    end

    test "get_cafe_roaster!/1 returns the cafe_roaster with given id" do
      cafe_roaster = cafe_roaster_fixture()
      assert Cafes.get_cafe_roaster!(cafe_roaster.id) == cafe_roaster
    end

    test "create_cafe_roaster/1 with valid data creates a cafe_roaster" do
      valid_attrs = %{is_current: true}

      assert {:ok, %CafeRoaster{} = cafe_roaster} = Cafes.create_cafe_roaster(valid_attrs)
      assert cafe_roaster.is_current == true
    end

    test "create_cafe_roaster/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cafes.create_cafe_roaster(@invalid_attrs)
    end

    test "update_cafe_roaster/2 with valid data updates the cafe_roaster" do
      cafe_roaster = cafe_roaster_fixture()
      update_attrs = %{is_current: false}

      assert {:ok, %CafeRoaster{} = cafe_roaster} =
               Cafes.update_cafe_roaster(cafe_roaster, update_attrs)

      assert cafe_roaster.is_current == false
    end

    test "update_cafe_roaster/2 with invalid data returns error changeset" do
      cafe_roaster = cafe_roaster_fixture()
      assert {:error, %Ecto.Changeset{}} = Cafes.update_cafe_roaster(cafe_roaster, @invalid_attrs)
      assert cafe_roaster == Cafes.get_cafe_roaster!(cafe_roaster.id)
    end

    test "delete_cafe_roaster/1 deletes the cafe_roaster" do
      cafe_roaster = cafe_roaster_fixture()
      assert {:ok, %CafeRoaster{}} = Cafes.delete_cafe_roaster(cafe_roaster)
      assert_raise Ecto.NoResultsError, fn -> Cafes.get_cafe_roaster!(cafe_roaster.id) end
    end

    test "change_cafe_roaster/1 returns a cafe_roaster changeset" do
      cafe_roaster = cafe_roaster_fixture()
      assert %Ecto.Changeset{} = Cafes.change_cafe_roaster(cafe_roaster)
    end
  end

  describe "roasters" do
    alias CoffeePrices.Cafes.Roaster

    import CoffeePrices.CafesFixtures

    @invalid_attrs %{name: nil, location: nil, website: nil}

    test "list_roasters/0 returns all roasters" do
      roaster = roaster_fixture()
      assert Cafes.list_roasters() == [roaster]
    end

    test "get_roaster!/1 returns the roaster with given id" do
      roaster = roaster_fixture()
      assert Cafes.get_roaster!(roaster.id) == roaster
    end

    test "create_roaster/1 with valid data creates a roaster" do
      valid_attrs = %{name: "some name", location: "some location", website: "some website"}

      assert {:ok, %Roaster{} = roaster} = Cafes.create_roaster(valid_attrs)
      assert roaster.name == "some name"
      assert roaster.location == "some location"
      assert roaster.website == "some website"
    end

    test "create_roaster/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cafes.create_roaster(@invalid_attrs)
    end

    test "update_roaster/2 with valid data updates the roaster" do
      roaster = roaster_fixture()

      update_attrs = %{
        name: "some updated name",
        location: "some updated location",
        website: "some updated website"
      }

      assert {:ok, %Roaster{} = roaster} = Cafes.update_roaster(roaster, update_attrs)
      assert roaster.name == "some updated name"
      assert roaster.location == "some updated location"
      assert roaster.website == "some updated website"
    end

    test "update_roaster/2 with invalid data returns error changeset" do
      roaster = roaster_fixture()
      assert {:error, %Ecto.Changeset{}} = Cafes.update_roaster(roaster, @invalid_attrs)
      assert roaster == Cafes.get_roaster!(roaster.id)
    end

    test "delete_roaster/1 deletes the roaster" do
      roaster = roaster_fixture()
      assert {:ok, %Roaster{}} = Cafes.delete_roaster(roaster)
      assert_raise Ecto.NoResultsError, fn -> Cafes.get_roaster!(roaster.id) end
    end

    test "change_roaster/1 returns a roaster changeset" do
      roaster = roaster_fixture()
      assert %Ecto.Changeset{} = Cafes.change_roaster(roaster)
    end
  end
end
