defmodule BexioApiClient.Purchase.OutgoingPayment do
  @moduledoc """
  Outgoing payment for a bill in purchase
  """

  @typedoc """
  Outgoing payment for a bill in purchase.

  ## Fields:

    * `:status` - e.g. `:pending`, `:transferred`, `:downloaded`, `:reconciled`
    * `:payment_type` - `:iban`, `:manual`, `:cash_discount` or `:qr`
    * `:fee_type` - `:by_sender`, `:by_receiver`, `:breakdown` or `:no_fee`
    * `:salary_payment?` - only allowed to be `true` for `:iban` payments
    * `:receiver_account_no` - deprecated by bexio, not allowed for any current payment type
  """
  @type t :: %__MODULE__{
          id: String.t() | nil,
          status:
            :pending
            | :transferred
            | :downloaded
            | :reconciled
            | nil,
          created_at: DateTime.t() | NaiveDateTime.t() | nil,
          bill_id: String.t() | nil,
          payment_type: :iban | :manual | :cash_discount | :qr | nil,
          execution_date: Date.t() | nil,
          amount: float() | nil,
          currency_code: String.t() | nil,
          exchange_rate: float() | nil,
          note: String.t() | nil,
          sender_bank_account_id: integer() | nil,
          sender_iban: String.t() | nil,
          sender_name: String.t() | nil,
          sender_street: String.t() | nil,
          sender_house_no: String.t() | nil,
          sender_city: String.t() | nil,
          sender_postcode: String.t() | nil,
          sender_country_code: String.t() | nil,
          sender_bc_no: String.t() | nil,
          sender_bank_no: String.t() | nil,
          sender_bank_name: String.t() | nil,
          receiver_account_no: String.t() | nil,
          receiver_iban: String.t() | nil,
          receiver_name: String.t() | nil,
          receiver_street: String.t() | nil,
          receiver_house_no: String.t() | nil,
          receiver_city: String.t() | nil,
          receiver_postcode: String.t() | nil,
          receiver_country_code: String.t() | nil,
          receiver_bc_no: String.t() | nil,
          receiver_bank_no: String.t() | nil,
          receiver_bank_name: String.t() | nil,
          fee_type: :by_sender | :by_receiver | :breakdown | :no_fee | nil,
          salary_payment?: boolean() | nil,
          reference_no: String.t() | nil,
          message: String.t() | nil,
          booking_text: String.t() | nil,
          banking_payment_id: String.t() | nil,
          banking_payment_entry_id: String.t() | nil,
          transaction_id: String.t() | nil
        }
  @enforce_keys []
  defstruct [
    :id,
    :status,
    :created_at,
    :bill_id,
    :payment_type,
    :execution_date,
    :amount,
    :currency_code,
    :exchange_rate,
    :note,
    :sender_bank_account_id,
    :sender_iban,
    :sender_name,
    :sender_street,
    :sender_house_no,
    :sender_city,
    :sender_postcode,
    :sender_country_code,
    :sender_bc_no,
    :sender_bank_no,
    :sender_bank_name,
    :receiver_account_no,
    :receiver_iban,
    :receiver_name,
    :receiver_street,
    :receiver_house_no,
    :receiver_city,
    :receiver_postcode,
    :receiver_country_code,
    :receiver_bc_no,
    :receiver_bank_no,
    :receiver_bank_name,
    :fee_type,
    :salary_payment?,
    :reference_no,
    :message,
    :booking_text,
    :banking_payment_id,
    :banking_payment_entry_id,
    :transaction_id
  ]

  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        status: :pending,
        bill_id: nil,
        payment_type: :iban,
        execution_date: Date.utc_today(),
        amount: 0.0,
        currency_code: nil,
        exchange_rate: nil,
        salary_payment?: false
      },
      attrs
    )
  end
end
