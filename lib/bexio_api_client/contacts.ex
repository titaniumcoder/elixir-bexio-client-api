defmodule BexioApiClient.Contacts do
  @moduledoc """
  Bexio API for the contacts part of the API.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria
  alias BexioApiClient.Contacts.Contact

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  defp contact_opts_to_query(show_archived, opts) do
    opts = opts_to_query(opts)

    if show_archived == nil do
      opts
    else
      Keyword.put(opts, :show_archived, show_archived)
    end
  end

  @doc """
  Fetch a list of contacts.

  ## Arguments:
    * `:opts` - paging and ordering options
      * `:show_archived` - Show archived elements only,
  """
  @spec fetch_contacts(
          client :: Tesla.Client.t(),
          show_archived :: boolean(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Contact.t()]} | {:error, any()}
  def fetch_contacts(client, show_archived \\ false, opts \\ []) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/contact", query: contact_opts_to_query(show_archived, opts))
      end,
      &map_from_clients/2
    )
  end

  @doc """
  Search contacts via query.
  The following search fields are supported:

  * id
  * name_1
  * name_2
  * nr
  * address
  * mail
  * mail_second
  * postcode
  * city
  * country_id
  * contact_group_ids
  * contact_type_id
  * updated_at
  * user_id
  * phone_fixed
  * phone_mobile
  """
  @spec search_contacts(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          show_archived :: boolean(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Contact.t()]} | {:error, any()}
  def search_contacts(
        client,
        criteria,
        show_archived \\ false,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(client, "/2.0/contact/search", criteria,
          query: contact_opts_to_query(show_archived, opts)
        )
      end,
      &map_from_clients/2
    )
  end

  @doc """
  This action fetches a single contact
  """
  @spec fetch_contact(
          client :: Tesla.Client.t(),
          contact_id :: pos_integer(),
          show_archived :: boolean() | nil
        ) :: {:ok, Contact.t()} | {:error, any()}
  def fetch_contact(
        client,
        contact_id,
        show_archived \\ nil
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/contact/#{contact_id}", query: [show_archived: show_archived])
      end,
      &map_from_client/2
    )
  end

  defp map_from_clients(clients, _env), do: Enum.map(clients, &map_from_client/1)

  defp map_from_client(
         %{
           "id" => id,
           "nr" => nr,
           "contact_type_id" => contact_type_id,
           "name_1" => name_1,
           "name_2" => name_2,
           "salutation_id" => salutation_id,
           "salutation_form" => salutation_form,
           "title_id" => title_id,
           "birthday" => birthday,
           "address" => address,
           "postcode" => postcode,
           "city" => city,
           "country_id" => country_id,
           "mail" => mail,
           "mail_second" => mail_second,
           "phone_fixed" => phone_fixed,
           "phone_fixed_second" => phone_fixed_second,
           "phone_mobile" => phone_mobile,
           "fax" => fax,
           "url" => url,
           "skype_name" => skype_name,
           "remarks" => remarks,
           "language_id" => language_id,
           "contact_group_ids" => contact_group_ids,
           "contact_branch_ids" => contact_branch_ids,
           "user_id" => user_id,
           "owner_id" => owner_id,
           "updated_at" => updated_at
         },
         _env \\ nil
       ) do
    %Contact{
      id: id,
      nr: String.to_integer(nr),
      contact_type: contact_type(contact_type_id),
      name_1: name_1,
      name_2: name_2,
      salutation_id: salutation_id,
      salutation_form: salutation_form,
      title_id: title_id,
      birthday: to_date(birthday),
      address: address,
      postcode: postcode,
      city: city,
      country_id: country_id,
      mail: mail,
      mail_second: mail_second,
      phone_fixed: phone_fixed,
      phone_fixed_second: phone_fixed_second,
      phone_mobile: phone_mobile,
      fax: fax,
      url: url,
      skype_name: skype_name,
      remarks: remarks,
      language_id: language_id,
      contact_group_ids: string_to_array(contact_group_ids),
      contact_branch_ids: string_to_array(contact_branch_ids),
      user_id: user_id,
      owner_id: owner_id,
      updated_at: to_datetime(updated_at)
    }
  end

  defp contact_type(1), do: :company
  defp contact_type(2), do: :person

  ### Bexio API for the contact relations part of the API.

  alias BexioApiClient.Contacts.ContactRelation

  @doc """
  Fetch a list of contacts relations.
  """
  @spec fetch_contact_relations(
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [ContactRelation.t()]} | {:error, any()}
  def fetch_contact_relations(
        client,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/contact_relation", query: opts_to_query(opts))
      end,
      &map_from_client_relations/2
    )
  end

  @doc """
  Search contacts groups via query.
  The following search fields are supported:

  * contact_id
  * contact_sub_id
  * updated_at
  """
  @spec search_contact_relations(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [ContactRelation.t()]} | {:error, any()}
  def search_contact_relations(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(client, "/2.0/contact_relation/search", criteria, query: opts_to_query(opts))
      end,
      &map_from_client_relations/2
    )
  end

  @doc """
  This action fetches a single contact relation
  """
  @spec fetch_contact_relation(
          client :: Tesla.Client.t(),
          contact_relation_id :: pos_integer()
        ) :: {:ok, ContactRelation.t()} | {:error, any()}
  def fetch_contact_relation(
        client,
        contact_relation_id
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/contact_relation/#{contact_relation_id}")
      end,
      &map_from_client_relation/2
    )
  end

  defp map_from_client_relations(client_relations, _env),
    do: Enum.map(client_relations, &map_from_client_relation/1)

  defp map_from_client_relation(
         %{
           "id" => id,
           "contact_id" => contact_id,
           "contact_sub_id" => contact_sub_id,
           "description" => description,
           "updated_at" => updated_at
         },
         _env \\ nil
       ) do
    %ContactRelation{
      id: id,
      contact_id: contact_id,
      contact_sub_id: contact_sub_id,
      description: description,
      updated_at: to_datetime(updated_at)
    }
  end

  ### Bexio API for the contact group part of the API.

  @doc """
  Fetch a list of contacts groups.
  """
  @spec fetch_contact_groups(
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | {:error, any()}
  def fetch_contact_groups(
        client,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/contact_group", query: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  Search contact groups via query.
  The following search fields are supported:

  * name
  """
  @spec search_contact_groups(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | {:error, any()}
  def search_contact_groups(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(client, "/2.0/contact_group/search", criteria, query: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  This action fetches a single contact group
  """
  @spec fetch_contact_group(
          client :: Tesla.Client.t(),
          contact_group_id :: pos_integer()
        ) :: {:ok, %{id: integer(), name: String.t()}} | {:error, any()}
  def fetch_contact_group(
        client,
        contact_group_id
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/contact_group/#{contact_group_id}")
      end,
      &id_name/2
    )
  end

  ### Bexio API for the contact sector part of the API.

  @doc """
  Fetch a list of contacts sectors.
  """
  @spec fetch_contact_sectors(
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | {:error, any()}
  def fetch_contact_sectors(
        client,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/contact_branch", query: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  Search contact sectors via query.
  The following search fields are supported:

  * name
  """
  @spec search_contact_sectors(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | {:error, any()}
  def search_contact_sectors(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(client, "/2.0/contact_branch/search", criteria, query: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  ### Bexio API for the additional address part of the API.

  alias BexioApiClient.Contacts.AdditionalAddress

  @doc """
  Fetch a list of additional addresses.
  """
  @spec fetch_additional_addresses(
          client :: Tesla.Client.t(),
          contact_id :: integer(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [AdditionalAddress.t()]} | {:error, any()}
  def fetch_additional_addresses(
        client,
        contact_id,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/contact/#{contact_id}/additional_address",
          query: opts_to_query(opts)
        )
      end,
      &map_from_additional_addresses/2
    )
  end

  @doc """
  Search additional addresses via query.
  The following search fields are supported:

  * name
  * address
  * postcode
  * city
  * country_id
  * subject
  """
  @spec search_additional_addresses(
          client :: Tesla.Client.t(),
          contact_id :: integer(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [AdditionalAddress.t()]} | {:error, any()}
  def search_additional_addresses(
        client,
        contact_id,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(client, "/2.0/contact/#{contact_id}/additional_address/search", criteria,
          query: opts_to_query(opts)
        )
      end,
      &map_from_additional_addresses/2
    )
  end

  @doc """
  This action fetches a single additional address
  """
  @spec fetch_additional_address(
          client :: Tesla.Client.t(),
          contact_id :: non_neg_integer(),
          additional_address_id :: non_neg_integer()
        ) :: {:ok, AdditionalAddress.t()} | {:error, any()}
  def fetch_additional_address(
        client,
        contact_id,
        additional_address_id
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(
          client,
          "/2.0/contact/#{contact_id}/additional_address/#{additional_address_id}"
        )
      end,
      &map_from_additional_address/2
    )
  end

  defp map_from_additional_addresses(addresses, _env),
    do: Enum.map(addresses, &map_from_additional_address/1)

  defp map_from_additional_address(
         %{
           "id" => id,
           "name" => name,
           "address" => address,
           "postcode" => postcode,
           "city" => city,
           "country_id" => country_id,
           "subject" => subject,
           "description" => description
         },
         _env \\ nil
       ) do
    %AdditionalAddress{
      id: id,
      name: name,
      address: address,
      postcode: postcode,
      city: city,
      country_id: country_id,
      subject: subject,
      description: description
    }
  end

  ### Bexio API for salutations

  @doc """
  Fetch a list of additional addresses.
  """
  @spec fetch_salutations(
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | {:error, any()}
  def fetch_salutations(
        client,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/salutation", query: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  Search salutations via query.
  The following search fields are supported:

  * name
  """
  @spec search_salutations(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | {:error, any()}
  def search_salutations(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(client, "/2.0/salutation/search", criteria, query: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  This action fetches a single salutation
  """
  @spec fetch_salutation(
          client :: Tesla.Client.t(),
          salutation_id :: non_neg_integer()
        ) :: {:ok, %{id: integer(), name: String.t()}} | {:error, any()}
  def fetch_salutation(
        client,
        salutation_id
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(
          client,
          "/2.0/salutation/#{salutation_id}"
        )
      end,
      &id_name/2
    )
  end

  ### Bexio API for the titles part of the API.

  @doc """
  Fetch a list of titles.
  """
  @spec fetch_titles(
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | {:error, any()}
  def fetch_titles(
        client,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/title", query: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  Search title via query.
  The following search fields are supported:

  * name
  """
  @spec search_titles(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | {:error, any()}
  def search_titles(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(client, "/2.0/title/search", criteria, query: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  This action fetches a single title
  """
  @spec fetch_title(
          client :: Tesla.Client.t(),
          title_id :: non_neg_integer()
        ) :: {:ok, %{id: integer(), name: String.t()}} | {:error, any()}
  def fetch_title(
        client,
        title_id
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(
          client,
          "/2.0/title/#{title_id}"
        )
      end,
      &id_name/2
    )
  end
end
