defmodule BexioApiClient.Items.Item do
  @moduledoc """
  Bexio Items Module.
  """

  @typedoc """
  Bexio Item

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:article_type` - either :physical or :service
    * `stock_nr` - please note that the stock number can only be set if no bookings for this product have been made
  """
  @type t :: %__MODULE__{
          id: integer(),
          user_id: integer(),
          article_type: :physical | :service,
          contact_id: integer() | nil,
          deliverer_code: String.t() | nil,
          deliverer_name: String.t() | nil,
          deliverer_description: String.t() | nil,
          intern_code: String.t(),
          intern_name: String.t(),
          intern_description: String.t() | nil,
          purchase_price: Decimal.t() | nil,
          sale_price: Decimal.t() | nil,
          purchase_total: Decimal.t() | nil,
          sale_total: Decimal.t() | nil,
          currency_id: integer() | nil,
          tax_income_id: integer() | nil,
          tax_id: integer() | nil,
          tax_expense_id: integer() | nil,
          unit_id: integer() | nil,
          stock?: boolean(),
          stock_id: integer() | nil,
          stock_place_id: integer() | nil,
          stock_nr: integer(),
          stock_min_nr: integer(),
          stock_reserved_nr: integer(),
          stock_available_nr: integer(),
          stock_picked_nr: integer(),
          stock_disposed_nr: integer(),
          stock_ordered_nr: integer(),
          width: integer() | nil,
          height: integer() | nil,
          weight: integer() | nil,
          volume: integer() | nil,
          remarks: String.t() | nil,
          delivery_price: Decimal.t() | nil,
          article_group_id: integer() | nil
        }
  @enforce_keys [
    :id,
    :user_id,
    :article_type,
    :intern_code,
    :intern_name,
    :stock?,
    :stock_nr,
    :stock_min_nr,
    :stock_reserved_nr,
    :stock_available_nr,
    :stock_picked_nr,
    :stock_disposed_nr,
    :stock_ordered_nr
  ]
  defstruct [
    :id,
    :user_id,
    :article_type,
    :contact_id,
    :deliverer_code,
    :deliverer_name,
    :deliverer_description,
    :intern_code,
    :intern_name,
    :intern_description,
    :purchase_price,
    :sale_price,
    :purchase_total,
    :sale_total,
    :currency_id,
    :tax_income_id,
    :tax_id,
    :tax_expense_id,
    :unit_id,
    :stock?,
    :stock_id,
    :stock_place_id,
    :stock_nr,
    :stock_min_nr,
    :stock_reserved_nr,
    :stock_available_nr,
    :stock_picked_nr,
    :stock_disposed_nr,
    :stock_ordered_nr,
    :width,
    :height,
    :weight,
    :volume,
    :remarks,
    :delivery_price,
    :article_group_id
  ]

  @doc """
  Create a new article
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        user_id: nil,
        article_type: :service,
        intern_code: nil,
        intern_name: nil,
        stock?: false,
        stock_nr: 0,
        stock_min_nr: 0,
        stock_reserved_nr: 0,
        stock_available_nr: 0,
        stock_picked_nr: 0,
        stock_disposed_nr: 0,
        stock_ordered_nr: 0
      },
      attrs
    )
  end
end
