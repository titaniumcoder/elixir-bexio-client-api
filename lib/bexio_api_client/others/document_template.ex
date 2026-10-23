defmodule BexioApiClient.Others.DocumentTemplate do
  @moduledoc """
  Bexio Document Template Module.
  """

  @typedoc """
  Bexio Document Template.

  ## Fields:

    * `:template_slug` - slug of the template
    * `:name` - name of the template
    * `:default?` - whether this is the default template
    * `:default_for_document_types` - document types this template is the default for
      (`:type_offer`, `:type_order`, `:type_invoice`, `:type_delivery`,
      `:type_credit_voucher`, `:type_account_statement`, `:type_article_order`;
      unknown values are kept as strings)
  """
  @type t :: %__MODULE__{
          template_slug: String.t(),
          name: String.t(),
          default?: boolean(),
          default_for_document_types: [
            :type_offer
            | :type_order
            | :type_invoice
            | :type_delivery
            | :type_credit_voucher
            | :type_account_statement
            | :type_article_order
            | String.t()
          ]
        }
  @enforce_keys [:template_slug, :name, :default?, :default_for_document_types]
  defstruct [:template_slug, :name, :default?, :default_for_document_types]
end
