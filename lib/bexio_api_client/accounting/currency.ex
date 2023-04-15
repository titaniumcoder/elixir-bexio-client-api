defmodule BexioApiClient.Accounting.Currency do
  @moduledoc """
  Bexio Currency Module.
  """

  @typedoc """
  Bexio Currency

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - Currency Name
    * `:round_factor` - How to round the given currency
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          round_factor: float()
        }
  @enforce_keys [:id, :name, :round_factor]
  defstruct [:id, :name, :round_factor]
end
