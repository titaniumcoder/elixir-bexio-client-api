defmodule BexioApiClient.Banking.PaymentRecipientAddress do
  @moduledoc """
  Address of the recipient of a bexio payment.
  """

  @typedoc """
  Address of a payment recipient.

  ## Fields:

    * `:street_name` - street name of the recipient address
    * `:house_number` - house number of the recipient address
    * `:zip` - zip code of the recipient address
    * `:city` - city of the recipient address
    * `:country_code` - country code of the recipient address
  """
  @type t :: %__MODULE__{
          street_name: String.t() | nil,
          house_number: String.t() | nil,
          zip: String.t() | nil,
          city: String.t() | nil,
          country_code: String.t() | nil
        }
  defstruct [:street_name, :house_number, :zip, :city, :country_code]
end
