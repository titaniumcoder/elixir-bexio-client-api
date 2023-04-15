defmodule BexioApiClient.Others do
  @moduledoc """
  Bexio API for the other endpoints.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria

  alias BexioApiClient.Others.{
    CompanyProfile,
    Country,
    Language,
    Note,
    PaymentType,
    Permission,
    Task,
    Unit,
    User
  }

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @doc """
  Fetch a list of company profiles.
  """
  @spec fetch_company_profiles(client :: Tesla.Client.t()) ::
          {:ok, [CompanyProfile.t()]} | {:error, any()}
  def fetch_company_profiles(client) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/company_profile")
      end,
      &map_from_company_profiles/1
    )
  end

  @doc """
  Fetch a single company profile
  """
  @spec fetch_company_profile(client :: Tesla.Client.t(), id :: non_neg_integer()) ::
          {:ok, CompanyProfile.t()} | {:error, any()}
  def fetch_company_profile(client, id) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/company_profile/#{id}")
      end,
      &map_from_company_profile/1
    )
  end

  defp map_from_company_profiles(company_profiles),
    do: Enum.map(company_profiles, &map_from_company_profile/1)

  defp map_from_company_profile(%{
         "id" => id,
         "name" => name,
         "address" => address,
         "address_nr" => address_nr,
         "postcode" => postcode,
         "city" => city,
         "country_id" => country_id,
         "legal_form" => legal_form,
         "country_name" => country_name,
         "mail" => mail,
         "phone_fixed" => phone_fixed,
         "phone_mobile" => phone_mobile,
         "fax" => fax,
         "url" => url,
         "skype_name" => skype_name,
         "facebook_name" => facebook_name,
         "twitter_name" => twitter_name,
         "description" => description,
         "ust_id_nr" => ust_id_nr,
         "mwst_nr" => mwst_nr,
         "trade_register_nr" => trade_register_nr,
         "has_own_logo" => own_logo?,
         "is_public_profile" => public_profile?,
         "is_logo_public" => logo_public?,
         "is_address_public" => address_public?,
         "is_phone_public" => phone_public?,
         "is_mobile_public" => mobile_public?,
         "is_fax_public" => fax_public?,
         "is_mail_public" => mail_public?,
         "is_url_public" => url_public?,
         "is_skype_public" => skype_public?,
         "logo_base64" => logo_base64
       }) do
    %CompanyProfile{
      id: id,
      name: name,
      address: address,
      address_nr: address_nr,
      postcode: postcode,
      city: city,
      country_id: country_id,
      legal_form: String.to_atom(legal_form),
      country_name: country_name,
      mail: mail,
      phone_fixed: phone_fixed,
      phone_mobile: phone_mobile,
      fax: fax,
      url: url,
      skype_name: skype_name,
      facebook_name: facebook_name,
      twitter_name: twitter_name,
      description: description,
      ust_id_nr: ust_id_nr,
      mwst_nr: mwst_nr,
      trade_register_nr: trade_register_nr,
      own_logo?: own_logo?,
      public_profile?: public_profile?,
      logo_public?: logo_public?,
      address_public?: address_public?,
      phone_public?: phone_public?,
      mobile_public?: mobile_public?,
      fax_public?: fax_public?,
      mail_public?: mail_public?,
      url_public?: url_public?,
      skype_public?: skype_public?,
      logo_base64: logo_base64
    }
  end
end
