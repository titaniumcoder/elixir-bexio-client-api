defmodule BexioApiClient.SalesOrderManagement.PositionText do
  @moduledoc """
  Text Position (KbPositionText)
  """

  @typedoc """
  Text Position

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:show_pos_nr` - show position number
    * `:pos` - position
    * `:optional?` - is the position optional?
    * `:text` - text for the subtotal
    * `:internal_pos` - Internal position id
    * `:parent_id - if exists or nil

  """
  @type t :: %__MODULE__{
    id: integer(),
    text: String.t(),
    pos: String.t() | nil,
    show_pos_nr: boolean(),
    internal_pos: integer(),
    optional?: boolean(),
    parent_id: integer() | nil
  }
@enforce_keys [:id, :text, :internal_pos, :optional?]
  defstruct [:id, :text, :pos, :show_pos_nr, :internal_pos, :optional?, :parent_id]
end
