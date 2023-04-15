defmodule BexioApiClient.Accounting.CalendarYear do
  @moduledoc """
  Bexio Calendar Year Module.
  """

  @typedoc """
  Bexio Calendar Year

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:start` - Start date of the calendar year
    * `:end` - End date of the calendar year
    * `:vat_subject?` - Determines if the calendar year is vat subjected or not
    * `:created_at` - Creation date of the calendar year
    * `:updated_at` - Last time when calendar year was updated
    * `:vat_accounting_method` - VAT accounting method (effective or net_tax), null if not subjected to vat
    * `:vat_accounting_type` - VAT accounting type (agreed or collected), null if not subjected to vat
  """
  @type t :: %__MODULE__{
          id: integer(),
          start: Date.t(),
          end: Date.t(),
          vat_subject?: boolean(),
          created_at: DateTime.t(),
          updated_at: DateTime.t(),
          vat_accounting_method: :effect | :net_tax | nil,
          vat_accounting_type: :agreed | :collected | nil
        }
  @enforce_keys [
    :id,
    :start,
    :end,
    :vat_subject?,
    :created_at,
    :updated_at,
    :vat_accounting_method,
    :vat_accounting_type
  ]
  defstruct [
    :id,
    :start,
    :end,
    :vat_subject?,
    :created_at,
    :updated_at,
    :vat_accounting_method,
    :vat_accounting_type
  ]
end
