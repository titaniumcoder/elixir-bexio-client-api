defmodule BexioApiClient.Others.User do
  @moduledoc """
  Bexio User Module.
  """

  @typedoc """
  Bexio User.
  """
  @type t :: %__MODULE__{
          id: integer(),
          salutation_type: :male | :female | nil,
          firstname: String.t() | nil,
          lastname: String.t() | nil,
          email: String.t(),
          superadmin?: boolean(),
          accountant?: boolean()
        }
  @enforce_keys [:id, :email, :superadmin?, :accountant?]
  defstruct [:id, :salutation_type, :firstname, :lastname, :email, :superadmin?, :accountant?]
end
