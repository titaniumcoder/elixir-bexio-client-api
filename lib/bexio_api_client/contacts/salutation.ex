defmodule BexioApiClient.Contacts.Salutation do
  @moduledoc """
  Bexio Salutation Module.
  """

  @typedoc """
  Bexio Salutation

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - Name of the salutation
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          name: String.t()
        }
  @enforce_keys [:id, :name]
  defstruct [:id, :name]
end
