defmodule BexioApiClient.SalesOrderManagement.PositionSubtotal do
  @moduledoc """
  Subtotal Position (KbPositionSubtotal)
  """

  @typedoc """
  Subtotal Position

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:text` - text for the subtotal
    * `:value` - Decimal representation of the value
    * `:optional?` - is the position optional?
    * `:internal_pos` - Internal position id
    * `:parent_id - if exists or nil

  """
  @type t :: %__MODULE__{
          id: integer(),
          text: String.t(),
          value: Decimal.t(),
          internal_pos: integer(),
          optional?: boolean(),
          parent_id: integer() | nil
        }
  @enforce_keys [:text, :optional?]
  defstruct [:id, :text, :value, :internal_pos, :optional?, :parent_id]

  @doc """
  Create a new record.
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        text: "",
        value: Decimal.new(0),
        optional?: false
      },
      attrs
    )
  end
end
