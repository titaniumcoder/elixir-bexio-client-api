defmodule BexioApiClient.Contacts.ContactSector do
  @moduledoc """
  Bexio Contact Sector Module.
  """

  @typedoc """
  Bexio Contact Sector

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - Name of the contact group
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          name: String.t()
        }
  @enforce_keys [:id, :name]
  defstruct [:id, :name]
end
