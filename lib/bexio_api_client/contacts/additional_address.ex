defmodule BexioApiClient.Contacts.AdditionalAddress do
  @moduledoc """
  Bexio Additional Address Module.
  """

  @typedoc """
  Bexio Additional Address.

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - name
    * `:name_addition` - addition to the name
    * `:address` - street and additional address information
    * `:street_name` - street name (the `:address` field is deprecated by bexio in favor of the structured address fields)
    * `:house_number` - house number
    * `:address_addition` - additional address information
    * `:postcode` - postal code / zip
    * `:city` - city
    * `:country_id` - reference to a TODO: country object
    * `:subject` - title for the address
    * `:description` - full description of the address (internal)
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          name_addition: String.t() | nil,
          address: String.t(),
          street_name: String.t() | nil,
          house_number: String.t() | nil,
          address_addition: String.t() | nil,
          postcode: String.t(),
          city: String.t(),
          country_id: integer(),
          subject: String.t(),
          description: String.t()
        }
  @enforce_keys [
    :id,
    :name,
    :subject,
    :description
  ]
  defstruct [
    :id,
    :name,
    :name_addition,
    :address,
    :street_name,
    :house_number,
    :address_addition,
    :postcode,
    :city,
    :country_id,
    :subject,
    :description
  ]
end
