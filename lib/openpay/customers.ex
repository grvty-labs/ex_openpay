defmodule ExOpenpay.Customers do
  @moduledoc """
  Functions for working with customers at Openpay. Through this API you can:

    * create a customer,
    * update a customer,
    * get a customer,
    * list customers,
    * count customers,
    * refund a customer,
    * partially refund a customer.

  Openpay API reference: https://www.openpay.mx/docs/api/?shell#clientes
  """

  @endpoint "customers"

  @doc """
  Create a customer.

  Creates a customer for a customer or card using amount and params. `params`
  must include a source.

  Returns `{:ok, customer}` tuple.

  ## Examples

      params = [
        name: "customer name",
        last_name: "",
        email: "customer_email@me.com",
        phone_number: "",
        # address: "",
        external_id: ""
      ]

      {:ok, customer} = ExOpenpay.Customers.create(params)

  """
  def create(params) do
    create params, ExOpenpay.config_or_api_key
  end

  @doc """
  Create a customer. Accepts ExOpenpay API key.

  Creates a customer for a customer or card using amount and params. `params`
  must include a source.

  Returns `{:ok, customer}` tuple.

  ## Examples

      {:ok, customer} = ExOpenpay.Customers.create(params, key)

  """
  def create(params, key) do
    ExOpenpay.make_request_with_key(:post, @endpoint, key, params)
    |> ExOpenpay.Util.handle_openpay_response
  end

  @doc """
   Delete a card.
   Deletes a card for given owner using card ID.
   Returns a `{:ok, card}` tuple.
   ## Examples
       {:ok, deleted_card} = ExOpenpay.Cards.delete("card_id")
   """
   def delete(id) do
     delete id, ExOpenpay.config_or_api_key
   end

   @doc """
   Delete a card. Accepts ExOpenpay API key.
   Deletes a card for given owner using card ID.
   Returns a `{:ok, card}` tuple.
   ## Examples
       {:ok, deleted_card} = ExOpenpay.Cards.delete("card_id", key)
   """
   def delete(id, key) do
     ExOpenpay.make_request_with_key(:delete, "#{@endpoint}/#{id}", key)
   end

end
