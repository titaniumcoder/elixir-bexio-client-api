defmodule BexioApiClient.Banking.Payment do
  @moduledoc """
  Payment in banking (bexio API v4).

  The docs model IBAN and QR payments as separate payload variants (`type`:
  `iban` or `qr`) of the same `/4.0/banking/payments` resource — this struct
  covers both variants.
  """

  alias BexioApiClient.Banking.PaymentPurchaseReference
  alias BexioApiClient.Banking.PaymentRecipient
  alias BexioApiClient.Banking.PaymentSender

  @typedoc """
  Bexio Payment

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:uuid` - uuid of the payment (used as `payment_id` in the path of the
      single payment endpoints)
    * `:account_id` - uuid of the bank account the payment is sent from (only
      needed when creating a payment)
    * `:sender` - the sending bank account
    * `:recipient` - the recipient of the payment
    * `:amount` - the amount to send in the chosen currency
    * `:currency` - currency in which the payment is sent, according to ISO 4217
    * `:execution_date` - date when the payment should be carried out by the bank
    * `:allowance` - who pays the fee for payments to other countries or with
      different currencies (`:fee_paid_by_payer`, `:fee_paid_by_payee`,
      `:fee_split` or `:no_fee`)
    * `:salary?` - if it is a salary payment (bexio's `is_salary`)
    * `:instruction_id` - instruction id of the payment
    * `:purchase_reference` - reference of the bill the payment belongs to
    * `:document_no` - document number of the linked bill
    * `:qr_reference_number` - a QR reference number or creditor reference number
    * `:additional_information` - additional information on the payment slip
    * `:status` - status of the payment as returned by bexio (e.g. `open`)
    * `:type` - type of the payment (`:iban` or `:qr`), each type requires
      different fields
    * `:due_date` - due date of the linked bill
    * `:created_at` - when the payment was created
    * `:editing_restricted?` - if set to true, editing will be restricted to (bexio's `is_editing_restricted`)
      the api client id which created the payment
    * `:message` - multiline description of the payment (only sent when
      creating/updating, not part of the response)
  """
  @type t :: %__MODULE__{
          id: integer() | String.t(),
          uuid: String.t() | nil,
          account_id: String.t() | nil,
          sender: PaymentSender.t() | nil,
          recipient: PaymentRecipient.t() | nil,
          amount: Decimal.t() | nil,
          currency: String.t() | nil,
          execution_date: Date.t() | nil,
          allowance: :fee_paid_by_payer | :fee_paid_by_payee | :fee_split | :no_fee | nil,
          salary?: boolean() | nil,
          instruction_id: String.t() | nil,
          purchase_reference: PaymentPurchaseReference.t() | nil,
          document_no: String.t() | nil,
          qr_reference_number: String.t() | nil,
          additional_information: String.t() | nil,
          status: String.t() | nil,
          type: :iban | :qr | nil,
          due_date: Date.t() | nil,
          created_at: DateTime.t() | NaiveDateTime.t() | nil,
          editing_restricted?: boolean() | nil,
          message: String.t() | nil
        }
  @enforce_keys [:id]
  defstruct [
    :id,
    :uuid,
    :account_id,
    :sender,
    :recipient,
    :amount,
    :currency,
    :execution_date,
    :allowance,
    :salary?,
    :instruction_id,
    :purchase_reference,
    :document_no,
    :qr_reference_number,
    :additional_information,
    :status,
    :type,
    :due_date,
    :created_at,
    :editing_restricted?,
    :message
  ]

  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        uuid: nil,
        account_id: nil,
        sender: nil,
        recipient: nil,
        amount: nil,
        currency: nil,
        execution_date: nil,
        allowance: nil,
        salary?: false,
        instruction_id: nil,
        purchase_reference: nil,
        document_no: nil,
        qr_reference_number: nil,
        additional_information: nil,
        status: nil,
        type: nil,
        due_date: nil,
        created_at: nil,
        editing_restricted?: false,
        message: nil
      },
      attrs
    )
  end
end
