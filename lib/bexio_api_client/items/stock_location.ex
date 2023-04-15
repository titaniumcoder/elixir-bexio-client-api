defmodule BexioApiClient.Items.StockLocation do
  @moduledoc """
  Bexio Stock Location Module.
  """

  @typedoc """
  Bexio Stock Location
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t()
        }
  @enforce_keys [:id, :name]
  defstruct [:id, :name]
end
