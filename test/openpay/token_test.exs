defmodule ExOpenpay.TokenTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    use_cassette "token_test/setup", match_requests_on: [:query, :request_body] do

      customer = Helper.create_test_customer "customer_test2@gmail.com"

      new_token = [
        card_number: "4111111111111111",
        holder_name: "Juan Perez Ramirez",
        expiration_year: "20",
        expiration_month: "12",
        cvv2: "110"
        # device_session_id: "",
      ]
      new_token2 = [
        card_number: "4111111111111111",
        holder_name: "Paco Sanchez Ramirez",
        expiration_year: "19",
        expiration_month: "10",
        cvv2: "210"
        # device_session_id: "",
      ]

      case ExOpenpay.Tokens.create new_token2 do
        {:ok, token2} ->
          case ExOpenpay.Tokens.create new_token do
            {:ok, token} -> {:ok, [token: token, token2: token2, customer: customer]}
            {:error, err} -> flunk err
          end
          {:error, err} -> flunk err
      end

    end
  end

  @tag disabled: false
  test "Create token", %{token: token, token2: _, customer: _}  do
    assert Map.get(token.card, "card_number") == "411111XXXXXX1111"
  end

  @tag disabled: false
  test "Create works", %{token: token, token2: _, customer: _} do
    assert Map.get(token, :id)
  end

  @tag disabled: false
  test "Retrieve single works", %{token: token, token2: _, customer: _} do
    use_cassette "token_test/get", match_requests_on: [:query, :request_body] do
      case ExOpenpay.Tokens.get Map.get(token, :id) do
        {:ok, found} -> assert Map.get(found, :id) == Map.get(token, :id)
        {:error, err} -> flunk err
      end
    end
  end

  @tag disabled: false
  test "Create card with token", %{token: token, token2: _, customer: customer} do
    use_cassette "token_test/card_token", match_requests_on: [:query, :request_body] do
      card_with_token_params = [
        token_id: Map.get(token, :id),
        device_session_id: "8VIoXj0hN5dswYHQ9X1mVCiB72M7FY9o"
      ]
      case ExOpenpay.Cards.create :customer, customer.id, card_with_token_params do
        {:ok, found} -> assert Map.get(found, :id) == Map.get(token, :id)
        {:error, err} -> flunk err
      end
    end
  end

end
