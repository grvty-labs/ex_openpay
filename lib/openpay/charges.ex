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

  def endpoint_for_entity(owner_id) do
    "customers/#{owner_id}/charges"
  end

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
  def create(owner_id, params) do
    create owner_id, params, ExOpenpay.config_or_api_key
  end

  @doc """
  Create a charge. Accepts ExOpenpay API key.

  Creates a charge for a customer or card using amount and params. `params`
  must include a source.

  Returns `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = ExOpenpay.Charges.create(1000, params, key)

  """
  def create(owner_id, params, key) do
    #default currency
    params = Keyword.put_new params, :currency, "MXN"
    ExOpenpay.make_request_with_key(:post, endpoint_for_entity(owner_id), key, params)
    |> ExOpenpay.Util.handle_openpay_response
  end

end
