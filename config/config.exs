use Mix.Config

import_config "*.secret.exs"

config :exvcr, [
  filter_sensitive_data: [
    [
      pattern: Application.get_env(:openpay, :merchant_id, System.get_env("MERCHANT_ID")),
      placeholder: "MERCHANT_ID"
    ],
    [
      pattern: Application.get_env(:openpay, :api_key, System.get_env("API_KEY")),
      placeholder: "API_KEY"
    ]
  ]
]
