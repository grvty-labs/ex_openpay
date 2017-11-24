defmodule ExOpenpay.CardTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    use_cassette "card_test/setup", match_requests_on: [:query, :request_body] do
      customer = Helper.create_test_customer "customer_test1@gmail.com"

      on_exit fn ->
        use_cassette "card_test/teardown1", match_requests_on: [:query, :request_body] do
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
            on_exit fn ->
              use_cassette "card_test/teardown2", match_requests_on: [:query, :request_body] do
                ExOpenpay.Cards.delete :customer, customer.id, card.id
              end
            end
            {:ok, [customer: customer, card: card, card2: card2]}
            {:error, err} -> flunk err
          end
          {:error, err} -> flunk err
      end

    end
  end

  test "Create card", %{customer: _, card: card, card2: _}  do
    assert card.card_number == "411111XXXXXX1111"
  end

end
