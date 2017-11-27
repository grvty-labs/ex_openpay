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
                ExOpenpay.Cards.delete :customer, customer.id, card2.id
              end
            end
            {:ok, [customer: customer, card: card, card2: card2]}
            {:error, err} -> flunk err
          end
          {:error, err} -> flunk err
      end

    end
  end

  @tag disabled: false
  test "Create card", %{customer: _, card: card, card2: _}  do
    assert card.card_number == "411111XXXXXX1111"
  end

  @tag disabled: false
  test "Count works", %{customer: customer, card: _, card2: _}  do
    use_cassette "card_test/count", match_requests_on: [:query, :request_body] do
      case ExOpenpay.Cards.count :customer, customer.id do
        {:ok, cnt} -> assert cnt == 2
        {:error, err} -> flunk err
      end
    end
  end

  @tag disabled: false
  test "List works", %{customer: customer, card: _, card2: _}  do
    use_cassette "card_test/list", match_requests_on: [:query, :request_body] do
      case ExOpenpay.Cards.list :customer, customer.id, "", 1 do
        {:ok, res} ->
          assert length(res) == 1
          {:error, err} -> flunk err
      end
    end
  end

  @tag disabled: false
  test "Retrieve all works", %{customer: customer, card: _, card2: _} do
    use_cassette "card_test/all", match_requests_on: [:query, :request_body] do
      case ExOpenpay.Cards.all :customer, customer.id, [],"" do
        {:ok, cards} ->
          assert length(cards) > 0
          {:error, err} -> flunk err
      end
    end
  end

  @tag disabled: false
  test "Create works", %{customer: _, card: card, card2: _} do
    assert card.id
  end

  @tag disabled: false
  test "Retrieve single works", %{customer: customer, card: card, card2: _} do
    use_cassette "card_test/get", match_requests_on: [:query, :request_body] do
      case ExOpenpay.Cards.get :customer, customer.id, card.id do
        {:ok, found} -> assert found.id == card.id
        {:error, err} -> flunk err
      end
    end
  end

  # FIXME: Delete request returns empty body, assert
  @tag disabled: true
  test "Delete works", %{customer: customer, card: card, card2: _} do
    use_cassette "card_test/delete", match_requests_on: [:query, :request_body] do
      case ExOpenpay.Cards.delete :customer, customer.id, card.id do
        {:ok, res} -> assert res == ""
        {:error, err} -> flunk err
      end
    end
  end

end
