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

  Creates a customer for a customer or customer using amount and params. `params`
  must include a source.

  Returns `{:ok, customer}` tuple.

  ## Examples

      params = [
        name: "customer name",
        last_name: "",
        email: "customer_email@me.com",
        phone_number: "",
        # address: "",
        # external_id: ""
      ]

      {:ok, customer} = ExOpenpay.Customers.create(params)

  """
  def create(params) do
    create params, ExOpenpay.config_or_api_key
  end

  @doc """
  Create a customer. Accepts ExOpenpay API key.

  Creates a customer for a customer or customer using amount and params. `params`
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
   Get a customer.
   Gets a customer for given owner using customer ID.
   Returns a `{:ok, customer}` tuple.
   ## Examples
       {:ok, customer} = ExOpenpay.Customers.get(customer_id)
   """
   def get(id) do
     get id, ExOpenpay.config_or_api_key
   end

   @doc """
   Get a customer. Accepts ExOpenpay API key.
   Gets a customer for given owner using customer ID.
   Returns a `{:ok, customer}` tuple.
   ## Examples
       {:ok, customer} = ExOpenpay.Customers.get(customer_id, key)
   """
   def get(id, key) do
     ExOpenpay.make_request_with_key(:get, "#{@endpoint}/#{id}", key)
     |> ExOpenpay.Util.handle_openpay_response
   end

  @doc """
   Delete a customer.
   Deletes a customer for given owner using customer ID.
   Returns a `{:ok, customer}` tuple.
   ## Examples
       {:ok, deleted_customer} = ExOpenpay.Customers.delete("customer_id")
   """
   def delete(id) do
     delete id, ExOpenpay.config_or_api_key
   end

   @doc """
   Delete a customer. Accepts ExOpenpay API key.
   Deletes a customer for given owner using customer ID.
   Returns a `{:ok, customer}` tuple.
   ## Examples
       {:ok, deleted_customer} = ExOpenpay.Customers.delete("customer_id", key)
   """
   def delete(id, key) do
     ExOpenpay.make_request_with_key(:delete, "#{@endpoint}/#{id}", key)
   end

   @doc """
  Deletes all Customers
  ## Example
  ```
  ExOpenpay.Customers.delete_all
  ```
  """
  def delete_all do
    case all() do
      {:ok, customers} ->
        Enum.each customers, fn c -> delete(c["id"]) end
      {:error, err} -> raise err
    end
  end

  @doc """
  Deletes all Customers
  Using a given openpay key to apply against the account associated.
  ## Example
  ```
  ExOpenpay.Customers.delete_all key
  ```
  """
  def delete_all key do
    case all() do
      {:ok, customers} ->
        Enum.each customers, fn c -> delete(c["id"], key) end
      {:error, err} -> raise err
    end
  end

  @max_fetch_size 100
  @doc """
  List all customers.
  ##Example
  ```
  {:ok, customers} = ExOpenpay.Customers.all
  ```
  """
  def all( accum \\ [], starting_after \\ "") do
    all ExOpenpay.config_or_api_key, accum, starting_after
  end

  @doc """
  List all customers.
  Using a given openpay key to apply against the account associated.
  ##Example
  ```
  {:ok, customers} = ExOpenpay.Customers.all key, accum, starting_after
  ```
  """
  def all( key, _accum, starting_after) do
    ExOpenpay.Util.list_raw("#{@endpoint}",key, @max_fetch_size, starting_after)
  end

  @doc """
  Count total number of customers.
  ## Example
  ```
  {:ok, count} = ExOpenpay.Customers.count
  ```
  """
  def count do
    count ExOpenpay.config_or_api_key
  end

  @doc """
  Count total number of customers.
  Using a given openpay key to apply against the account associated.
  ## Example
  ```
  {:ok, count} = ExOpenpay.Customers.count key
  ```
  """
  def count( key )do
    ExOpenpay.Util.count "#{@endpoint}", key
  end

end
