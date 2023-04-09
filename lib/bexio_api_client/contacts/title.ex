defmodule BexioApiClient.Contacts.Title do
  @moduledoc """
  Bexio Title Module.
  """

  @typedoc """
  Bexio Title

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - Name of the title
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          name: String.t()
        }
  @enforce_keys [:id, :name]
  defstruct [:id, :name]
end
