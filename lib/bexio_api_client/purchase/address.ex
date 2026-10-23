defmodule BexioApiClient.Purchase.Address do
  @moduledoc """
  Address of a contact as embedded in purchase documents (bills, expenses).
  """

  @typedoc """
  Address of a contact as embedded in purchase documents (bills, expenses).

  ## Fields:

    * `:type` - type of the address as returned by the API (e.g. "PRIVATE", "COMPANY")
  """
  @type t :: %__MODULE__{
          title: String.t() | nil,
          salutation: String.t() | nil,
          firstname_suffix: String.t() | nil,
          lastname_company: String.t() | nil,
          address_line: String.t() | nil,
          postcode: String.t() | nil,
          city: String.t() | nil,
          country_code: String.t() | nil,
          main_contact_id: integer() | nil,
          contact_address_id: integer() | nil,
          type: String.t() | nil
        }
  defstruct [
    :title,
    :salutation,
    :firstname_suffix,
    :lastname_company,
    :address_line,
    :postcode,
    :city,
    :country_code,
    :main_contact_id,
    :contact_address_id,
    :type
  ]
end
