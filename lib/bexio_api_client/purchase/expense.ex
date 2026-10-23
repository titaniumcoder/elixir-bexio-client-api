defmodule BexioApiClient.Purchase.Expense do
  @moduledoc """
  Expense in purchase
  """

  alias BexioApiClient.Purchase.Address

  @typedoc """
  Expense in purchase.

  ## Fields:

    * `:status` - `:draft` or `:done`
    * `:vendor` - joined `firstname_suffix` and `lastname_company`, only present in the list response
    * `:supplier_id` - references a supplier (contact) object, `nil` when not set
    * `:net`/`:gross` - net/gross value of the expense, only present in the list response
    * `:base_currency_code` - base currency code taken from the settings
    * `:tax_man` - manually set tax amount
    * `:tax_calc` - calculated tax amount
    * `:transaction_id` - `nil` unless the expense is reconciled with a transaction
    * `:invoice_id` - `nil` unless the expense is linked to an invoice
    * `:project_id` - references a project object
    * `:address` - address of the supplier, must be `nil` when `:supplier_id` is not set
  """
  @type t :: %__MODULE__{
          id: String.t() | nil,
          document_no: String.t() | nil,
          title: String.t() | nil,
          status: :draft | :done,
          firstname_suffix: String.t() | nil,
          lastname_company: String.t() | nil,
          vendor: String.t() | nil,
          vendor_ref: String.t() | nil,
          created_at: DateTime.t() | NaiveDateTime.t() | nil,
          supplier_id: integer() | nil,
          paid_on: Date.t(),
          bank_account_id: integer() | nil,
          booking_account_id: integer() | nil,
          currency_code: String.t(),
          base_currency_code: String.t() | nil,
          exchange_rate: float() | nil,
          amount: float() | nil,
          net: float() | nil,
          gross: float() | nil,
          tax_man: float() | nil,
          tax_calc: float() | nil,
          tax_id: integer() | nil,
          base_currency_amount: float() | nil,
          transaction_id: String.t() | nil,
          invoice_id: String.t() | nil,
          project_id: String.t() | nil,
          attachment_ids: list(String.t()),
          address: Address.t() | nil
        }
  @enforce_keys [
    :paid_on,
    :currency_code,
    :amount,
    :attachment_ids
  ]
  defstruct [
    :id,
    :document_no,
    :title,
    :status,
    :firstname_suffix,
    :lastname_company,
    :vendor,
    :vendor_ref,
    :created_at,
    :supplier_id,
    :paid_on,
    :bank_account_id,
    :booking_account_id,
    :currency_code,
    :base_currency_code,
    :exchange_rate,
    :amount,
    :net,
    :gross,
    :tax_man,
    :tax_calc,
    :tax_id,
    :base_currency_amount,
    :transaction_id,
    :invoice_id,
    :project_id,
    :attachment_ids,
    :address
  ]

  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        document_no: nil,
        status: :draft,
        paid_on: Date.utc_today(),
        currency_code: "",
        amount: 0.0,
        attachment_ids: []
      },
      attrs
    )
  end
end
