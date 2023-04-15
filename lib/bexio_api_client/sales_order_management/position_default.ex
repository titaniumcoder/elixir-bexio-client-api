defmodule BexioApiClient.SalesOrderManagement.PositionDefault do
  @moduledoc """
  Default Position (KbPositionCustom)
  """

  @typedoc """
  Default Position

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:text` - text
    * `:amount` - amount
    * `:account_id` - References an account object
    * `:unit_id` - References a unit object
    * `:unit_name` - Unit Name
    * `:unit_price` - Unit Price
    * `:discount_in_percent` - Discount in Percentage
    * `:position_total` - Position Total
    * `:tax_id` - References a tax object (only active sales taxes can be used)
    * `:tax_value` - Tax Value
    * `:pos` - Position
    * `:optional?` - is the position optional?
    * `:internal_pos` - Internal position id
    * `:parent_id - if exists or nil

  """
  @type t :: %__MODULE__{
          id: integer(),
          pos: integer(),
          amount: Decimal.t(),
          unit_id: integer(),
          account_id: integer(),
          unit_name: String.t(),
          tax_id: integer(),
          tax_value: Decimal.t(),
          text: String.t(),
          unit_price: Decimal.t(),
          discount_in_percent: Decimal.t(),
          position_total: Decimal.t(),
          internal_pos: integer(),
          optional?: boolean(),
          parent_id: integer() | nil
        }
  @enforce_keys [
    :id,
    :amount,
    :unit_id,
    :account_id,
    :unit_name,
    :tax_id,
    :tax_value,
    :text,
    :unit_price,
    :discount_in_percent,
    :position_total,
    :pos,
    :internal_pos,
    :optional?
  ]
  defstruct [
    :id,
    :amount,
    :unit_id,
    :account_id,
    :unit_name,
    :tax_id,
    :tax_value,
    :text,
    :unit_price,
    :discount_in_percent,
    :position_total,
    :pos,
    :internal_pos,
    :optional?,
    :parent_id
  ]

  @doc """
  Create a new record.
  """
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        amount: Decimal.new(0),
        unit_id: nil,
        account_id: nil,
        unit_name: "",
        tax_id: nil,
        tax_value: Decimal.new(0),
        text: "",
        unit_price: Decimal.new(0),
        discount_in_percent: Decimal.new(0),
        position_total: Decimal.new(0),
        pos: 0,
        internal_pos: 0,
        optional?: false,
        parent_id: nil
      },
      attrs
    )
  end
end
