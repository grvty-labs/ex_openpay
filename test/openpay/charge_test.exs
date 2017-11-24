defmodule ExOpenpay.ChargeTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    use_cassette "charge_test/setup", match_requests_on: [:query, :request_body] do
      customer = Helper.create_test_customer "customer_test1@gmail.com"

      on_exit fn ->
        use_cassette "charge_test/teardown1", match_requests_on: [:query, :request_body] do
          ExOpenpay.Customers.delete customer.id
        end
      end

      new_card = [
        card_number: "4111111111111111",
        holder_name: "Juan Perez Ramirez",
        expiration_year: "20",
        expiration_month: "12",
        cvv2: "110"
        # device_session_id: "",
      ]
      new_card2 = [
        card_number: "4111111111111111",
        holder_name: "Paco Sanchez Ramirez",
        expiration_year: "19",
        expiration_month: "10",
        cvv2: "210"
        # device_session_id: "",
      ]

      case ExOpenpay.Cards.create :customer, customer.id, new_card2 do
        {:ok, card2} ->
          case ExOpenpay.Cards.create :customer, customer.id, new_card do
            {:ok, card} ->
              new_charge = [
                 source_id: card.id,
                 method: "card",
                 amount: 100,
                 currency: "MXN",
                 description: "Cargo inicial a mi cuenta",
                 order_id: "grv-00001",
                 device_session_id: "kR1MiQhz2otdIuUlQkbEyitIqVMiI16f",
              ]
              on_exit fn ->
                use_cassette "charge_test/teardown2", match_requests_on: [:query, :request_body] do
                  ExOpenpay.Cards.delete :customer, customer.id, card.id
                end
              end
            {:ok, [customer: customer, card: card, card2: card2, new_charge: new_charge]}
            {:error, err} -> flunk err
          end
          {:error, err} -> flunk err
      end

    end
  end

  test "With Card ID or Token", %{customer: customer, new_charge: new_charge}  do
    use_cassette "charge_test/create_with_card_id" do
      case ExOpenpay.Charges.create(customer.id, new_charge) do
        {:ok, res} -> assert res
        {:error, err} -> flunk Map.get(err, "description")
      end
    end
  end

end
