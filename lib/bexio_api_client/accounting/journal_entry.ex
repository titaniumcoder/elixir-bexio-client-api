defmodule BexioApiClient.Accounting.JournalEntry do
  @moduledoc """
  Bexio Journal Entry Module.
  """

  @typedoc """
  Bexio Journal Entry (a single accounting journal booking)

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:ref_id` - the id of the referenced document
    * `:ref_uuid` - the uuid of the referenced document
    * `:ref_class` - the class of the referenced document (`:kb_offer`/`:kb_order`/`:kb_invoice`/`:kb_delivery`; unknown class names are kept as strings)
    * `:date` - the booking date
    * `:debit_account_id` - the id of the debit account
    * `:credit_account_id` - the id of the credit account
    * `:description` - the description of the booking
    * `:amount` - the booked amount in the currency of the booking
    * `:currency_id` - the id of the currency, references a currency object
    * `:currency_factor` - the currency factor
    * `:base_currency_id` - the id of the base currency
    * `:base_currency_amount` - the amount in the base currency
  """
  @type t :: %__MODULE__{
          id: integer(),
          ref_id: integer(),
          ref_uuid: String.t(),
          ref_class:
            :kb_offer
            | :kb_order
            | :kb_invoice
            | :kb_delivery
            | String.t(),
          date: DateTime.t(),
          debit_account_id: integer(),
          credit_account_id: integer(),
          description: String.t(),
          amount: Decimal.t(),
          currency_id: integer(),
          currency_factor: float(),
          base_currency_id: integer(),
          base_currency_amount: Decimal.t()
        }
  @enforce_keys [
    :id,
    :ref_id,
    :ref_uuid,
    :ref_class,
    :date,
    :debit_account_id,
    :credit_account_id,
    :description,
    :amount,
    :currency_id,
    :currency_factor,
    :base_currency_id,
    :base_currency_amount
  ]
  defstruct [
    :id,
    :ref_id,
    :ref_uuid,
    :ref_class,
    :date,
    :debit_account_id,
    :credit_account_id,
    :description,
    :amount,
    :currency_id,
    :currency_factor,
    :base_currency_id,
    :base_currency_amount
  ]
end
