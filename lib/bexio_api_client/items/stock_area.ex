defmodule BexioApiClient.Items.StockArea do
  @moduledoc """
  Bexio Stock Area Module.
  """

  @typedoc """
  Bexio Stock Area
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t()
        }
  @enforce_keys [:id, :name]
  defstruct [:id, :name]
end
