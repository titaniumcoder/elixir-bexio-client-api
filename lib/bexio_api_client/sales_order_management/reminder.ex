defmodule BexioApiClient.SalesOrderManagement.Reminder do
  @moduledoc """
  Reminder of an invoice
  """

  @typedoc """
  Reminder of an invoice

  ## Fields:

    * `:kb_invoice_id` - the invoice the reminder belongs to
    * `:title` - title of the reminder
    * `:valid_from` - date the reminder is valid from
    * `:valid_to` - date the reminder is valid until
    * `:reminder_period_in_days` - period of the reminder in days
    * `:reminder_level` - level of the reminder
    * `:show_positions?` - whether the positions are shown on the reminder
    * `:remaining_price` - remaining price of the invoice
    * `:received_total` - total already received for the invoice
    * `:sent?` - whether the reminder is sent
    * `:header` - header text of the reminder
    * `:footer` - footer text of the reminder
  """
  @type t :: %__MODULE__{
          id: integer(),
          kb_invoice_id: integer(),
          title: String.t(),
          valid_from: Date.t(),
          valid_to: Date.t() | nil,
          reminder_period_in_days: integer(),
          reminder_level: integer(),
          show_positions?: boolean(),
          remaining_price: Decimal.t(),
          received_total: Decimal.t(),
          sent?: boolean(),
          header: String.t() | nil,
          footer: String.t() | nil
        }
  @enforce_keys [
    :id,
    :kb_invoice_id,
    :title,
    :valid_from,
    :reminder_period_in_days,
    :reminder_level,
    :show_positions?,
    :remaining_price,
    :received_total,
    :sent?
  ]
  defstruct [
    :id,
    :kb_invoice_id,
    :title,
    :valid_from,
    :valid_to,
    :reminder_period_in_days,
    :reminder_level,
    :show_positions?,
    :remaining_price,
    :received_total,
    :sent?,
    :header,
    :footer
  ]

  @doc """
  Create a new reminder
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        kb_invoice_id: nil,
        title: "",
        valid_from: Date.utc_today(),
        valid_to: nil,
        reminder_period_in_days: 30,
        reminder_level: 1,
        show_positions?: true,
        remaining_price: Decimal.new(0),
        received_total: Decimal.new(0),
        sent?: false,
        header: nil,
        footer: nil
      },
      attrs
    )
  end
end
