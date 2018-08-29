defmodule ExOpenpay.Tokens do
  @moduledoc """
  Functions for working with tokens at Openpay. Through this API you can:

    * create a token,
    * get a token,

  Openpay API reference: https://www.openpay.mx/docs/api/?shell#tokens
  """

  @endpoint "tokens"


  @doc """
 Create a token.
 Creates a token for ID using params.
   * object,
   * number,
   * cvv2,
   * expiration_month,
   * expiration_year.
 Returns a `{:ok, token}` tuple.
 ## Examples
     params = [
       token_number: "4111111111111111",
       holder_name: "Juan Perez Ramirez",
       expiration_year: "20",
       expiration_month: "12",
       cvv2: "110"
       # device_session_id: "",
     ]
     {:ok, token} = ExOpenpay.Cards.create(:customer, customer_id, params)
 """
 def create(params) do
   create params, ExOpenpay.config_or_api_key
 end

 @doc """
 Create a token. Accepts ExOpenpay API key.
 Creates a token for given owner using params.
   * object,
   * number,
   * cvv2,
   * expiration_month,
   * expiration_year.
 Returns a `{:ok, token}` tuple.
 ## Examples
     {:ok, token} = ExOpenpay.Cards.create(:customer, customer_id, params, key)
 """
 def create(params, key) do
   ExOpenpay.make_request_with_key(:post, @endpoint, key, params)
   |> ExOpenpay.Util.handle_openpay_response
 end

 @doc """
  Get a token.
  Gets a token for given owner using token ID.
  Returns a `{:ok, token}` tuple.
  ## Examples
      {:ok, token} = ExOpenpay.Cards.get(:customer, customer_id, token_id)
  """
  def get(id) do
    get id, ExOpenpay.config_or_api_key
  end

  @doc """
  Get a token. Accepts ExOpenpay API key.
  Gets a token for given owner using token ID.
  Returns a `{:ok, token}` tuple.
  ## Examples
      {:ok, token} = ExOpenpay.Cards.get(:customer, customer_id, token_id, key)
  """
  def get(id, key) do
    ExOpenpay.make_request_with_key(:get, "#{@endpoint}/#{id}", key)
    |> ExOpenpay.Util.handle_openpay_response
  end

end
