defmodule BexioApiClient.Purchase.Bill do
  @moduledoc """
  Bill in purchase
  """

  @typedoc """
  Bill in purchase.

  ## Fields:

    * `:vendor` - Joined `firstname_suffix` and `lastname_company` based on supplier (contact) type (COMPANY or PRIVATE)
    * `:net` - Net value of the bill. calculated based on line_items and discounts.
    * `:gross` - Gross value of the bill. calculated based on line_items and discounts.
    * `:overdue` - Indicates whether bill `due_date` has passed. for bill in status `:draft` or `:paid` is always false
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
          vendor: String.t(),
          created_at: NaiveDateTime.t(),
          vendor_ref: String.t() | nil,
          pending_amount: float() | nil,
          currency_code: String.t(),
          net: float() | nil,
          gross: float() | nil,
          bill_date: Date.t(),
          due_date: Date.t(),
          overdue?: boolean(),
          booking_account_ids: list(integer()),
          attachment_ids: list(String.t())
        }
  @enforce_keys [
    :id,
    :document_no,
    :status,
    :lastname_company,
    :vendor,
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
    :pending_amount,
    :currency_code,
    :net,
    :gross,
    :bill_date,
    :due_date,
    :overdue?,
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
        booking_account_ids: [],
        attachment_ids: []
      },
      attrs
    )
  end
end
