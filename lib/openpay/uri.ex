defmodule ExOpenpay.URI do
  @moduledoc """
  ExOpenpay URI helpers to encode nested dictionaries as query_params.
  """

  defmacro __using__(_) do
    quote do
      defp build_url(ext \\ "") do
        if ext != "", do: ext = "/" <> ext

        @base <> ext
      end
    end
  end

  @doc """
  Takes a keyword list and turns it into proper query values.

  ## Example
  card_data = [
    name: "customer name",
    last_name: "customer last name",
    email: "customer@email.com",
    phone_number: "",
  ]

  ExOpenpay.URI.encode_query(card) # "{\"phone_number\":\"\",\"name\":\"customer name\",\"last_name\":\"customer last name\",\"email\":\"customer@email.com\"}"
  """
  def encode_query(list) do
    Poison.encode!(Enum.into(list, %{}))
  end

end
