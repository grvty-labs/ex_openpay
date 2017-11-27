defmodule ExOpenpay.CustomerTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    use_cassette "customer_test/setup" do
      customer2 = Helper.create_test_customer "test_customer1@grvtylabs.com"
      new_customer = [
        name: "Yamil",
        last_name: "Díaz Aguirre",
        email: "yamilquery@gmail.com",
        phone_number: "4422551417"
        # address: "",
        # external_id: ""
      ]

      case ExOpenpay.Customers.create new_customer do
        {:ok, customer} ->
          on_exit fn ->
            use_cassette "customer_test/teardown1" do
              ExOpenpay.Customers.delete customer.id
              ExOpenpay.Customers.delete customer2.id
            end
          end
          {:ok, [customer: customer, customer2: customer2]}
          {:error, err} -> flunk err
      end
    end
  end

  @tag disabled: false
  test "Create", %{customer: customer}  do
    assert customer.name == "Yamil"
  end

  @tag disabled: false
  test "Retrieve single customer", %{customer: customer, customer2: _} do
    use_cassette "customer_test/get", match_requests_on: [:query, :request_body] do
      case ExOpenpay.Customers.get customer.id do
        {:ok, found} -> assert found.id == customer.id
        {:error, err} -> flunk err
      end
    end
  end

  @tag disabled: false
  test "Retrieve all customers", %{customer: _, customer2: _} do
    use_cassette "customer_test/all", match_requests_on: [:query, :request_body] do
      case ExOpenpay.Customers.all [],"" do
        {:ok, custs} -> assert custs
        {:error, err} -> flunk err
      end
    end
  end

  @tag disabled: false
  test "Delete all customers", %{customer: _, customer2: _} do
    use_cassette "customer_test/delete_all", match_requests_on: [:query, :request_body] do
      Helper.create_test_customer "delete1@grvtylabs.com"
      Helper.create_test_customer "delete2@grvtylabs.com"
      ExOpenpay.Customers.delete_all

      case ExOpenpay.Customers.count do
        {:ok, cnt} -> assert cnt == 0
        {:error, err} -> flunk err
      end
    end
  end

end
