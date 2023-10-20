defmodule BexioApiClient.SalesOrderManagement.Delivery do
  @moduledoc """
  Delivery
  """

  @typedoc """
  Delivery

  ## Fields:

    * `:contact_id` - references a contact object
    * `:contact_sub_id` - references a contact object
    * `:user_id` - references a user object
    * `:language_id` - references a language object
    * `:bank_account_id` - references a bank account object
    * `:currency_id` - references a currency object
    * `:payment_type_id` - references a payment type object
    * `:mwst_is_net? ` - this value affects the total if the field mwst_type has been set to `:include`. `false` - taxes are included in the total, `true` - taxes will be added to total
    * `:kb_item_status` is converted from `kb_item_status_id` rest field
    * `:api_reference` - this field can only be read and edited by the api. it can be used to save references to other systems
    * `:template_slug` - references a document template slug
    * `:taxs` - map of percentage as key and absolute values as value
    * `:network_link` - the network link of the order
  """
  @type t :: %__MODULE__{
          id: integer(),
          document_nr: String.t(),
          title: String.t() | nil,
          contact_id: integer() | nil,
          contact_sub_id: integer() | nil,
          user_id: integer(),
          language_id: integer(),
          bank_account_id: integer(),
          currency_id: integer(),
          header: String.t(),
          footer: String.t(),
          total_gross: Decimal.t(),
          total_net: Decimal.t(),
          total_taxes: Decimal.t(),
          total: Decimal.t(),
          total_rounding_difference: float(),
          mwst_type: :including | :excluding | :exempt,
          mwst_is_net?: boolean(),
          is_valid_from: Date.t(),
          contact_address: String.t(),
          delivery_address_type: integer(),
          delivery_address: String.t(),
          kb_item_status: :draft | :done | :cancelled,
          api_reference: String.t() | nil,
          updated_at: NaiveDateTime.t(),
          taxs: list(%{percentage: Decimal.t(), value: Decimal.t()})
        }
  @enforce_keys [
    :document_nr,
    :user_id,
    :language_id,
    :bank_account_id,
    :currency_id,
    :header,
    :footer,
    :mwst_type,
    :mwst_is_net?,
    :is_valid_from,
    :contact_address,
    :delivery_address_type,
    :delivery_address,
    :kb_item_status,
    :updated_at,
    :taxs
  ]
  defstruct [
    :id,
    :document_nr,
    :title,
    :contact_id,
    :contact_sub_id,
    :user_id,
    :project_id,
    :language_id,
    :bank_account_id,
    :currency_id,
    :header,
    :footer,
    :total_gross,
    :total_net,
    :total_taxes,
    :total,
    :total_rounding_difference,
    :mwst_type,
    :mwst_is_net?,
    :is_valid_from,
    :contact_address,
    :delivery_address_type,
    :delivery_address,
    :kb_item_status,
    :is_recurring?,
    :api_reference,
    :updated_at,
    :taxs,
    :positions
  ]

  @doc """
  Create a new order
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        document_nr: nil,
        contact_id: nil,
        contact_sub_id: nil,
        user_id: nil,
        project_id: nil,
        language_id: nil,
        bank_account_id: nil,
        currency_id: nil,
        header: "",
        footer: "",
        total_gross: Decimal.new(0),
        total_net: Decimal.new(0),
        total_taxes: Decimal.new(0),
        total: Decimal.new(0),
        total_rounding_difference: 0.0,
        mwst_type: :including,
        mwst_is_net?: true,
        is_valid_from: Date.utc_today(),
        contact_address: "",
        delivery_address_type: 0,
        delivery_address: "",
        kb_item_status: :draft,
        updated_at: NaiveDateTime.local_now(),
        is_recurring?: false,
        taxs: [],
        positions: []
      },
      attrs
    )
  end
end
