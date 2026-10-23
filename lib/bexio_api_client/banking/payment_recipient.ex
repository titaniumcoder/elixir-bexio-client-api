defmodule BexioApiClient.Banking.PaymentRecipient do
  @moduledoc """
  Recipient of a bexio payment.
  """

  alias BexioApiClient.Banking.PaymentRecipientAddress

  @typedoc """
  Recipient of a payment.

  ## Fields:

    * `:name` - name of the recipient (person and/or company name)
    * `:iban` - IBAN of the recipient
    * `:address` - address of the recipient
  """
  @type t :: %__MODULE__{
          name: String.t() | nil,
          iban: String.t() | nil,
          address: PaymentRecipientAddress.t() | nil
        }
  defstruct [:name, :iban, :address]
end
