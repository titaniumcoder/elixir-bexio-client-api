defmodule BexioApiClient.Purchase.DocumentNumber do
  @moduledoc """
  Result of a document number validation for purchase documents (bills, expenses).
  """

  @typedoc """
  Result of a document number validation for purchase documents (bills, expenses).

  ## Fields:

    * `:valid?` - whether the validated document number is available
    * `:next_available_no` - the next available document number
  """
  @type t :: %__MODULE__{
          valid?: boolean(),
          next_available_no: String.t() | nil
        }
  @enforce_keys [:valid?]
  defstruct [
    :valid?,
    :next_available_no
  ]

  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        valid?: false,
        next_available_no: nil
      },
      attrs
    )
  end
end
