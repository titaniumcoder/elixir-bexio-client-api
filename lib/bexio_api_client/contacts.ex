defmodule BexioApiClient.Contacts do
  @moduledoc """
  Bexio API for the contacts part of the API.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria
  alias BexioApiClient.Contacts.Contact

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @type api_error_type :: BexioApiClient.Helpers.api_error_type()

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
          req :: Req.Request.t(),
          show_archived :: boolean(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Contact.t()]} | api_error_type()
  def fetch_contacts(req, show_archived \\ false, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/contact", params: contact_opts_to_query(show_archived, opts))
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
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          show_archived :: boolean(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Contact.t()]} | api_error_type()
  def search_contacts(
        req,
        criteria,
        show_archived \\ false,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(req,
          url: "/2.0/contact/search",
          json: criteria,
          params: contact_opts_to_query(show_archived, opts)
        )
      end,
      &map_from_clients/2
    )
  end

  @doc """
  This action fetches a single contact
  """
  @spec fetch_contact(
          req :: Req.Request.t(),
          contact_id :: pos_integer(),
          show_archived :: boolean() | nil
        ) :: {:ok, Contact.t()} | api_error_type()
  def fetch_contact(
        req,
        contact_id,
        show_archived \\ nil
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/contact/#{contact_id}", params: [show_archived: show_archived])
      end,
      &map_from_client/2
    )
  end

  @doc """
  Create a contact.
  """
  @spec create_contact(
          req :: Req.Request.t(),
          contact :: Contact.t()
        ) :: {:ok, Contact.t()} | api_error_type()
  def create_contact(req, contact) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/contact", json: remap_contact(contact))
      end,
      &map_from_client/2
    )
  end

  @doc """
  Edit a contact.
  """
  @spec edit_contact(
          req :: Req.Request.t(),
          contact :: Contact.t()
        ) :: {:ok, Contact.t()} | api_error_type()
  def edit_contact(req, contact) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/contact/#{contact.id}", json: remap_contact(contact))
      end,
      &map_from_client/2
    )
  end

  @doc """
  Delete a contact.
  """
  @spec delete_contact(
          req :: Req.Request.t(),
          contact_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_contact(req, contact_id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/contact/#{contact_id}")
      end,
      &success_response/2
    )
  end

  @doc """
  Bulk create multiple contacts in one request.
  """
  @spec bulk_create_contacts(
          req :: Req.Request.t(),
          contacts :: [Contact.t()]
        ) :: {:ok, [Contact.t()]} | api_error_type()
  def bulk_create_contacts(req, contacts) do
    bexio_body_handling(
      fn ->
        Req.post(req,
          url: "/2.0/contact/_bulk_create",
          json: Enum.map(contacts, &remap_contact/1)
        )
      end,
      &map_from_clients/2
    )
  end

  @doc """
  Restore an archived contact.
  """
  @spec restore_contact(
          req :: Req.Request.t(),
          contact_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def restore_contact(req, contact_id) do
    bexio_body_handling(
      fn ->
        Req.patch(req, url: "/2.0/contact/#{contact_id}/restore")
      end,
      &success_response/2
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
           "street_name" => street_name,
           "house_number" => house_number,
           "address_addition" => address_addition,
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
           "is_lead" => lead?,
           "language_id" => language_id,
           "contact_group_ids" => contact_group_ids,
           "contact_branch_ids" => contact_branch_ids,
           "user_id" => user_id,
           "owner_id" => owner_id,
           "updated_at" => updated_at
         } = contact,
         _env \\ nil
       ) do
    %Contact{
      id: id,
      # nr is "string or null" in the API; it is nil when assigned automatically
      nr: if(is_nil(nr), do: nil, else: String.to_integer(nr)),
      contact_type: contact_type(contact_type_id),
      name_1: name_1,
      name_2: name_2,
      salutation_id: salutation_id,
      salutation_form: salutation_form,
      title_id: title_id,
      birthday: to_date(birthday),
      address: address,
      street_name: street_name,
      house_number: house_number,
      address_addition: address_addition,
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
      lead?: lead?,
      language_id: language_id,
      contact_group_ids: string_to_array(contact_group_ids),
      contact_branch_ids: string_to_array(contact_branch_ids),
      user_id: user_id,
      owner_id: owner_id,
      updated_at: to_datetime(updated_at),
      # profile_image is only part of the show-contact response, not of list/search
      profile_image: Map.get(contact, "profile_image")
    }
  end

  defp contact_type(1), do: :company
  defp contact_type(2), do: :person

  defp contact_type_id(:company), do: 1
  defp contact_type_id(:person), do: 2

  defp ids_to_string([]), do: nil
  defp ids_to_string(ids), do: Enum.join(ids, ",")

  defp remap_contact(%Contact{
         nr: nr,
         contact_type: contact_type,
         name_1: name_1,
         name_2: name_2,
         salutation_id: salutation_id,
         salutation_form: salutation_form,
         title_id: title_id,
         birthday: birthday,
         street_name: street_name,
         house_number: house_number,
         address_addition: address_addition,
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
         contact_group_ids: contact_group_ids,
         contact_branch_ids: contact_branch_ids,
         user_id: user_id,
         owner_id: owner_id
       }) do
    %{
      nr: nr,
      contact_type_id: contact_type_id(contact_type),
      name_1: name_1,
      name_2: name_2,
      salutation_id: salutation_id,
      salutation_form: salutation_form,
      title_id: title_id,
      birthday: to_iso8601(birthday),
      street_name: street_name,
      house_number: house_number,
      address_addition: address_addition,
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
      contact_group_ids: ids_to_string(contact_group_ids),
      contact_branch_ids: ids_to_string(contact_branch_ids),
      user_id: user_id,
      owner_id: owner_id
    }
  end

  ### Bexio API for the contact relations part of the API.

  alias BexioApiClient.Contacts.ContactRelation

  @doc """
  Fetch a list of contacts relations.
  """
  @spec fetch_contact_relations(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [ContactRelation.t()]} | api_error_type()
  def fetch_contact_relations(
        req,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/contact_relation", params: opts_to_query(opts))
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
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [ContactRelation.t()]} | api_error_type()
  def search_contact_relations(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(req,
          url: "/2.0/contact_relation/search",
          json: criteria,
          params: opts_to_query(opts)
        )
      end,
      &map_from_client_relations/2
    )
  end

  @doc """
  This action fetches a single contact relation
  """
  @spec fetch_contact_relation(
          req :: Req.Request.t(),
          contact_relation_id :: pos_integer()
        ) :: {:ok, ContactRelation.t()} | api_error_type()
  def fetch_contact_relation(
        req,
        contact_relation_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/contact_relation/#{contact_relation_id}")
      end,
      &map_from_client_relation/2
    )
  end

  @doc """
  Create a contact relation.
  """
  @spec create_contact_relation(
          req :: Req.Request.t(),
          contact_relation :: ContactRelation.t()
        ) :: {:ok, ContactRelation.t()} | api_error_type()
  def create_contact_relation(req, contact_relation) do
    bexio_body_handling(
      fn ->
        Req.post(req,
          url: "/2.0/contact_relation",
          json: remap_contact_relation(contact_relation)
        )
      end,
      &map_from_client_relation/2
    )
  end

  @doc """
  Edit a contact relation.
  """
  @spec edit_contact_relation(
          req :: Req.Request.t(),
          contact_relation :: ContactRelation.t()
        ) :: {:ok, ContactRelation.t()} | api_error_type()
  def edit_contact_relation(req, contact_relation) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/contact_relation/#{contact_relation.id}",
          json: remap_contact_relation(contact_relation)
        )
      end,
      &map_from_client_relation/2
    )
  end

  @doc """
  Delete a contact relation.
  """
  @spec delete_contact_relation(
          req :: Req.Request.t(),
          contact_relation_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_contact_relation(req, contact_relation_id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/contact_relation/#{contact_relation_id}")
      end,
      &success_response/2
    )
  end

  defp remap_contact_relation(%ContactRelation{
         contact_id: contact_id,
         contact_sub_id: contact_sub_id,
         description: description
       }) do
    %{
      contact_id: contact_id,
      contact_sub_id: contact_sub_id,
      description: description
    }
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
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | api_error_type()
  def fetch_contact_groups(
        req,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/contact_group", params: opts_to_query(opts))
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
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | api_error_type()
  def search_contact_groups(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(req,
          url: "/2.0/contact_group/search",
          json: criteria,
          params: opts_to_query(opts)
        )
      end,
      &body_to_map/2
    )
  end

  @doc """
  This action fetches a single contact group
  """
  @spec fetch_contact_group(
          req :: Req.Request.t(),
          contact_group_id :: pos_integer()
        ) :: {:ok, %{id: integer(), name: String.t()}} | api_error_type()
  def fetch_contact_group(
        req,
        contact_group_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/contact_group/#{contact_group_id}")
      end,
      &id_name/2
    )
  end

  @doc """
  Create a contact group.
  """
  @spec create_contact_group(
          req :: Req.Request.t(),
          name :: String.t()
        ) :: {:ok, %{id: integer(), name: String.t()}} | api_error_type()
  def create_contact_group(req, name) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/contact_group", json: %{name: name})
      end,
      &id_name/2
    )
  end

  @doc """
  Edit a contact group.
  """
  @spec edit_contact_group(
          req :: Req.Request.t(),
          contact_group_id :: non_neg_integer(),
          name :: String.t()
        ) :: {:ok, %{id: integer(), name: String.t()}} | api_error_type()
  def edit_contact_group(req, contact_group_id, name) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/contact_group/#{contact_group_id}", json: %{name: name})
      end,
      &id_name/2
    )
  end

  @doc """
  Delete a contact group.
  """
  @spec delete_contact_group(
          req :: Req.Request.t(),
          contact_group_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_contact_group(req, contact_group_id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/contact_group/#{contact_group_id}")
      end,
      &success_response/2
    )
  end

  ### Bexio API for the contact sector part of the API.

  @doc """
  Fetch a list of contacts sectors.
  """
  @spec fetch_contact_sectors(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | api_error_type()
  def fetch_contact_sectors(
        req,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/contact_branch", params: opts_to_query(opts))
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
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | api_error_type()
  def search_contact_sectors(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(req,
          url: "/2.0/contact_branch/search",
          json: criteria,
          params: opts_to_query(opts)
        )
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
          req :: Req.Request.t(),
          contact_id :: integer(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [AdditionalAddress.t()]} | api_error_type()
  def fetch_additional_addresses(
        req,
        contact_id,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req,
          url: "/2.0/contact/#{contact_id}/additional_address",
          params: opts_to_query(opts)
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
          req :: Req.Request.t(),
          contact_id :: integer(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [AdditionalAddress.t()]} | api_error_type()
  def search_additional_addresses(
        req,
        contact_id,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(req,
          url: "/2.0/contact/#{contact_id}/additional_address/search",
          json: criteria,
          params: opts_to_query(opts)
        )
      end,
      &map_from_additional_addresses/2
    )
  end

  @doc """
  This action fetches a single additional address
  """
  @spec fetch_additional_address(
          req :: Req.Request.t(),
          contact_id :: non_neg_integer(),
          additional_address_id :: non_neg_integer()
        ) :: {:ok, AdditionalAddress.t()} | api_error_type()
  def fetch_additional_address(
        req,
        contact_id,
        additional_address_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/contact/#{contact_id}/additional_address/#{additional_address_id}"
        )
      end,
      &map_from_additional_address/2
    )
  end

  @doc """
  Create an additional address for a contact.
  """
  @spec create_additional_address(
          req :: Req.Request.t(),
          contact_id :: non_neg_integer(),
          additional_address :: AdditionalAddress.t()
        ) :: {:ok, AdditionalAddress.t()} | api_error_type()
  def create_additional_address(req, contact_id, additional_address) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/contact/#{contact_id}/additional_address",
          json: remap_additional_address(additional_address)
        )
      end,
      &map_from_additional_address/2
    )
  end

  @doc """
  Edit an additional address of a contact.
  """
  @spec edit_additional_address(
          req :: Req.Request.t(),
          contact_id :: non_neg_integer(),
          additional_address :: AdditionalAddress.t()
        ) :: {:ok, AdditionalAddress.t()} | api_error_type()
  def edit_additional_address(req, contact_id, additional_address) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/contact/#{contact_id}/additional_address/#{additional_address.id}",
          json: remap_additional_address(additional_address)
        )
      end,
      &map_from_additional_address/2
    )
  end

  @doc """
  Delete an additional address of a contact.
  """
  @spec delete_additional_address(
          req :: Req.Request.t(),
          contact_id :: non_neg_integer(),
          additional_address_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_additional_address(req, contact_id, additional_address_id) do
    bexio_body_handling(
      fn ->
        Req.delete(
          req,
          url: "/2.0/contact/#{contact_id}/additional_address/#{additional_address_id}"
        )
      end,
      &success_response/2
    )
  end

  defp remap_additional_address(%AdditionalAddress{
         name: name,
         name_addition: name_addition,
         street_name: street_name,
         house_number: house_number,
         address_addition: address_addition,
         postcode: postcode,
         city: city,
         country_id: country_id,
         subject: subject,
         description: description
       }) do
    %{
      name: name,
      name_addition: name_addition,
      street_name: street_name,
      house_number: house_number,
      address_addition: address_addition,
      postcode: postcode,
      city: city,
      country_id: country_id,
      subject: subject,
      description: description
    }
  end

  defp map_from_additional_addresses(addresses, _env),
    do: Enum.map(addresses, &map_from_additional_address/1)

  defp map_from_additional_address(
         %{
           "id" => id,
           "name" => name,
           "name_addition" => name_addition,
           "address" => address,
           "street_name" => street_name,
           "house_number" => house_number,
           "address_addition" => address_addition,
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
      name_addition: name_addition,
      address: address,
      street_name: street_name,
      house_number: house_number,
      address_addition: address_addition,
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
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | api_error_type()
  def fetch_salutations(
        req,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/salutation", params: opts_to_query(opts))
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
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | api_error_type()
  def search_salutations(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/salutation/search", json: criteria, params: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  This action fetches a single salutation
  """
  @spec fetch_salutation(
          req :: Req.Request.t(),
          salutation_id :: non_neg_integer()
        ) :: {:ok, %{id: integer(), name: String.t()}} | api_error_type()
  def fetch_salutation(
        req,
        salutation_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/salutation/#{salutation_id}"
        )
      end,
      &id_name/2
    )
  end

  @doc """
  Create a salutation.
  """
  @spec create_salutation(
          req :: Req.Request.t(),
          name :: String.t()
        ) :: {:ok, %{id: integer(), name: String.t()}} | api_error_type()
  def create_salutation(req, name) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/salutation", json: %{name: name})
      end,
      &id_name/2
    )
  end

  @doc """
  Edit a salutation.
  """
  @spec edit_salutation(
          req :: Req.Request.t(),
          salutation_id :: non_neg_integer(),
          name :: String.t()
        ) :: {:ok, %{id: integer(), name: String.t()}} | api_error_type()
  def edit_salutation(req, salutation_id, name) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/salutation/#{salutation_id}", json: %{name: name})
      end,
      &id_name/2
    )
  end

  @doc """
  Delete a salutation.
  """
  @spec delete_salutation(
          req :: Req.Request.t(),
          salutation_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_salutation(req, salutation_id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/salutation/#{salutation_id}")
      end,
      &success_response/2
    )
  end

  ### Bexio API for the titles part of the API.

  @doc """
  Fetch a list of titles.
  """
  @spec fetch_titles(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | api_error_type()
  def fetch_titles(
        req,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/title", params: opts_to_query(opts))
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
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | api_error_type()
  def search_titles(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/title/search", json: criteria, params: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  This action fetches a single title
  """
  @spec fetch_title(
          req :: Req.Request.t(),
          title_id :: non_neg_integer()
        ) :: {:ok, %{id: integer(), name: String.t()}} | api_error_type()
  def fetch_title(
        req,
        title_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/title/#{title_id}"
        )
      end,
      &id_name/2
    )
  end

  @doc """
  Create a title.
  """
  @spec create_title(
          req :: Req.Request.t(),
          name :: String.t()
        ) :: {:ok, %{id: integer(), name: String.t()}} | api_error_type()
  def create_title(req, name) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/title", json: %{name: name})
      end,
      &id_name/2
    )
  end

  @doc """
  Edit a title.
  """
  @spec edit_title(
          req :: Req.Request.t(),
          title_id :: non_neg_integer(),
          name :: String.t()
        ) :: {:ok, %{id: integer(), name: String.t()}} | api_error_type()
  def edit_title(req, title_id, name) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/title/#{title_id}", json: %{name: name})
      end,
      &id_name/2
    )
  end

  @doc """
  Delete a title.
  """
  @spec delete_title(
          req :: Req.Request.t(),
          title_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_title(req, title_id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/title/#{title_id}")
      end,
      &success_response/2
    )
  end
end
