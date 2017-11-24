defmodule ExOpenpay.Cards do
  @moduledoc """
  Functions for working with cards at Openpay. Through this API you can:

    * create a card,
    * update a card,
    * get a card,
    * list cards,
    * count cards,
    * refund a card,
    * partially refund a card.

  Openpay API reference: https://www.openpay.mx/docs/api/?shell#tarjetas
  """

  def endpoint_for_entity(entity_type, entity_id) do
    case entity_type do
      :customer -> "customers/#{entity_id}/cards"
      :commerce -> "cards"
    end
  end

  @doc """
 Create a card.
 Creates a card for given owner type, owner ID using params.
 `params` must contain a "source" object. Inside the "source" object, the following parameters are required:
   * object,
   * number,
   * cvs,
   * exp_month,
   * exp_year.
 Returns a `{:ok, card}` tuple.
 ## Examples
     params = [
       source: [
         object: "card",
         number: "4111111111111111",
         cvc: 123,
         exp_month: 12,
         exp_year: 2020,
         metadata: [
           test_field: "test val"
         ]
       ]
     ]
     {:ok, card} = ExOpenpay.Cards.create(:customer, customer_id, params)
 """
 def create(owner_type, owner_id, params) do
   create owner_type, owner_id, params, ExOpenpay.config_or_api_key
 end

 @doc """
 Create a card. Accepts ExOpenpay API key.
 Creates a card for given owner using params.
 `params` must contain a "source" object. Inside the "source" object, the following parameters are required:
   * object,
   * number,
   * cvs,
   * exp_month,
   * exp_year.
 Returns a `{:ok, card}` tuple.
 ## Examples
     {:ok, card} = ExOpenpay.Cards.create(:customer, customer_id, params, key)
 """
 def create(owner_type, owner_id, params, key) do
   ExOpenpay.make_request_with_key(:post, endpoint_for_entity(owner_type, owner_id), key, params)
   |> ExOpenpay.Util.handle_openpay_response
 end

 @doc """
  Delete a card.
  Deletes a card for given owner using card ID.
  Returns a `{:ok, card}` tuple.
  ## Examples
      {:ok, deleted_card} = ExOpenpay.Cards.delete("card_id")
  """
  def delete(owner_type, owner_id, id) do
    delete owner_type, owner_id, id, ExOpenpay.config_or_api_key
  end

  @doc """
  Delete a card. Accepts ExOpenpay API key.
  Deletes a card for given owner using card ID.
  Returns a `{:ok, card}` tuple.
  ## Examples
      {:ok, deleted_card} = ExOpenpay.Cards.delete("card_id", key)
  """
  def delete(owner_type, owner_id, id,key) do
    ExOpenpay.make_request_with_key(:delete, "#{endpoint_for_entity(owner_type, owner_id)}/#{id}", key)
  end

end
