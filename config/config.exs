use Mix.Config

import_config "*.secret.exs"

config :exvcr, [
  filter_sensitive_data: [
    [
      pattern: Application.get_env(:ex_openpay, :merchant_id, System.get_env("OPENPAY_MERCHANT_ID")),
      placeholder: "OPENPAY_MERCHANT_ID"
    ],
    [
      pattern: Application.get_env(:ex_openpay, :api_key, System.get_env("OPENPAY_API_KEY")),
      placeholder: "OPENPAY_API_KEY"
    ]
  ]
]
