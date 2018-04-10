defmodule ExOpenpay.Connect do
  require Map

  @moduledoc """
  Helper module for Connect related features at Openpay.
  Through this API you can:
  - retrieve the oauth access token or the full response, using the code received from the oauth flow return

  (reference https://openpay.com/docs/connect/standalone-accounts)
  """
  @sandbox_base_url "sandbox-api.openpay.mx"
  @production_base_url "api.openpay.mx"

  def base_api do
    case Application.get_env(:ex_openpay, :mode, "sandbox") do
      "production" -> @production_base_url
      "sandbox" -> @sandbox_base_url
      _ -> @sandbox_base_url
    end
  end

  @doc """
    Grabs the api version from the application config, defaults to "v1"
  """
  def api_version do
    Application.get_env(:ex_openpay, :api_version, "v1")
  end
end
