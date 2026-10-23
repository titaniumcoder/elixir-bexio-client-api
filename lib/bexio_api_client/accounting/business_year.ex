defmodule BexioApiClient.Accounting.BusinessYear do
  @moduledoc """
  Bexio Business Year Module.
  """

  @typedoc """
  Bexio Business Year

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:start` - Start date of the business year
    * `:end` - End date of the business year
    * `:status` - status of the business year (`:open` or `:closed`)
    * `:closed_at` - date when the business year was closed, `nil` while it is open
  """
  @type t :: %__MODULE__{
          id: integer(),
          start: Date.t(),
          end: Date.t(),
          status: :open | :closed,
          closed_at: Date.t() | nil
        }
  @enforce_keys [:id, :start, :end, :status]
  defstruct [:id, :start, :end, :status, :closed_at]
end
