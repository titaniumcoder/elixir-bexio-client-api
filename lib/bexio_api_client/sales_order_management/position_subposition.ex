defmodule BexioApiClient.SalesOrderManagement.PositionSubposition do
  @moduledoc """
  Subposition Position (KbPositionSubposition)
  """

  @typedoc """
  Subposition Position

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:text` - text
    * `:pos` - position
    * `:internal_pos` - internal position
    * `:show_pos_nr``? - whether to show the position numbers
    * `:optional?` - is the position optional
    * `:parent_id` - possible parent element
  """
  @type t :: %__MODULE__{
          id: integer(),
          text: String.t(),
          pos: integer() | nil,
          internal_pos: integer(),
          show_pos_nr?: boolean(),
          optional?: boolean(),
          total_sum: Decimal.t(),
          show_pos_prices?: boolean(),
          parent_id: pos_integer() | nil
        }
  @enforce_keys [
    :id,
    :text,
    :internal_pos,
    :show_pos_nr?,
    :optional?,
    :total_sum,
    :show_pos_prices?
  ]
  defstruct [
    :id,
    :text,
    :pos,
    :internal_pos,
    :show_pos_nr?,
    :optional?,
    :total_sum,
    :show_pos_prices?,
    :parent_id
  ]

  @doc """
  Create a new record.
  """
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        text: "",
        pos: 0,
        internal_pos: 0,
        show_pos_nr?: false,
        total_sum: Decimal.new(0),
        show_pos_prices?: false,
        optional?: false,
        parent_id: nil
      },
      attrs
    )
  end
end
