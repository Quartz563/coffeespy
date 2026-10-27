defmodule CoffeePrices.PricingTest do
  use CoffeePrices.DataCase

  alias CoffeePrices.Pricing

  describe "price_reports" do
    alias CoffeePrices.Pricing.PriceReports

    import CoffeePrices.PricingFixtures

    @invalid_attrs %{size: nil, drink_type: nil, milk_type: nil, price: nil}

    test "list_price_reports/0 returns all price_reports" do
      price_reports = price_reports_fixture()
      assert Pricing.list_price_reports() == [price_reports]
    end

    test "get_price_reports!/1 returns the price_reports with given id" do
      price_reports = price_reports_fixture()
      assert Pricing.get_price_reports!(price_reports.id) == price_reports
    end

    test "create_price_reports/1 with valid data creates a price_reports" do
      valid_attrs = %{
        size: "some size",
        drink_type: "some drink_type",
        milk_type: "some milk_type",
        price: "120.5"
      }

      assert {:ok, %PriceReports{} = price_reports} = Pricing.create_price_reports(valid_attrs)
      assert price_reports.size == "some size"
      assert price_reports.drink_type == "some drink_type"
      assert price_reports.milk_type == "some milk_type"
      assert price_reports.price == Decimal.new("120.5")
    end

    test "create_price_reports/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pricing.create_price_reports(@invalid_attrs)
    end

    test "update_price_reports/2 with valid data updates the price_reports" do
      price_reports = price_reports_fixture()

      update_attrs = %{
        size: "some updated size",
        drink_type: "some updated drink_type",
        milk_type: "some updated milk_type",
        price: "456.7"
      }

      assert {:ok, %PriceReports{} = price_reports} =
               Pricing.update_price_reports(price_reports, update_attrs)

      assert price_reports.size == "some updated size"
      assert price_reports.drink_type == "some updated drink_type"
      assert price_reports.milk_type == "some updated milk_type"
      assert price_reports.price == Decimal.new("456.7")
    end

    test "update_price_reports/2 with invalid data returns error changeset" do
      price_reports = price_reports_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Pricing.update_price_reports(price_reports, @invalid_attrs)

      assert price_reports == Pricing.get_price_reports!(price_reports.id)
    end

    test "delete_price_reports/1 deletes the price_reports" do
      price_reports = price_reports_fixture()
      assert {:ok, %PriceReports{}} = Pricing.delete_price_reports(price_reports)
      assert_raise Ecto.NoResultsError, fn -> Pricing.get_price_reports!(price_reports.id) end
    end

    test "change_price_reports/1 returns a price_reports changeset" do
      price_reports = price_reports_fixture()
      assert %Ecto.Changeset{} = Pricing.change_price_reports(price_reports)
    end
  end

  describe "confirmations" do
    alias CoffeePrices.Pricing.Confirmation

    import CoffeePrices.PricingFixtures

    @invalid_attrs %{}

    test "list_confirmations/0 returns all confirmations" do
      confirmation = confirmation_fixture()
      assert Pricing.list_confirmations() == [confirmation]
    end

    test "get_confirmation!/1 returns the confirmation with given id" do
      confirmation = confirmation_fixture()
      assert Pricing.get_confirmation!(confirmation.id) == confirmation
    end

    test "create_confirmation/1 with valid data creates a confirmation" do
      valid_attrs = %{}

      assert {:ok, %Confirmation{} = confirmation} = Pricing.create_confirmation(valid_attrs)
    end

    test "create_confirmation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pricing.create_confirmation(@invalid_attrs)
    end

    test "update_confirmation/2 with valid data updates the confirmation" do
      confirmation = confirmation_fixture()
      update_attrs = %{}

      assert {:ok, %Confirmation{} = confirmation} =
               Pricing.update_confirmation(confirmation, update_attrs)
    end

    test "update_confirmation/2 with invalid data returns error changeset" do
      confirmation = confirmation_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Pricing.update_confirmation(confirmation, @invalid_attrs)

      assert confirmation == Pricing.get_confirmation!(confirmation.id)
    end

    test "delete_confirmation/1 deletes the confirmation" do
      confirmation = confirmation_fixture()
      assert {:ok, %Confirmation{}} = Pricing.delete_confirmation(confirmation)
      assert_raise Ecto.NoResultsError, fn -> Pricing.get_confirmation!(confirmation.id) end
    end

    test "change_confirmation/1 returns a confirmation changeset" do
      confirmation = confirmation_fixture()
      assert %Ecto.Changeset{} = Pricing.change_confirmation(confirmation)
    end
  end
end
