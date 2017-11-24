defmodule ExOpenpay.CustomerTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup do
    params = [
      name: "Yamil",
      last_name: "Díaz Aguirre",
      email: "yamilquery@gmail.com",
      phone_number: "4422551417"
      # address: "",
      # external_id: ""
    ]
    {:ok, [params: params]}
  end

  # test "Create", %{params: params} do
  #   use_cassette "customer_test/create" do
  #     case ExOpenpay.Customers.create(params) do
  #       {:ok, res} -> assert res.creation_date
  #       {:error, err} -> flunk Map.get(err, "description")
  #     end
  #   end
  # end

end
