defmodule BexioApiClient.Purchase.PurchaseOrder do
  @moduledoc """
  Purchase order (v3 API)
  """

  @typedoc """
  Purchase order (v3 API).

  ## Fields:

    * `:document_nr` - document number, `nil` means the number is assigned automatically
    * `:logopaper_id` - deprecated by bexio in favor of `:template_slug`
    * `:language` - the full language object as returned by the API
    * `:currency` - the full currency object as returned by the API
    * `:mwst_type` - `:included` (tax is included in the total price), `:excluded` (tax is excluded
      from the total price) or `:exempt` (no tax is charged)
    * `:mwst_is_net?` - this value affects the total if `:mwst_type` has been set to `:excluded`;
      `false` - taxes are included in the total, `true` - taxes will be added to the total
    * `:delivery_address_type` - `:contact_address` or `:manual`
    * `:kb_item_status_id` - references the status of the document
    * `:api_reference` - this field can only be read and edited by the api; it can be used to save
      references to other systems
    * `:custom_translations` - custom translations as returned by the API
    * `:positions` - the line items grouped by required, optional and discount positions; this
      library does not parse positions, they are kept as returned by the API (see
      docs/reference/UNTRUTHS.md)
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          document_nr: String.t() | nil,
          kb_payment_template_id: integer() | nil,
          payment_type_id: integer() | nil,
          title: String.t() | nil,
          contact_id: integer() | nil,
          contact_sub_id: integer() | nil,
          template_slug: String.t() | nil,
          user_id: integer() | nil,
          project_id: integer() | nil,
          logopaper_id: integer() | nil,
          language: map() | nil,
          language_id: integer() | nil,
          bank_account_id: integer() | nil,
          currency: map() | nil,
          currency_id: integer() | nil,
          header: String.t() | nil,
          footer: String.t() | nil,
          total_rounding_difference: float() | nil,
          mwst_type: :included | :excluded | :exempt | nil,
          mwst_is_net?: boolean() | nil,
          compact_view?: boolean() | nil,
          show_position_taxes?: boolean() | nil,
          salesman_user_id: integer() | nil,
          valid_from: Date.t() | nil,
          valid_to: Date.t() | nil,
          delivery_address_type: :contact_address | :manual | nil,
          contact_address_manual: String.t() | nil,
          delivery_address_manual: String.t() | nil,
          nb_decimals_amount: integer() | nil,
          nb_decimals_price: integer() | nil,
          kb_item_status_id: integer() | nil,
          terms_of_payment_text: String.t() | nil,
          reference: String.t() | nil,
          api_reference: String.t() | nil,
          mail: String.t() | nil,
          viewed_by_client_at: Date.t() | nil,
          valid_until: Date.t() | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil,
          custom_translations: map() | nil,
          date_format: String.t() | nil,
          positions: map() | nil
        }
  @enforce_keys []
  defstruct [
    :id,
    :document_nr,
    :kb_payment_template_id,
    :payment_type_id,
    :title,
    :contact_id,
    :contact_sub_id,
    :template_slug,
    :user_id,
    :project_id,
    :logopaper_id,
    :language,
    :language_id,
    :bank_account_id,
    :currency,
    :currency_id,
    :header,
    :footer,
    :total_rounding_difference,
    :mwst_type,
    :mwst_is_net?,
    :compact_view?,
    :show_position_taxes?,
    :salesman_user_id,
    :valid_from,
    :valid_to,
    :delivery_address_type,
    :contact_address_manual,
    :delivery_address_manual,
    :nb_decimals_amount,
    :nb_decimals_price,
    :kb_item_status_id,
    :terms_of_payment_text,
    :reference,
    :api_reference,
    :mail,
    :viewed_by_client_at,
    :valid_until,
    :created_at,
    :updated_at,
    :custom_translations,
    :date_format,
    :positions
  ]

  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        document_nr: nil,
        nb_decimals_amount: 2,
        nb_decimals_price: 2
      },
      attrs
    )
  end
end
