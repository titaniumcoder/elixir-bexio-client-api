defmodule BexioApiClient.Accounting.Tax do
  @moduledoc """
  Bexio Tax Module.
  """

  @typedoc """
  Bexio Tax

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:uuid` - the uuid of the tax
    * `:name` - the internal name (use `:display_name` as the representation value)
    * `:code` - the tax code, also used within `:display_name`
    * `:digit` - digit which references the tax to the vat digit
    * `:type` - the tax type
    * `:account_id` - the id of the associated account, references an account object
    * `:value` the tax percentage
    * `:net_tax_value` - the net tax percentage (this field is only used, it the tax has the type `net_tax`)
    * `start_year` - the start year from which on the tax is valid. if set to nil every year before end_year
    * `:end_year` - the end year until the tax is valid. if set to nil every year after start_year
    * `:active?` - whether the tax is active
    * `:display_name` - a human readable of the tax, including the code
  """
  @type t :: %__MODULE__{
          id: integer(),
          uuid: String.t(),
          name: String.t(),
          code: String.t(),
          digit: String.t(),
          type:
            :net_tax
            | :non_consideration_sales_tax
            | :pre_customs_tax_investment
            | :pre_customs_tax_material
            | :pre_regards_tax_investment
            | :pre_regards_tax_material
            | :pre_tax_investment
            | :pre_tax_material
            | :sales_tax,
          account_id: integer(),
          tax_settlement_type: String.t() | nil,
          value: float(),
          net_tax_value: float() | nil,
          start_year: pos_integer() | nil,
          end_year: pos_integer() | nil,
          active?: boolean(),
          display_name: String.t()
        }
  @enforce_keys [
    :id,
    :uuid,
    :name,
    :code,
    :digit,
    :type,
    :account_id,
    :value,
    :active?,
    :display_name
  ]
  defstruct [
    :id,
    :uuid,
    :name,
    :code,
    :digit,
    :type,
    :account_id,
    :tax_settlement_type,
    :value,
    :net_tax_value,
    :start_year,
    :end_year,
    :active?,
    :display_name
  ]
end
