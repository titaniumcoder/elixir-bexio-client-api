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
    User,
    FictionalUser
  }

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @doc """
  Fetch a list of company profiles.
  """
  @spec fetch_company_profiles(client :: Tesla.Client.t()) ::
          {:ok, [CompanyProfile.t()]} | {:error, any()}
  def fetch_company_profiles(client) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/company_profile")
      end,
      &map_from_company_profiles/2
    )
  end

  @doc """
  Fetch a single company profile
  """
  @spec fetch_company_profile(client :: Tesla.Client.t(), id :: non_neg_integer()) ::
          {:ok, CompanyProfile.t()} | {:error, any()}
  def fetch_company_profile(client, id) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/company_profile/#{id}")
      end,
      &map_from_company_profile/2
    )
  end

  defp map_from_company_profiles(company_profiles, _env),
    do: Enum.map(company_profiles, &map_from_company_profile/1)

  defp map_from_company_profile(
         %{
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
         },
         _env \\ nil
       ) do
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

  @doc """
  Fetch a list of countries.
  """
  @spec fetch_countries(client :: Tesla.Client.t()) ::
          {:ok, [Country.t()]} | {:error, any()}
  def fetch_countries(client) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/country")
      end,
      &map_from_countries/2
    )
  end

  @doc """
  Search countries via query.
  The following search fields are supported:

  * name
  * name_short
  """
  @spec search_countries(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Country.t()]} | {:error, any()}
  def search_countries(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(client, "/2.0/country/search", criteria, query: opts_to_query(opts))
      end,
      &map_from_countries/2
    )
  end

  @doc """
  Fetch a single country
  """
  @spec fetch_country(client :: Tesla.Client.t(), id :: non_neg_integer()) ::
          {:ok, Country.t()} | {:error, any()}
  def fetch_country(client, id) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/country/#{id}")
      end,
      &map_from_country/2
    )
  end

  defp map_from_countries(countries, _env), do: Enum.map(countries, &map_from_country/1)

  defp map_from_country(
         %{
           "id" => id,
           "name" => name,
           "name_short" => name_short,
           "iso3166_alpha2" => iso3166_alpha2
         },
         _env \\ nil
       ) do
    %Country{
      id: id,
      name: name,
      name_short: name_short,
      iso3166_alpha2: iso3166_alpha2
    }
  end

  @doc """
  Fetch a list of languages.
  """
  @spec fetch_languages(client :: Tesla.Client.t()) ::
          {:ok, [Language.t()]} | {:error, any()}
  def fetch_languages(client) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/language")
      end,
      &map_from_languages/2
    )
  end

  @doc """
  Search languages via query.
  The following search fields are supported:

  * name
  * iso_639_1
  """
  @spec search_languages(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Language.t()]} | {:error, any()}
  def search_languages(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(client, "/2.0/language/search", criteria, query: opts_to_query(opts))
      end,
      &map_from_languages/2
    )
  end

  defp map_from_languages(languages, _env), do: Enum.map(languages, &map_from_language/1)

  defp map_from_language(
         %{
           "id" => id,
           "name" => name,
           "decimal_point" => decimal_point,
           "thousands_separator" => thousands_separator,
           "date_format_id" => date_format_id_bexio,
           "date_format" => date_format,
           "iso_639_1" => iso_639_1
         },
         _env \\ nil
       ) do
    %Language{
      id: id,
      name: name,
      decimal_point: decimal_point,
      thousands_separator: thousands_separator,
      date_format: date_format,
      date_format_id: date_format_id(date_format_id_bexio),
      iso_639_1: iso_639_1
    }
  end

  defp date_format_id(1), do: :dmy
  defp date_format_id(2), do: :mdy

  @doc """
  Fetch a list of users.
  """
  @spec fetch_users(client :: Tesla.Client.t()) ::
          {:ok, [User.t()]} | {:error, any()}
  def fetch_users(client) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/3.0/users")
      end,
      &map_from_users/2
    )
  end

  @doc """
  Fetch a single user.
  """
  @spec fetch_user(client :: Tesla.Client.t(), user_id :: non_neg_integer()) ::
          {:ok, [User.t()]} | {:error, any()}
  def fetch_user(client, user_id) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/3.0/users/#{user_id}")
      end,
      &map_from_user/2
    )
  end

  @doc """
  Fetch a list of finctional users.
  """
  @spec fetch_fictional_users(client :: Tesla.Client.t()) ::
          {:ok, [FictionalUser.t()]} | {:error, any()}
  def fetch_fictional_users(client) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/3.0/fictional_users")
      end,
      &map_from_fictional_users/2
    )
  end

  @doc """
  Fetch a finctional user.
  """
  @spec fetch_fictional_user(client :: Tesla.Client.t(), id :: integer()) ::
          {:ok, FictionalUser.t()} | {:error, any()}
  def fetch_fictional_user(client, id) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/3.0/fictional_users/#{id}")
      end,
      &map_from_fictional_user/2
    )
  end

  @doc """
  Create a fictional user, the id of the fictional user will be ignored!
  """
  @spec create_fictional_user(client :: Tesla.Client.t(), finctional_user :: FictionalUser.t()) ::
          {:ok, FictionalUser.t()} | {:error, any()}
  def create_fictional_user(client, fictional_user) do
    bexio_body_handling(
      fn ->
        Tesla.post(
          client,
          "/3.0/fictional_users",
          Map.take(fictional_user, [:salutation_type, :firstname, :lastname, :email, :title_id])
        )
      end,
      &map_from_fictional_user/2
    )
  end

  @doc """
  Create a fictional user
  """
  @spec update_fictional_user(client :: Tesla.Client.t(), fictional_user :: FictionalUser.t()) ::
          {:ok, FictionalUser.t()} | {:error, any()}
  def update_fictional_user(client, fictional_user) do
    bexio_body_handling(
      fn ->
        Tesla.patch(
          client,
          "/3.0/fictional_users/#{fictional_user.id}",
          Map.take(fictional_user, [:salutation_type, :firstname, :lastname, :email, :title_id])
        )
      end,
      &map_from_fictional_user/2
    )
  end

  @doc """
  Create a fictional user
  """
  @spec delete_fictional_user(client :: Tesla.Client.t(), id :: integer()) ::
          {:ok, true | false} | {:error, any()}
  def delete_fictional_user(client, id) do
    bexio_body_handling(
      fn ->
        Tesla.delete(client, "/3.0/fictional_users/#{id}")
      end,
      fn
        %{"success" => true}, _env -> true
        _, _ -> false
      end
    )
  end

  defp map_from_users(users, _env), do: Enum.map(users, &map_from_user/1)

  defp map_from_user(
         %{
           "id" => id,
           "salutation_type" => salutation_type,
           "firstname" => firstname,
           "lastname" => lastname,
           "email" => email,
           "is_superadmin" => superadmin?,
           "is_accountant" => accountant?
         },
         _env \\ nil
       ) do
    %User{
      id: id,
      salutation_type: String.to_atom(salutation_type),
      firstname: firstname,
      lastname: lastname,
      email: email,
      superadmin?: superadmin?,
      accountant?: accountant?
    }
  end

  defp map_from_fictional_users(fictional_users, _env),
    do: Enum.map(fictional_users, &map_from_fictional_user/1)

  defp map_from_fictional_user(
         %{
           "id" => id,
           "salutation_type" => salutation_type,
           "firstname" => firstname,
           "lastname" => lastname,
           "email" => email,
           "title_id" => title_id
         },
         _env \\ nil
       ) do
    %FictionalUser{
      id: id,
      salutation_type: String.to_atom(salutation_type),
      firstname: firstname,
      lastname: lastname,
      email: email,
      title_id: title_id
    }
  end

  @doc """
  Get access information of logged in user
  """
  @spec get_access_information(client :: Tesla.Client.t()) ::
          {:ok, FictionalUser.t()} | {:error, any()}
  def get_access_information(client) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/3.0/permissions")
      end,
      &map_from_permission_response/2
    )
  end

  defp map_from_permission_response(
         %{"components" => components, "permissions" => permissions},
         _env
       ) do
    %Permission{
      components: components,
      permissions: permissions |> Enum.map(&map_permission/1) |> Enum.into(%{})
    }
  end

  defp map_permission({k, properties}) do
    map_part(String.to_atom(k), properties, %{})
  end

  defp map_part(k, %{"activation" => activation} = map, acc) do
    map_part(k, Map.delete(map, "activation"), Map.put(acc, :activation, enabled(activation)))
  end

  defp map_part(k, %{"edit" => edit} = map, acc) do
    map_part(k, Map.delete(map, "edit"), Map.put(acc, :edit, restriction(edit)))
  end

  defp map_part(k, %{"view" => view} = map, acc) do
    map_part(k, Map.delete(map, "view"), Map.put(acc, :view, restriction(view)))
  end

  defp map_part(k, %{"show" => show} = map, acc) do
    map_part(k, Map.delete(map, "show"), Map.put(acc, :show, restriction(show)))
  end

  defp map_part(k, %{}, acc), do: {k, acc}

  def enabled("disabled"), do: :disabled
  def enabled("enabled"), do: :enabled

  def restriction("none"), do: :none
  def restriction("all"), do: :all
  def restriction("own"), do: :own
end
