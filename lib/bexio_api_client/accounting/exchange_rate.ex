defmodule BexioApiClient.Accounting.ExchangeRate do
  @moduledoc """
  Bexio Currency Exchange Rate Module.
  """

  @typedoc """
  Bexio Currency Exchange Rate

  ## Fields:

    * `:factor` - the exchange rate of the currency in comparison with the currency listed in the field `:exchange_currency`
    * `:exchange_currency` - the reference currency for the exchange rate
      * `:id` - id of the currency
      * `:name` - name of the currency
      * `:round_factor` - round factor of the currency
  """
  @type t :: %__MODULE__{
          factor: float(),
          exchange_currency: BexioApiClient.Accounting.Currency.t()
        }
  @enforce_keys [:factor, :exchange_currency]
  defstruct [:factor, :exchange_currency]
end
