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
@enforce_keys [:id, :text, :value, :internal_pos, :optional?]
  defstruct [:id, :text, :value, :internal_pos, :optional?, :parent_id]
end
