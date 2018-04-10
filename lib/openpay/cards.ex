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
   * object,
   * number,
   * cvv2,
   * expiration_month,
   * expiration_year.
 Returns a `{:ok, card}` tuple.
 ## Examples
     params = [
       card_number: "4111111111111111",
       holder_name: "Juan Perez Ramirez",
       expiration_year: "20",
       expiration_month: "12",
       cvv2: "110"
       # device_session_id: "",
     ]
     {:ok, card} = ExOpenpay.Cards.create(:customer, customer_id, params)
 """
 def create(owner_type, owner_id, params) do
   create owner_type, owner_id, params, ExOpenpay.config_or_api_key
 end

 @doc """
 Create a card. Accepts ExOpenpay API key.
 Creates a card for given owner using params.
   * object,
   * number,
   * cvv2,
   * expiration_month,
   * expiration_year.
 Returns a `{:ok, card}` tuple.
 ## Examples
     {:ok, card} = ExOpenpay.Cards.create(:customer, customer_id, params, key)
 """
 def create(owner_type, owner_id, params, key) do
   ExOpenpay.make_request_with_key(:post, endpoint_for_entity(owner_type, owner_id), key, params)
   |> ExOpenpay.Util.handle_openpay_response
 end

 @doc """
  Get a card.
  Gets a card for given owner using card ID.
  Returns a `{:ok, card}` tuple.
  ## Examples
      {:ok, card} = ExOpenpay.Cards.get(:customer, customer_id, card_id)
  """
  def get(owner_type, owner_id, id) do
    get owner_type, owner_id, id, ExOpenpay.config_or_api_key
  end

  @doc """
  Get a card. Accepts ExOpenpay API key.
  Gets a card for given owner using card ID.
  Returns a `{:ok, card}` tuple.
  ## Examples
      {:ok, card} = ExOpenpay.Cards.get(:customer, customer_id, card_id, key)
  """
  def get(owner_type, owner_id, id, key) do
    ExOpenpay.make_request_with_key(:get, "#{endpoint_for_entity(owner_type, owner_id)}/#{id}", key)
    |> ExOpenpay.Util.handle_openpay_response
  end

 @doc """
   Get a list of cards.
   Gets a list of cards for given owner.
   Accepts the following parameters:
     * `starting_after` - an offset (optional),
     * `limit` - a limit of items to be returned (optional; defaults to 10).
   Returns a `{:ok, cards}` tuple, where `cards` is a list of cards.
   ## Examples
       {:ok, cards} = ExOpenpay.Cards.list(:customer, customer_id, 5) # Get a list of up to 10 cards, skipping first 5 cards
       {:ok, cards} = ExOpenpay.Cards.list(:customer, customer_id, 5, 20) # Get a list of up to 20 cards, skipping first 5 cards
   """
   def list(owner_type, owner_id, starting_after \\ "", limit \\ 10) do
     list owner_type, owner_id, ExOpenpay.config_or_api_key, starting_after, limit
   end

   @doc """
   Get a list of cards. Accepts ExOpenpay API key.
   Gets a list of cards for a given owner.
   Accepts the following parameters:
     * `starting_after` - an offset (optional),
     * `limit` - a limit of items to be returned (optional; defaults to 10).
   Returns a `{:ok, cards}` tuple, where `cards` is a list of cards.
   ## Examples
       {:ok, cards} = ExOpenpay.Cards.list(:customer, customer_id, key, 5) # Get a list of up to 10 cards, skipping first 5 cards
       {:ok, cards} = ExOpenpay.Cards.list(:customer, customer_id, key, 5, 20) # Get a list of up to 20 cards, skipping first 5 cards
   """
   def list(owner_type, owner_id, key, starting_after, limit) do
     ExOpenpay.Util.list endpoint_for_entity(owner_type, owner_id), key, starting_after, limit
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

  @doc """
  Delete all cards.

  Deletes all cards from given owner.

  Returns `:ok` atom.

  ## Examples

      :ok = ExOpenpay.Cards.delete_all(:customer, customer_id)

  """
  def delete_all(owner_type, owner_id) do
    case all(owner_type, owner_id) do
      {:ok, cards} ->
        Enum.each cards, fn c -> delete(owner_type, owner_id, c["id"]) end
      {:error, err} -> raise err
    end
  end

  @doc """
  Delete all cards. Accepts ExOpenpay API key.

  Deletes all cards from given owner.

  Returns `:ok` atom.

  ## Examples

      :ok = ExOpenpay.Cards.delete_all(:customer, customer_id, key)

  """
  def delete_all(owner_type, owner_id, key) do
    case all(owner_type, owner_id) do
      {:ok, customers} ->
        Enum.each customers, fn c -> delete(owner_type, owner_id, c["id"], key) end
      {:error, err} -> raise err
    end
  end

  @max_fetch_size 100

  @doc """
  List all cards.

  Lists all cards for a given owner.

  Accepts the following parameters:

    * `accum` - a list to start accumulating cards to (optional; defaults to `[]`).,
    * `starting_after` - an offset (optional; defaults to `""`).

  Returns `{:ok, cards}` tuple.

  ## Examples

      {:ok, cards} = ExOpenpay.Cards.all(:customer, customer_id, accum, starting_after)

  """
  def all(owner_type, owner_id, accum \\ [], starting_after \\ "") do
    all owner_type, owner_id, ExOpenpay.config_or_api_key, accum, starting_after
  end

  @doc """
  List all cards. Accepts ExOpenpay API key.

  Lists all cards for a given owner.

  Accepts the following parameters:

    * `accum` - a list to start accumulating cards to (optional; defaults to `[]`).,
    * `starting_after` - an offset (optional; defaults to `""`).

  Returns `{:ok, cards}` tuple.

  ## Examples

      {:ok, cards} = ExOpenpay.Cards.all(:customer, customer_id, accum, starting_after, key)

  """
  def all(owner_type, owner_id, key, accum, starting_after) do
    ExOpenpay.Util.list_raw("#{endpoint_for_entity(owner_type, owner_id)}",key, @max_fetch_size, starting_after)
  end

  @doc """
  Get total number of cards.

  Gets total number of cards for a given owner.

  Returns `{:ok, count}` tuple.

  ## Examples

      {:ok, count} = ExOpenpay.Cards.count(:customer, customer_id)

  """
  def count(owner_type, owner_id) do
    count owner_type, owner_id, ExOpenpay.config_or_api_key
  end

  @doc """
  Get total number of cards. Accepts ExOpenpay API key.

  Gets total number of cards for a given owner.

  Returns `{:ok, count}` tuple.

  ## Examples

      {:ok, count} = ExOpenpay.Cards.count(:customer, customer_id, key)

  """
  def count(owner_type, owner_id, key) do
    ExOpenpay.Util.count "#{endpoint_for_entity(owner_type, owner_id)}", key
  end

end
