defmodule BexioApiClient.SalesOrderManagement.PositionText do
  @moduledoc """
  Text Position (KbPositionText)
  """

  @typedoc """
  Text Position

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:show_pos_nr?` - show position number
    * `:pos` - position
    * `:optional?` - is the position optional?
    * `:text` - text for the subtotal
    * `:internal_pos` - Internal position id
    * `:parent_id - if exists or nil

  """
  @type t :: %__MODULE__{
          id: integer(),
          text: String.t(),
          pos: integer() | nil,
          show_pos_nr?: boolean(),
          internal_pos: integer(),
          optional?: boolean(),
          parent_id: integer() | nil
        }
  @enforce_keys [:text, :show_pos_nr?, :optional?]
  defstruct [:id, :text, :pos, :show_pos_nr?, :internal_pos, :optional?, :parent_id]

  @doc """
  Create a new record.
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
    %__MODULE__{
      text: "",
      show_pos_nr?: false,
      optional?: false
    }, attrs)
  end
end
