defmodule ExOpenpay.Charges do
  @moduledoc """
  Functions for working with charges at Openpay. Through this API you can:

    * create a charge,
    * update a charge,
    * get a charge,
    * list charges,
    * count charges,
    * refund a charge,
    * partially refund a charge.

  Openpay API reference: https://www.openpay.mx/docs/api/?shell#cargos
  """

  @endpoint "charges"

  @doc """
  Create a charge.

  Creates a charge for a customer or card using amount and params. `params`
  must include a source.

  Returns `{:ok, charge}` tuple.

  ## Examples

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

      {:ok, charge} = ExOpenpay.Charges.create(1000, params)

  """
  def create(amount, params) do
    create amount, params, ExOpenpay.config_or_api_key
  end

  @doc """
  Create a charge. Accepts ExOpenpay API key.

  Creates a charge for a customer or card using amount and params. `params`
  must include a source.

  Returns `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = ExOpenpay.Charges.create(1000, params, key)

  """
  def create(amount, params, key) do
    #default currency
    params = Keyword.put_new params, :currency, "MXN"
    #drop in the amount
    params = Keyword.put_new params, :amount, amount
    ExOpenpay.make_request_with_key(:post, @endpoint, key, params)
    |> ExOpenpay.Util.handle_openpay_response
  end

  @doc """
  Get a list of charges.

  Gets a list of charges.

  Accepts the following parameters:

    * `limit` - a limit of items to be returned (optional; defaults to 10).

  Returns a `{:ok, charges}` tuple, where `charges` is a list of charges.

  ## Examples

      {:ok, charges} = ExOpenpay.charges.list() # Get a list of 10 charges
      {:ok, charges} = ExOpenpay.charges.list(20) # Get a list of 20 charges

  """
  def list(params \\ [])
  def list(limit) when is_integer(limit) do
    list ExOpenpay.config_or_api_key, limit
  end
  @doc """
  Get a list of charges.

  Gets a list of charges.

  Accepts the following parameters:

    * `params` - a list of params supported by Openpay (optional; defaults to []). Available parameters are:
      `customer`, `ending_before`, `limit` and `source`.

  Returns a `{:ok, charges}` tuple, where `charges` is a list of charges.

  ## Examples

      {:ok, charges} = ExOpenpay.Charges.list(source: "card") # Get a list of charges for cards

  """
  def list(params) do
    list(ExOpenpay.config_or_api_key, params)
  end

  @doc """
  Get a list of charges. Accepts ExOpenpay API key.

  Gets a list of charges.

  Accepts the following parameters:

    * `limit` - a limit of items to be returned (optional; defaults to 10).

  Returns a `{:ok, charges}` tuple, where `charges` is a list of charges.

  ## Examples

      {:ok, charges} = ExOpenpay.charges.list("my_key") # Get a list of up to 10 charges
      {:ok, charges} = ExOpenpay.charges.list("my_key", 20) # Get a list of up to 20 charges

  """
  def list(key, limit) when is_integer(limit) do
    ExOpenpay.make_request_with_key(:get, "#{@endpoint}?limit=#{limit}", key)
    |> ExOpenpay.Util.handle_openpay_response
  end
  @doc """
  Get a list of charges. Accepts ExOpenpay API key.

  Gets a list of charges.

  Accepts the following parameters:

    * `params` - a list of params supported by ExOpenpay (optional; defaults to
      `[]`). Available parameters are: `customer`, `ending_before`, `limit` and
      `source`.

  Returns a `{:ok, charges}` tuple, where `charges` is a list of charges.

  ## Examples

      {:ok, charges} = ExOpenpay.Charges.list("my_key", source: "card") # Get a list of charges for cards

  """
  def list(key, params) do
    ExOpenpay.make_request_with_key(:get, "#{@endpoint}", key, %{}, %{}, [params: params])
    |> ExOpenpay.Util.handle_openpay_response
  end

  @doc """
  Update a charge.

  Updates a charge with changeable information.

  Accepts the following parameters:

    * `params` - a list of params to be updated (optional; defaults to `[]`).
      Available parameters are: `description`, `metadata`, `receipt_email`,
      `fraud_details` and `shipping`.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      params = [
        description: "Changed charge"
      ]

      {:ok, charge} = ExOpenpay.Charges.change("charge_id", params)

  """
  def change(id, params) do
    change id, params, ExOpenpay.config_or_api_key
  end

  @doc """
  Update a charge. Accepts ExOpenpay API key.

  Updates a charge with changeable information.

  Accepts the following parameters:

    * `params` - a list of params to be updated (optional; defaults to `[]`).
      Available parameters are: `description`, `metadata`, `receipt_email`,
      `fraud_details` and `shipping`.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      params = [
        description: "Changed charge"
      ]

      {:ok, charge} = ExOpenpay.Charges.change("charge_id", params, "my_key")

  """
  def change(id, params, key) do
    ExOpenpay.make_request_with_key(:post, "#{@endpoint}/#{id}", key, params)
    |> ExOpenpay.Util.handle_openpay_response
  end

  @doc """
  Capture a charge.

  Captures a charge that is currently pending.

  Note: you can default a charge to be automatically captured by setting `capture: true` in the charge create params.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = ExOpenpay.Charges.capture("charge_id")

  """
  def capture(id) do
    capture id, ExOpenpay.config_or_api_key
  end

  @doc """
  Capture a charge. Accepts ExOpenpay API key.

  Captures a charge that is currently pending.

  Note: you can default a charge to be automatically captured by setting `capture: true` in the charge create params.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = ExOpenpay.Charges.capture("charge_id", "my_key")

  """
  def capture(id,key) do
    ExOpenpay.make_request_with_key(:post, "#{@endpoint}/#{id}/capture", key)
    |> ExOpenpay.Util.handle_openpay_response
  end

  @doc """
  Get a charge.

  Gets a charge.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = ExOpenpay.Charges.get("charge_id")

  """
  def get(id) do
    get id, ExOpenpay.config_or_api_key
  end

  @doc """
  Get a charge. Accepts ExOpenpay API key.

  Gets a charge.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = ExOpenpay.Charges.get("charge_id", "my_key")

  """
  def get(id, key) do
    ExOpenpay.make_request_with_key(:get, "#{@endpoint}/#{id}", key)
    |> ExOpenpay.Util.handle_openpay_response
  end

  @doc """
  Refund a charge.

  Refunds a charge completely.

  Note: use `refund_partial` if you just want to perform a partial refund.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = ExOpenpay.Charges.refund("charge_id")

  """
  def refund(id) do
    refund id, ExOpenpay.config_or_api_key
  end

  @doc """
  Refund a charge. Accepts ExOpenpay API key.

  Refunds a charge completely.

  Note: use `refund_partial` if you just want to perform a partial refund.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = ExOpenpay.Charges.refund("charge_id", "my_key")

  """
  def refund(id, key) do
    ExOpenpay.make_request_with_key(:post, "#{@endpoint}/#{id}/refunds", key)
    |> ExOpenpay.Util.handle_openpay_response
  end

  @doc """
  Partially refund a charge.

  Refunds a charge partially.

  Accepts the following parameters:

    * `amount` - amount to be refunded (required).

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = ExOpenpay.Charges.refund_partial("charge_id", 500)

  """
  def refund_partial(id, amount) do
    refund_partial id, amount, ExOpenpay.config_or_api_key
  end

  @doc """
  Partially refund a charge. Accepts ExOpenpay API key.

  Refunds a charge partially.

  Accepts the following parameters:

    * `amount` - amount to be refunded (required).

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = ExOpenpay.Charges.refund_partial("charge_id", 500, "my_key")

  """
  def refund_partial(id, amount, key) do
    params = [amount: amount]
    ExOpenpay.make_request_with_key(:post, "#{@endpoint}/#{id}/refunds", key, params)
    |> ExOpenpay.Util.handle_openpay_response
  end

  @doc """
  Get total number of charges.

  Gets total number of charges.

  Returns `{:ok, count}` tuple.

  ## Examples

      {:ok, count} = ExOpenpay.Charges.count()

  """
  def count do
    count ExOpenpay.config_or_api_key
  end

  @doc """
  Get total number of charges. Accepts ExOpenpay API key.

  Gets total number of charges.

  Returns `{:ok, count}` tuple.

  ## Examples

      {:ok, count} = ExOpenpay.Charges.count("key")

  """
  def count(key) do
    ExOpenpay.Util.count "#{@endpoint}", key
  end
end
