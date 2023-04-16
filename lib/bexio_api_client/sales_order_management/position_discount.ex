defmodule BexioApiClient.SalesOrderManagement.PositionDiscount do
  @moduledoc """
  Discount Position (KbPositionDiscount)
  """

  @typedoc """
  Discount Position

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:text` - text
    * `:value` - discount value
    * `:discount_total` - discount total
    * `:percentual?` - whether the discount is an amount or a percentage of the total amount
  """
  @type t :: %__MODULE__{
          id: integer(),
          text: String.t(),
          percentual?: boolean(),
          value: Decimal.t(),
          discount_total: Decimal.t()
        }
  @enforce_keys [
    :text,
    :percentual?,
    :value
  ]
  defstruct [
    :id,
    :text,
    :percentual?,
    :value,
    :discount_total
  ]

  @doc """
  Create a new record.
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        text: "",
        percentual?: true,
        value: Decimal.new(0),
        discount_total: Decimal.new(0)
      },
      attrs
    )
  end
end
