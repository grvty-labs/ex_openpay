ExUnit.start
#ExOpenpay.start
ExUnit.configure [exclude: [disabled: true], seed: 0 ]

defmodule Helper do

  def create_test_token do
    params = [
      card: [
        number: "4242424242424242",
        exp_month: 8,
        exp_year: 2016,
        cvc: "314"
      ]
    ]
    {:ok, token} = ExOpenpay.Tokens.create(params)
    token
  end

  def create_test_customer( email ) do
    new_customer = [
      name: "Yamil",
      last_name: "Díaz Aguirre",
      email: "#{email}",
      phone_number: ""
      # address: "",
      # external_id: ""
    ]
    {:ok, res} = ExOpenpay.Customers.create new_customer
    res
  end

  def create_test_account(email) do
    new_account = [
      email: email,
      managed: true,
      legal_entity: [
        type: "individual"
      ]
    ]
    {:ok, res} = ExOpenpay.Accounts.create new_account
    res
  end
end
