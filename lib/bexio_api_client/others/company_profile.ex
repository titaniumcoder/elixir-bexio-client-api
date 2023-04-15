defmodule BexioApiClient.Others.CompanyProfile do
  @moduledoc """
  Bexio Company Profile Module.
  """

  @typedoc """
  Bexio Company Profile.
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          address: String.t(),
          address_nr: String.t(),
          postcode: integer(),
          city: String.t(),
          country_id: integer(),
          legal_form:
            :sole_proprietorship
            | :joint_partnership
            | :foundation
            | :corporation
            | :limited_liability_company
            | :association,
          mail: String.t(),
          phone_fixed: String.t(),
          phone_mobile: String.t(),
          fax: String.t(),
          url: String.t(),
          skype_name: String.t(),
          facebook_name: String.t(),
          twitter_name: String.t(),
          description: String.t(),
          ust_id_nr: String.t(),
          mwst_nr: String.t(),
          trade_register_nr: String.t(),
          own_logo?: boolean(),
          public_profile?: boolean(),
          logo_public?: boolean(),
          address_public?: boolean(),
          phone_public?: boolean(),
          mobile_public?: boolean(),
          fax_public?: boolean(),
          mail_public?: boolean(),
          url_public?: boolean(),
          skype_public?: boolean(),
          logo_base64: String.t()
        }
  @enforce_keys [
    :id,
    :name,
    :own_logo?,
    :public_profile?,
    :logo_public?,
    :address_public?,
    :phone_public?,
    :mobile_public?,
    :fax_public?,
    :mail_public?,
    :url_public?,
    :skype_public?
  ]
  defstruct [
    :id,
    :name,
    :address,
    :address_nr,
    :postcode,
    :city,
    :country_id,
    :legal_form,
    :country_name,
    :mail,
    :phone_fixed,
    :phone_mobile,
    :fax,
    :url,
    :skype_name,
    :facebook_name,
    :twitter_name,
    :description,
    :ust_id_nr,
    :mwst_nr,
    :trade_register_nr,
    :own_logo?,
    :public_profile?,
    :logo_public?,
    :address_public?,
    :phone_public?,
    :mobile_public?,
    :fax_public?,
    :mail_public?,
    :url_public?,
    :skype_public?,
    :logo_base64
  ]
end
