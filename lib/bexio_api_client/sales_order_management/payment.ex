defmodule BexioApiClient.SalesOrderManagement.Payment do
  @moduledoc """
  Payment of an invoice
  """

  @typedoc """
  Payment of an invoice

  ## Fields:

    * `:date` - date of the payment
    * `:value` - value of the payment
    * `:bank_account_id` - references a bank account object
    * `:title` - title of the payment (e.g. "Received Payment")
    * `:payment_service_id` - references a payment service (1 PayPal, 2 Stripe, 3 SIX Payments)
    * `:client_account_redemption?` - whether the payment is a client account redemption
    * `:cash_discount?` - whether the payment is a cash discount
    * `:kb_invoice_id` - the invoice the payment belongs to
    * `:kb_credit_voucher_id` - the credit voucher the payment belongs to
    * `:kb_bill_id` - the bill the payment belongs to
    * `:kb_credit_voucher_text` - text of the credit voucher
  """
  @type t :: %__MODULE__{
          id: integer(),
          date: Date.t(),
          value: Decimal.t(),
          bank_account_id: integer() | nil,
          title: String.t(),
          payment_service_id: integer() | nil,
          client_account_redemption?: boolean(),
          cash_discount?: boolean(),
          kb_invoice_id: integer() | nil,
          kb_credit_voucher_id: integer() | nil,
          kb_bill_id: integer() | nil,
          kb_credit_voucher_text: String.t()
        }
  @enforce_keys [
    :id,
    :date,
    :value,
    :title,
    :client_account_redemption?,
    :cash_discount?,
    :kb_credit_voucher_text
  ]
  defstruct [
    :id,
    :date,
    :value,
    :bank_account_id,
    :title,
    :payment_service_id,
    :client_account_redemption?,
    :cash_discount?,
    :kb_invoice_id,
    :kb_credit_voucher_id,
    :kb_bill_id,
    :kb_credit_voucher_text
  ]

  @doc """
  Create a new payment
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        date: Date.utc_today(),
        value: Decimal.new(0),
        bank_account_id: nil,
        title: "",
        payment_service_id: nil,
        client_account_redemption?: false,
        cash_discount?: false,
        kb_invoice_id: nil,
        kb_credit_voucher_id: nil,
        kb_bill_id: nil,
        kb_credit_voucher_text: ""
      },
      attrs
    )
  end
end
