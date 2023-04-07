defmodule BexioApiClient.Contacts do
  @moduledoc """
  Bexio API for the contacts part of the API.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.GlobalArguments
  alias BexioApiClient.SearchCriteria
  alias BexioApiClient.Contacts.Contact

  @type fetch_contacts_args :: GlobalArguments | {:show_archived, boolean()}

  defp opts_to_query(opts) do
    show_archived = Keyword.get(opts, :show_archived)

    opts
    |> GlobalArguments.opts_to_query()
    |> Keyword.put(:show_archived, show_archived)
  end

  @doc """
  Fetch a list of contacts.

  ## Arguments:

    * `:client` - client to execute the HTTP request with

    * `:opts` - paging and ordering options
      * `:order_by` - field for ordering the records, appending `_asc` or `_desc` defines whether it's ascending (default) or descending
      * `:limit` - limit the number of results (default: 500, max: 2000)
      * `:offset` - Skip over a number of elements by specifying an offset value for the query
      * `:show_archived` - Show archived elements only,

  """
  @spec fetch_contacts(
          client :: Tesla.Client.t(),
          opts :: [fetch_contacts_args()]
        ) :: {:ok, [Contact.t()]} | {:error, any()}
  def fetch_contacts(client, opts \\ []) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/contact", query: opts_to_query(opts))
      end,
      &map_from_clients/1
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

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:criteria` - a list of search criteria
    * `:opts` - paging and ordering options
      * `:order_by` - field for ordering the records, appending `_asc` or `_desc` defines whether it's ascending (default) or descending
      * `:limit` - limit the number of results (default: 500, max: 2000)
      * `:offset` - Skip over a number of elements by specifying an offset value for the query
      * `:show_archived` - Show archived elements only,

  """
  @spec search_contacts(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [fetch_contacts_args()]
        ) :: {:ok, [Contact.t()]} | {:error, any()}
  def search_contacts(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_return_handling(
      fn ->
        Tesla.post(client, "/2.0/contact/search", criteria, query: opts_to_query(opts))
      end,
      &map_from_clients/1
    )
  end

  @doc """
  This action fetches a single contact

  ## Arguments:

    * `:contact_id` - the id of the contact
    * `:show_archived` - Show archived elements only

  """
  @spec fetch_contact(
          client :: Tesla.Client.t(),
          contact_id :: pos_integer(),
          show_archived :: boolean() | nil
        ) :: {:ok, [Contact.t()]} | {:error, any()}
  def fetch_contact(
        client,
        contact_id,
        show_archived \\ nil
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/contact/#{contact_id}", query: [show_archived: show_archived])
      end,
      &map_from_client/1
    )
  end

  defp map_from_clients(clients), do: Enum.map(clients, &map_from_client/1)

  defp map_from_client(%{
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
       }) do
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

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:order_by` - field for ordering the records, appending `_asc` or `_desc` defines whether it's ascending (default) or descending
    * `:limit` - limit the number of results (default: 500, max: 2000)
    * `:offset` - Skip over a number of elements by specifying an offset value for the query

  """
  @spec fetch_contact_relations(
          client :: Tesla.Client.t(),
          order_by ::
            :id
            | :id_asc
            | :id_desc
            | :contact_id
            | :contact_id_asc
            | :contact_id_desc
            | :contact_sub_id
            | :contact_sub_id_asc
            | :contact_sub_id_desc
            | nil,
          limit :: pos_integer() | nil,
          offset :: non_neg_integer() | nil
        ) :: {:ok, [BexioApiClient.Contacts.ContactRelation.t()]} | {:error, any()}
  def fetch_contact_relations(
        client,
        order_by \\ nil,
        limit \\ nil,
        offset \\ nil
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/contact_relation",
          query: [order_by: order_by, limit: limit, offset: offset]
        )
      end,
      &map_from_client_relations/1
    )
  end

  @doc """
  Search contacts via query.
  The following search fields are supported:

  * contact_id
  * contact_sub_id
  * updated_at

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:criteria` - a list of search criteria
    * `:order_by` - field for ordering the records, appending `_asc` or `_desc` defines whether it's ascending (default) or descending
    * `:limit` - limit the number of results (default: 500, max: 2000)
    * `:offset` - Skip over a number of elements by specifying an offset value for the query

  """
  @spec search_contact_relations(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          order_by ::
            :id
            | :id_asc
            | :id_desc
            | :contact_id
            | :contact_id_asc
            | :contact_id_desc
            | :contact_sub_id
            | :contact_sub_id_asc
            | :contact_sub_id_desc
            | nil,
          limit :: pos_integer() | nil,
          offset :: non_neg_integer() | nil
        ) :: {:ok, [BexioApiClient.Contacts.ContactRelation.t()]} | {:error, any()}
  def search_contact_relations(
        client,
        criteria,
        order_by \\ nil,
        limit \\ nil,
        offset \\ nil
      ) do
    bexio_return_handling(
      fn ->
        Tesla.post(client, "/2.0/contact_relation/search", criteria,
          query: [order_by: order_by, limit: limit, offset: offset]
        )
      end,
      &map_from_client_relations/1
    )
  end

  @doc """
  This action fetches a single contact relation

  ## Arguments:

    * `:contact_relation_id` - the id of the contact relation

  """
  @spec fetch_contact_relation(
          client :: Tesla.Client.t(),
          contact_relation_id :: pos_integer()
        ) :: {:ok, [BexioApiClient.Contacts.ContactRelation.t()]} | {:error, any()}
  def fetch_contact_relation(
        client,
        contact_relation_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/contact_relation/#{contact_relation_id}")
      end,
      &map_from_client_relation/1
    )
  end

  defp map_from_client_relations(client_relations),
    do: Enum.map(client_relations, &map_from_client_relation/1)

  defp map_from_client_relation(%{
         "id" => id,
         "contact_id" => contact_id,
         "contact_sub_id" => contact_sub_id,
         "description" => description,
         "updated_at" => updated_at
       }) do
    %ContactRelation{
      id: id,
      contact_id: contact_id,
      contact_sub_id: contact_sub_id,
      description: description,
      updated_at: to_datetime(updated_at)
    }
  end
end
