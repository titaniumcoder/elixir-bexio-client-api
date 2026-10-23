defmodule BexioApiClient.Purchase.Bill do
  @moduledoc """
  Bill in purchase
  """

  alias BexioApiClient.Purchase.Address
  alias BexioApiClient.Purchase.BillDiscount
  alias BexioApiClient.Purchase.BillLineItem
  alias BexioApiClient.Purchase.BillPayment

  @typedoc """
  Bill in purchase.

  The list endpoint only returns the fields of the list response; the fields only
  present in the single-bill response (like `:supplier_id`, `:line_items`, `:payment`) are
  `nil`/`[]` there.

  ## Fields:

    * `:vendor` - Joined `firstname_suffix` and `lastname_company` based on supplier (contact) type (COMPANY or PRIVATE)
    * `:net` - Net value of the bill. calculated based on line_items and discounts.
    * `:gross` - Gross value of the bill. calculated based on line_items and discounts.
    * `:overdue` - Indicates whether bill `due_date` has passed. for bill in status `:draft` or `:paid` is always false
    * `:manual_amount?` - indicates whether `:amount_man` or `:amount_calc` is required and considered as bill amount
    * `:item_net?` - indicates whether `:amount` in `:line_items` is net or gross
    * `:split_into_line_items?` - indicates whether the bill has multiple items (line items and discounts) or a single item
    * `:qr_bill_information` - QR bill information string
  """
  @type t :: %__MODULE__{
          # what is the correct for UUID?
          id: String.t(),
          document_no: String.t(),
          title: String.t() | nil,
          status:
            :draft
            | :booked
            | :partially_created
            | :created
            | :partially_sent
            | :sent
            | :partially_downloaded
            | :downloaded
            | :partially_paid
            | :paid
            | :partially_failed
            | :failed,
          firstname_suffix: String.t() | nil,
          lastname_company: String.t(),
          vendor: String.t() | nil,
          created_at: DateTime.t() | NaiveDateTime.t(),
          vendor_ref: String.t() | nil,
          supplier_id: integer() | nil,
          contact_partner_id: integer() | nil,
          pending_amount: float() | nil,
          amount_man: float() | nil,
          amount_calc: float() | nil,
          manual_amount?: boolean() | nil,
          currency_code: String.t(),
          exchange_rate: float() | nil,
          base_currency_code: String.t() | nil,
          base_currency_amount: float() | nil,
          item_net?: boolean() | nil,
          split_into_line_items?: boolean() | nil,
          purchase_order_id: integer() | nil,
          qr_bill_information: String.t() | nil,
          net: float() | nil,
          gross: float() | nil,
          bill_date: Date.t(),
          due_date: Date.t(),
          overdue?: boolean(),
          address: Address.t() | nil,
          line_items: list(BillLineItem.t()),
          discounts: list(BillDiscount.t()),
          payment: BillPayment.t() | nil,
          booking_account_ids: list(integer()) | nil,
          attachment_ids: list(String.t())
        }
  @enforce_keys [
    :id,
    :document_no,
    :status,
    :lastname_company,
    :created_at,
    :currency_code,
    :bill_date,
    :due_date,
    :overdue?,
    :booking_account_ids,
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
    :created_at,
    :vendor_ref,
    :supplier_id,
    :contact_partner_id,
    :pending_amount,
    :amount_man,
    :amount_calc,
    :manual_amount?,
    :currency_code,
    :exchange_rate,
    :base_currency_code,
    :base_currency_amount,
    :item_net?,
    :split_into_line_items?,
    :purchase_order_id,
    :qr_bill_information,
    :net,
    :gross,
    :bill_date,
    :due_date,
    :overdue?,
    :address,
    :line_items,
    :discounts,
    :payment,
    :booking_account_ids,
    :attachment_ids
  ]

  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        document_no: nil,
        status: :draft,
        lastname_company: nil,
        vendor: nil,
        created_at: NaiveDateTime.utc_now(),
        currency_code: "",
        bill_date: Date.utc_today(),
        due_date: Date.utc_today(),
        overdue?: false,
        line_items: [],
        discounts: [],
        booking_account_ids: [],
        attachment_ids: []
      },
      attrs
    )
  end
end
