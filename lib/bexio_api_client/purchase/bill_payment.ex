defmodule BexioApiClient.Purchase.BillPayment do
  @moduledoc """
  Payment settings of a bill in purchase.
  """

  @typedoc """
  Payment settings of a bill in purchase.

  ## Fields:

    * `:type` - payment type as returned by the API (e.g. "IBAN")
    * `:fee` - fee type as returned by the API (e.g. "BY_SENDER")
    * `:execution_date` - date on which the payment is executed
    * `:house_no` - house number of the address, the API returns it as number or string
  """
  @type t :: %__MODULE__{
          type: String.t() | nil,
          bank_account_id: integer() | nil,
          fee: String.t() | nil,
          execution_date: Date.t() | nil,
          exchange_rate: float() | nil,
          amount: float() | nil,
          iban: String.t() | nil,
          name: String.t() | nil,
          address: String.t() | nil,
          street: String.t() | nil,
          house_no: integer() | String.t() | nil,
          postcode: String.t() | nil,
          city: String.t() | nil,
          country_code: String.t() | nil,
          message: String.t() | nil,
          booking_text: String.t() | nil,
          salary_payment?: boolean() | nil,
          reference_no: String.t() | nil,
          note: String.t() | nil
        }
  defstruct [
    :type,
    :bank_account_id,
    :fee,
    :execution_date,
    :exchange_rate,
    :amount,
    :iban,
    :name,
    :address,
    :street,
    :house_no,
    :postcode,
    :city,
    :country_code,
    :message,
    :booking_text,
    :salary_payment?,
    :reference_no,
    :note
  ]
end
