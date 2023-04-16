defmodule BexioApiClient.Others.FictionalUser do
  @moduledoc """
  Bexio Fictional User Module.
  """

  @typedoc """
  Bexio Fictional User.
  """
  @type t :: %__MODULE__{
          id: integer(),
          salutation_type: :male | :female | nil,
          firstname: String.t(),
          lastname: String.t(),
          email: String.t(),
          title_id: integer() | nil
        }
  @enforce_keys [:id, :email, :firstname, :lastname, :salutation_type]
  defstruct [:id, :salutation_type, :firstname, :lastname, :email, :title_id]
end
