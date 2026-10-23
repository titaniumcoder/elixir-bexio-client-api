defmodule BexioApiClient.Purchase.BillDiscount do
  @moduledoc """
  Discount of a bill in purchase.
  """

  @typedoc """
  Discount of a bill in purchase.

  ## Fields:

    * `:id` - id of the discount, `nil` for new discounts in update requests
    * `:position` - position of the discount
    * `:amount` - amount of the discount, must be greater than 0 and less than the line items total
  """
  @type t :: %__MODULE__{
          id: String.t() | nil,
          position: non_neg_integer(),
          amount: float()
        }
  @enforce_keys [:position, :amount]
  defstruct [
    :id,
    :position,
    :amount
  ]
end
