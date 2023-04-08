defmodule BexioApiClient.Contacts.AdditionalAddress do
  @moduledoc """
  Bexio Additional Address Module.
  """

  @typedoc """
  Bexio Additional Address.

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - name
    * `:address` - street and additional address information
    * `:postcode` - postal code / zip
    * `:city` - city
    * `:country_id` - reference to a TODO: country object
    * `:subject` - title for the address
    * `:description` - full description of the address (internal)
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          address: String.t(),
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
    :address,
    :postcode,
    :city,
    :country_id,
    :subject,
    :description
  ]
end
