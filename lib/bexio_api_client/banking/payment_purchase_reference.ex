defmodule BexioApiClient.Banking.PaymentPurchaseReference do
  @moduledoc """
  Reference of the bill a bexio payment belongs to.
  """

  @typedoc """
  Purchase reference of a payment.

  ## Fields:

    * `:bill_id` - uuid of the bill the payment belongs to
    * `:bill_payment_id` - uuid of the payment on the bill
  """
  @type t :: %__MODULE__{
          bill_id: String.t() | nil,
          bill_payment_id: String.t() | nil
        }
  defstruct [:bill_id, :bill_payment_id]
end
