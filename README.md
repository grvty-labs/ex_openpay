# Openpay for Elixir [![Build Status](https://travis-ci.org/grvty-labs/openpay.svg?branch=master)](https://travis-ci.org/grvty-labs/openpay) [![Hex.pm](https://img.shields.io/hexpm/v/stripity_openpay.svg?maxAge=2592000)](https://hex.pm/packages/stripity_openpay) [![Hex Docs](https://img.shields.io/badge/hex-docs-9768d1.svg)](https://hexdocs.pm/stripity_openpay) [![Hex.pm](https://img.shields.io/hexpm/dt/stripity_openpay.svg?maxAge=2592000)](https://hex.pm/packages/stripity_openpay) [![Inline docs](http://inch-ci.org/github/grvty-labs/openpay.svg)](http://inch-ci.org/github/grvty-labs/openpay) [![Coverage Status](https://coveralls.io/repos/github/grvty-labs/openpay/badge.svg?branch=master)](https://coveralls.io/github/grvty-labs/openpay?branch=master)

An Elixir library for working with [Openpay](http://openpay.mx/).

Features:
...

## Openpay API

Works with API version 2017-11-24

## Usage

Install the dependency:

```ex
{:ex_openpay, "~> 0.1.0"}
```

Next, add to your applications:

```ex
defp application do
  [applications: [:ex_openpay]]
end
```

## Configuration

To make API calls, it is necessary to configure your Openpay Api Key and your Merchant ID

```ex
use Mix.Config

config :ex_openpay, api_key: "YOUR API KEY"
config :ex_openpay, merchant_id: "YOUR MERCHANT ID"
```

To customize the underlying HTTPoison library, you may optionally add an `:httpoison_options` key to the ex_openpay configuration.  For a full list of configuration options, please refer to the [HTTPoison documentation](https://github.com/edgurgel/httpoison).

```ex
config :ex_openpay, httpoison_options: [timeout: 10000, recv_timeout: 10000, proxy: {"proxy.mydomain.com", 8080}]
```

## Testing
If you start contributing and you want to run mix test, first you need to export OPENPAY_API_KEY and OPENPAY_MERCHANT_ID environment variables in the same shell as the one you will be running mix test in. All tests have the @tag disabled: false and the test runner is configured to ignore disabled: true. This helps to turn tests on/off when working in them. Most of the tests depends on the order of execution (test random seed = 0) to minimize runtime. I've tried having each tests isolated but this made it take ~10 times longer.

```
export OPENPAY_API_KEY="yourkey"
export OPENPAY_MERCHANT_ID="yourmerchantid"
mix test
```

## The API

I've tried to make the API somewhat comprehensive and intuitive. If you'd like to see things in detail be sure to have a look at the tests - they show (generally) the way the API goes together.

In general, if Openpay requires some information for a given API call, you'll find that as part of the arity of the given function. For instance if you want to delete a Customer, you'll find that you *must* pass the id along:

```ex
{:ok, result} = Openpay.Customers.delete "some_id"
```


## Contributing

Feedback, feature requests, and fixes are welcomed and encouraged.  Please make appropriate use of [Issues](https://github.com/grvty-labs/openpay/issues) and [Pull Requests](https://github.com/grvty-labs/openpay/pulls).  All code should have accompanying tests.

## License

Please see [LICENSE](LICENSE) for licensing details.

---
Made with ❤️ by:


[![StackShare][stack-shield]][stack-tech]


[![GRVTY][logo]](http://grvty.digital)

[logo]: http://grvty.digital/images/logos/repos-logo-1.png?raw=true "GRVTY"

[stack-shield]: http://img.shields.io/badge/tech-stack-0690fa.svg?style=flat
[stack-tech]: http://stackshare.io/grvty/grvty
