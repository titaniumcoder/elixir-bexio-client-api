defmodule BexioApiClient.Banking.BankAccount do
  @moduledoc """
  Bank account shown on the banking component page (bexio API v3).
  """

  @typedoc """
  Bexio Bank Account

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - name of the bank account
    * `:owner` - owner of the bank account
    * `:owner_address` - street address of the owner
    * `:owner_house_number` - house number of the owner address
    * `:owner_zip` - zip code of the owner address
    * `:owner_city` - city of the owner address
    * `:owner_country_code` - country code of the owner address
    * `:bc_nr` - bc number (Bankenclearingnummer) of the bank
    * `:bank_name` - name of the bank
    * `:bank_nr` - bank identifier (e.g. BIC/SWIFT)
    * `:bank_account_nr` - bank account number
    * `:iban_nr` - IBAN of the bank account
    * `:currency_id` - id of the currency of the bank account
    * `:account_id` - id of the accounting account the bank account is linked to
    * `:remarks` - additional description of the bank account
    * `:invoice_mode` - invoice mode of the bank account (e.g. `qr_invoice`)
    * `:qr_invoice_iban` - IBAN used for QR invoices, only relevant for `invoice_mode: qr_invoice`
    * `:type` - type of the bank account (e.g. `bank`)
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          owner: String.t() | nil,
          owner_address: String.t() | nil,
          owner_house_number: integer() | String.t() | nil,
          owner_zip: integer() | String.t() | nil,
          owner_city: String.t() | nil,
          owner_country_code: String.t() | nil,
          bc_nr: integer() | nil,
          bank_name: String.t() | nil,
          bank_nr: String.t() | nil,
          bank_account_nr: String.t() | nil,
          iban_nr: String.t() | nil,
          currency_id: integer() | nil,
          account_id: integer() | nil,
          remarks: String.t() | nil,
          invoice_mode: String.t() | nil,
          qr_invoice_iban: String.t() | nil,
          type: String.t() | nil
        }
  @enforce_keys [:id, :name]
  defstruct [
    :id,
    :name,
    :owner,
    :owner_address,
    :owner_house_number,
    :owner_zip,
    :owner_city,
    :owner_country_code,
    :bc_nr,
    :bank_name,
    :bank_nr,
    :bank_account_nr,
    :iban_nr,
    :currency_id,
    :account_id,
    :remarks,
    :invoice_mode,
    :qr_invoice_iban,
    :type
  ]
end
