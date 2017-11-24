defmodule ExOpenpay.Connect do
  require Map

  @moduledoc """
  Helper module for Connect related features at Openpay.
  Through this API you can:
  - retrieve the oauth access token or the full response, using the code received from the oauth flow return

  (reference https://openpay.com/docs/connect/standalone-accounts)
  """

  def base_api do
    "sandbox-api.openpay.mx"
  end

end
