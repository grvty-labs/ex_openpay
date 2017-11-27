defmodule ExOpenpay do
  @moduledoc """
  A HTTP client for ExOpenpay.
  This module contains the Application that you can use to perform
  transactions on openpay API.

  ## Configuring
  By default the OPENPAY_MERCHANT_ID environment variable is used to find
  your API key for ExOpenpay. You can also manually set your API key by
  configuring the :ex_openpay application. You can see the default
  configuration in the default_config/0 private function at the bottom of
  this file. The value for platform client id is optional.

  ```
    config :ex_openpay, merchant_id: YOUR_OPENPAY_MERCHANT_ID
    config :ex_openpay, api_key: YOUR_OPENPAY_API_KEY
  ```
  """

  # Let's build on top of HTTPoison
  use HTTPoison.Base

  defmodule MissingSecretKeyError do
    defexception message: """
      The merchant_id setting is required so that we can report the
      correct environment instance to ExOpenpay. Please configure
      merchant_id in your config.exs and environment specific config files
      to have accurate reporting of errors.
      config :ex_openpay, merchant_id: YOUR_MERCHANT_ID
    """
  end

  defmodule MissingApiKeyError do
    defexception message: """
      The api_key setting is required so that we can report the
      correct environment instance to ExOpenpay. Please configure
      api_key in your config.exs and environment specific config files
      to have accurate reporting of errors.
      config :ex_openpay, api_key: YOUR_API_KEY
    """
  end


  @doc """
  Grabs OPENPAY_MERCHANT_ID from system ENV
  Returns binary
  """
  def config_or_env_key do
    require_openpay_merchant_id()
  end

  @doc """
  Grabs OPENPAY_OPENPAY_MERCHANT_ID from system ENV
  Returns binary
  """
  def config_or_api_key do
    require_openpay_api_key()
  end

  @doc """
  Creates the URL for our endpoint. You can also manually set API base url
  for testing purpose by configuring the :ex_openpay application
  with `:api_base_url` key. By default `https://api.openpay.com/v1/`.
  Here is an example:

      iex> Application.put_env(:ex_openpay, :api_base_url, "http://localhost:4004")
      :ok

      iex> ExOpenpay.process_url("/plans")
      "http://localhost:4004/plans"

  Args:
    * endpoint - part of the API we're hitting
  Returns string
  """
  def process_url(endpoint) do
    api_base_url = Application.get_env(:ex_openpay, :api_base_url, "https://#{ExOpenpay.config_or_api_key}:@#{ExOpenpay.Connect.base_api}/v1/#{ExOpenpay.config_or_env_key}/")
    api_base_url <> endpoint
  end

  @doc """
  Set our request headers for every request.
  """
  def req_headers(_key) do
    Map.new
      |> Map.put("Content-Type",  "application/json")
      # |> Map.put("Accept", "application/json; charset=utf-8")
      # |> Map.put("Authorization", "Basic #{key}")
      # |> Map.put("User-Agent",    "ExOpenpay/v1 openpay/1.4.0")
  end

  @doc """
  Converts the binary keys in our response to atoms.
  Args:
    * body - string binary response
  Returns Record or ArgumentError
  """
  def process_response_body(body) do
    Poison.decode! body
  end

  @doc """
  Boilerplate code to make requests with a given key.
  Args:
    * method - request method
    * endpoint - string requested API endpoint
    * key - openpay key passed to the api
    * body - request body
    * headers - request headers
    * options - request options
  Returns tuple
  """
  def make_request_with_key( method, endpoint, key, body \\ %{}, headers \\ %{}, options \\ []) do
    rb = ExOpenpay.URI.encode_query(body)
    rh = req_headers(key)
        |> Map.merge(headers)
        |> Map.to_list
    options = Keyword.merge(httpoison_request_options(), options)
    {:ok, response} =
      case method do
        :delete -> HTTPoison.delete(process_url(endpoint))
        _ -> request(method, endpoint, rb, rh, options)
      end
    response.body
    # {:ok, response} = request(method, endpoint, rb, rh, options)
    # response.body
  end

  @doc """
  Boilerplate code to make requests with the key read from config or env.see config_or_env_key/0
  Args:
  * method - request method
  * endpoint - string requested API endpoint
  * key - openpay key passed to the api
  * body - request body
  * headers - request headers
  * options - request options
  Returns tuple
  """
  def make_request(method, endpoint, body \\ %{}, headers \\ %{}, options \\ []) do
    make_request_with_key( method, endpoint, config_or_api_key(), body, headers, options )
  end

  defp require_openpay_merchant_id do
    case Application.get_env(:ex_openpay, :merchant_id, System.get_env "OPENPAY_MERCHANT_ID") || :not_found do
      :not_found ->
        raise MissingSecretKeyError
      value -> value
    end
  end

  defp require_openpay_api_key do
    case Application.get_env(:ex_openpay, :api_key, System.get_env "OPENPAY_API_KEY") || :not_found do
      :not_found ->
        raise MissingApiKeyError
      value -> value
    end
  end

  defp httpoison_request_options() do
    Application.get_env(:ex_openpay, :httpoison_options, [])
  end
end
