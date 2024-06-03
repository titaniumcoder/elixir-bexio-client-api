defmodule BexioApiClient.SalesOrderManagement.DocumentSetting do
  @moduledoc """
  Comment
  """

  @typedoc """
  Different Document Settings
  """
  @type t :: %__MODULE__{
          id: integer(),
          text: String.t(),
          kb_item_class: String.t(),
          enumeration_format: String.t(),
          automatic_enumeration?: boolean(),
          yearly_enumeration?: boolean(),
          next_nr: integer(),
          nr_min_length: integer(),
          default_time_period_in_days: integer(),
          default_logopaper_id: integer(),
          default_language_id: integer(),
          default_currency_id: integer(),
          default_client_bank_account_new_id: integer(),
          default_mwst_type: integer(),
          default_mwst_net?: boolean(),
          default_nb_decimals_amount: integer(),
          default_nb_decimals_price: integer(),
          default_show_position_taxes?: boolean(),
          default_title: String.t(),
          default_show_esr_on_same_page?: boolean(),
          default_payment_type_id: integer(),
          kb_terms_of_payment_template_id: integer() | nil,
          default_show_total?: boolean()
        }
  @enforce_keys [
    :id,
    :text,
    :kb_item_class,
    :enumeration_format,
    :automatic_enumeration?,
    :yearly_enumeration?,
    :next_nr,
    :nr_min_length,
    :default_time_period_in_days,
    :default_logopaper_id,
    :default_language_id,
    :default_client_bank_account_new_id,
    :default_currency_id,
    :default_mwst_type,
    :default_mwst_net?,
    :default_nb_decimals_amount,
    :default_nb_decimals_price,
    :default_show_position_taxes?,
    :default_title,
    :default_show_esr_on_same_page?,
    :default_payment_type_id,
    :default_show_total?
  ]
  defstruct [
    :id,
    :text,
    :kb_item_class,
    :enumeration_format,
    :automatic_enumeration?,
    :yearly_enumeration?,
    :next_nr,
    :nr_min_length,
    :default_time_period_in_days,
    :default_logopaper_id,
    :default_language_id,
    :default_client_bank_account_new_id,
    :default_currency_id,
    :default_mwst_type,
    :default_mwst_net?,
    :default_nb_decimals_amount,
    :default_nb_decimals_price,
    :default_show_position_taxes?,
    :default_title,
    :default_show_esr_on_same_page?,
    :default_payment_type_id,
    :kb_terms_of_payment_template_id,
    :default_show_total?
  ]
end
