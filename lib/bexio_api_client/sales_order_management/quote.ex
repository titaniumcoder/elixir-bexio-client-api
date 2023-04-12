defmodule BexioApiClient.SalesOrderManagement.Quote do
  @moduledoc """
  Quote
  """

  @typedoc """
  Quote
  
  ## Fields:
  
    * `:contact_id` - references a contact object
    * `:contact_sub_id` - references a contact object
    * `:user_id` - references a user object
    * `:project_id` - references a project object
    * `:language_id` - references a language object
    * `:bank_account_id` - references a bank account object
    * `:currency_id` - references a currency object
    * `:payment_type_id` - references a payment type object
    * `:mwst_is_net? ` - this value affects the total if the field mwst_type has been set to `:include`. `false` - taxes are included in the total, `true` - taxes will be added to total
    * `:kb_item_status` is converted from `kb_item_status_id` rest field
    * `:api_reference` - this field can only be read and edited by the api. it can be used to save references to other systems
    * `:template_slug` - references a document template slug
    * `:taxs` - map of percentage as key and absolute values as value
    * `:network_link` - the network link of the quote
  """
  @type t :: %__MODULE__{
          id: integer(),
          document_nr: String.t(),
          title: String.t() | nil,
          contact_id: integer() | nil,
          contact_sub_id: integer() | nil,
          user_id: integer(),
          project_id: integer() | nil,
          language_id: integer(),
          bank_account_id: integer(),
          currency_id: integer(),
          payment_type_id: integer(),
          header: String.t(),
          footer: String.t(),
          total_gross: Decimal.t(),
          total_net: Decimal.t(),
          total_taxes: Decimal.t(),
          total: Decimal.t(),
          total_rounding_difference: float(),
          mwst_type: :including | :excluding | :exempt,
          mwst_is_net?: boolean(),
          show_position_taxes?: boolean(),
          is_valid_from: Date.t(),
          is_valid_until: Date.t(),
          contact_address: String.t(),
          delivery_address_type: integer(),
          delivery_address: String.t(),
          kb_item_status: :draft | :pending | :confirmed | :declined,
          api_reference: String.t() | nil,
          viewed_by_client_at: NaiveDateTime.t() | nil,
          kb_terms_of_payment_template_id: integer() | nil,
          show_total?: boolean(),
          updated_at: NaiveDateTime.t(),
          template_slug: String.t() | nil,
          taxs: list(map()),
          network_link: String.t() | nil
        }
  @enforce_keys [
    :id,
    :document_nr,
    :user_id,
    :language_id,
    :bank_account_id,
    :currency_id,
    :payment_type_id,
    :header,
    :footer,
    :total_gross,
    :total_net,
    :total_taxes,
    :total,
    :total_rounding_difference,
    :mwst_type,
    :mwst_is_net?,
    :show_position_taxes?,
    :is_valid_from,
    :is_valid_until,
    :contact_address,
    :delivery_address_type,
    :delivery_address,
    :kb_item_status,
    :show_total?,
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
    :payment_type_id,
    :header,
    :footer,
    :total_gross,
    :total_net,
    :total_taxes,
    :total,
    :total_rounding_difference,
    :mwst_type,
    :mwst_is_net?,
    :show_position_taxes?,
    :is_valid_from,
    :is_valid_until,
    :contact_address,
    :delivery_address_type,
    :delivery_address,
    :kb_item_status,
    :api_reference,
    :viewed_by_client_at,
    :kb_terms_of_payment_template_id,
    :show_total?,
    :updated_at,
    :template_slug,
    :taxs,
    :network_link
  ]
end
