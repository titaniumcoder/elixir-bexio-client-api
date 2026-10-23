defmodule BexioApiClient.Accounting.ManualEntryLine do
  @moduledoc """
  Bexio Manual Entry Line Module.

  A single booking line within a `BexioApiClient.Accounting.ManualEntry`.
  """

  @typedoc """
  Bexio Manual Entry Line

  ## Fields:

    * `:id` - automatic id given by bexio (`nil` for a not yet created line)
    * `:date` - the booking date
    * `:debit_account_id` - the id of the debit account
    * `:credit_account_id` - the id of the credit account
    * `:tax_id` - the id of the tax, references a tax object
    * `:tax_account_id` - the id of the tax account
    * `:description` - the description of the booking line
    * `:amount` - the booked amount
    * `:currency_id` - the id of the currency, references a currency object
    * `:base_currency_id` - the id of the base currency
    * `:currency_factor` - the currency factor
    * `:base_currency_amount` - the amount in the base currency
    * `:created_by_user_id` - the id of the user who created the line
    * `:edited_by_user_id` - the id of the user who last edited the line
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          date: Date.t(),
          debit_account_id: integer(),
          credit_account_id: integer(),
          tax_id: integer() | nil,
          tax_account_id: integer() | nil,
          description: String.t() | nil,
          amount: Decimal.t(),
          currency_id: integer(),
          base_currency_id: integer() | nil,
          currency_factor: float() | nil,
          base_currency_amount: Decimal.t() | nil,
          created_by_user_id: integer() | nil,
          edited_by_user_id: integer() | nil
        }
  @enforce_keys [:id, :date, :debit_account_id, :credit_account_id, :amount, :currency_id]
  defstruct [
    :id,
    :date,
    :debit_account_id,
    :credit_account_id,
    :tax_id,
    :tax_account_id,
    :description,
    :amount,
    :currency_id,
    :base_currency_id,
    :currency_factor,
    :base_currency_amount,
    :created_by_user_id,
    :edited_by_user_id
  ]

  @doc """
  Create a new manual entry line (part of `BexioApiClient.Accounting.ManualEntry.new/1`).
  The id and the user ids are ignored when creating.
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        date: nil,
        debit_account_id: nil,
        credit_account_id: nil,
        tax_id: nil,
        tax_account_id: nil,
        description: nil,
        amount: nil,
        currency_id: nil,
        base_currency_id: nil,
        currency_factor: nil,
        base_currency_amount: nil,
        created_by_user_id: nil,
        edited_by_user_id: nil
      },
      attrs
    )
  end
end
