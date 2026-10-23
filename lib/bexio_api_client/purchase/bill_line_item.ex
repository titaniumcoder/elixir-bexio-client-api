defmodule BexioApiClient.Purchase.BillLineItem do
  @moduledoc """
  Line item of a bill in purchase.
  """

  @typedoc """
  Line item of a bill in purchase.

  ## Fields:

    * `:id` - id of the line item, `nil` for new line items in update requests
    * `:position` - position of the line item
    * `:tax_id` - references a tax object, must be `nil` when the bill is not subject to VAT
    * `:tax_calc` - calculated tax amount, only returned by the API
    * `:amount` - amount of the line item, net or gross depending on the bill's `:item_net?`
    * `:booking_account_id` - references a booking account object
  """
  @type t :: %__MODULE__{
          id: String.t() | nil,
          position: non_neg_integer(),
          title: String.t() | nil,
          tax_id: integer() | nil,
          tax_calc: float() | nil,
          amount: float(),
          booking_account_id: integer() | nil
        }
  @enforce_keys [:position, :amount]
  defstruct [
    :id,
    :position,
    :title,
    :tax_id,
    :tax_calc,
    :amount,
    :booking_account_id
  ]
end
