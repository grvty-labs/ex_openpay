defmodule ExOpenpay.ChargeTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup do
    params = [
       source_id: "kqgykn96i7bcs1wwhvgw",
       method: "card",
       amount: 100,
       currency: "MXN",
       description: "Cargo inicial a mi cuenta",
       order_id: "oid-00051",
       device_session_id: "kR1MiQhz2otdIuUlQkbEyitIqVMiI16f",
       customer: [
        name: "Juan",
        last_name: "Vazquez Juarez",
        phone_number: "4423456723",
        email: "juan.vazquez@empresa.com.mx"
       ]
    ]
    {:ok, [params: params]}
  end

  # test "Create without valid authorization", %{params: params} do
  #   use_cassette "charge_test/createx" do
  #     case ExOpenpay.Charges.create(1000,params) do
  #       {:ok, _res} -> flunk "Unknow error"
  #       {:error, err} -> assert Map.get(err, "description")
  #     end
  #   end
  # end

  # test "Create with card works", %{params: params} do
  #   IO.inspect(ExOpenpay.Charges.create(1000,params))
  #   use_cassette "charge_test/create" do
  #     case ExOpenpay.Charges.create(1000,params) do
  #       {:ok, res} -> assert res
  #       {:error, err} -> flunk Map.get(err, "description")
  #     end
  #   end
  # end

  # test "Create with card, w/key works", %{params: params} do
  #   use_cassette "charge_test/create_with_key", match_requests_on: [:query, :request_body] do
  #     case ExOpenpay.Charges.create(1000,params, ExOpenpay.config_or_env_key) do
  #       {:ok, res} -> assert res.id
  #       {:error, err} -> flunk err
  #     end
  #   end
  # end
  #
  # test "List works" do
  #   use_cassette "charge_test/list", match_requests_on: [:query, :request_body] do
  #     case ExOpenpay.Charges.list() do
  #       {:ok, charges} -> assert length(charges) > 0
  #       {:error, err} -> flunk err
  #     end
  #   end
  # end
  #
  # test "List with customer works" do
  #   use_cassette "charge_test/list_with_customer", match_requests_on: [:query, :request_body] do
  #     case ExOpenpay.Charges.list(customer: "test") do
  #       {:ok, charges} -> assert length(charges) > 0
  #       {:error, err} -> flunk err
  #     end
  #   end
  # end
  #
  # test "List w/key works" do
  #   use_cassette "charge_test/list_with_key", match_requests_on: [:query, :request_body] do
  #     case ExOpenpay.Charges.list ExOpenpay.config_or_env_key, 1 do
  #       {:ok, charges} -> assert length(charges) > 0
  #       {:error, err} -> flunk err
  #     end
  #   end
  # end
  #
  # test "Get works" do
  #   use_cassette "charge_test/get", match_requests_on: [:query, :request_body] do
  #     {:ok,[first | _]} = ExOpenpay.Charges.list()
  #     case ExOpenpay.Charges.get(first.id) do
  #       {:ok, charge} -> assert charge.id == first.id
  #       {:error, err} -> flunk err
  #     end
  #   end
  # end
  #
  # test "Get w/key works" do
  #   use_cassette "charge_test/get_with_key", match_requests_on: [:query, :request_body] do
  #     {:ok,[first | _]} = ExOpenpay.Charges.list ExOpenpay.config_or_env_key, 1
  #     case ExOpenpay.Charges.get(first.id, ExOpenpay.config_or_env_key) do
  #       {:ok, charge} -> assert charge.id == first.id
  #       {:error, err} -> flunk err
  #     end
  #   end
  # end
  #
  # test "Capture works", %{params: params} do
  #   use_cassette "charge_test/capture", match_requests_on: [:query, :request_body] do
  #     params = Keyword.put_new params, :capture, false
  #     {:ok, charge} = ExOpenpay.Charges.create(1000,params)
  #     case ExOpenpay.Charges.capture(charge.id) do
  #       {:ok, captured} -> assert captured.id == charge.id
  #       {:error, err} -> flunk err
  #     end
  #   end
  # end
  #
  # test "Capture w/key works", %{params: params} do
  #   use_cassette "charge_test/capture_with_key", match_requests_on: [:query, :request_body] do
  #     params = Keyword.put_new params, :capture, false
  #     {:ok, charge} = ExOpenpay.Charges.create(1000,params, ExOpenpay.config_or_env_key)
  #     case ExOpenpay.Charges.capture(charge.id, ExOpenpay.config_or_env_key) do
  #       {:ok, captured} -> assert captured.id == charge.id
  #       {:error, err} -> flunk err
  #     end
  #   end
  # end
  #
  # test "Change(Update) works", %{params: params} do
  #   use_cassette "charge_test/change", match_requests_on: [:query, :request_body] do
  #     {:ok, charge} = ExOpenpay.Charges.create(1000,params)
  #     params = [description: "Changed charge"]
  #     case ExOpenpay.Charges.change(charge.id, params) do
  #       {:ok, changed} -> assert changed.description == "Changed charge"
  #       {:error, err} -> flunk err
  #     end
  #   end
  # end
  #
  # test "Change(Update) w/key works", %{params: params} do
  #   use_cassette "charge_test/change_with_key", match_requests_on: [:query, :request_body] do
  #     {:ok, charge} = ExOpenpay.Charges.create(2000,params, ExOpenpay.config_or_env_key)
  #     params = [description: "Changed charge"]
  #     case ExOpenpay.Charges.change(charge.id, params, ExOpenpay.config_or_env_key) do
  #       {:ok, changed} -> assert changed.description == "Changed charge"
  #       {:error, err} -> flunk err
  #     end
  #   end
  # end
  #
  # test "Refund works", %{params: params} do
  #   use_cassette "charge_test/partial_refund", match_requests_on: [:query, :request_body] do
  #     {:ok, charge} = ExOpenpay.Charges.create(3000,params)
  #     case ExOpenpay.Charges.refund_partial(charge.id,500) do
  #       {:ok, refunded} -> assert refunded.amount == 500
  #       {:error, err} -> flunk err
  #     end
  #   end
  # end
  #
  # test "Refund w/key works", %{params: params} do
  #   use_cassette "charge_test/partial_refund_with_key", match_requests_on: [:query, :request_body] do
  #     {:ok, charge} = ExOpenpay.Charges.create(5000,params, ExOpenpay.config_or_env_key)
  #     case ExOpenpay.Charges.refund_partial(charge.id,500, ExOpenpay.config_or_env_key) do
  #       {:ok, refunded} -> assert refunded.amount == 500
  #       {:error, err} -> flunk err
  #     end
  #   end
  # end
end
