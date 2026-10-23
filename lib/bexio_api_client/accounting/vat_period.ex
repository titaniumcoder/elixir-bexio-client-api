defmodule BexioApiClient.Accounting.VatPeriod do
  @moduledoc """
  Bexio Vat Period Module.
  """

  @typedoc """
  Bexio Vat Period

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:start` - Start date of the vat period
    * `:end` - End date of the vat period
    * `:type` - the period type (`:quarter` in the documented example; bexio does not document all values)
    * `:status` - status of the vat period (`:open` or `:closed`)
    * `:closed_at` - date when the vat period was closed, `nil` while it is open
  """
  @type t :: %__MODULE__{
          id: integer(),
          start: Date.t(),
          end: Date.t(),
          type: atom(),
          status: :open | :closed,
          closed_at: Date.t() | nil
        }
  @enforce_keys [:id, :start, :end, :type, :status]
  defstruct [:id, :start, :end, :type, :status, :closed_at]
end
