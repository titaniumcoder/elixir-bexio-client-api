defmodule BexioApiClient.Contacts do
  @moduledoc """
  Bexio API for the contacts part of the API.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.Contacts.Contact

  @doc """
  Fetch a list of contacts.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:order_by` - field for ordering the records, appending `_asc` or `_desc` defines whether it's ascending (default) or descending
    * `:limit` - limit the number of results (default: 500, max: 2000)
    * `:offset` - Skip over a number of elements by specifying an offset value for the query
    * `:show_archived` - Show archived elements only

  """
  @spec fetch_contacts(
          client :: Tesla.Client.t(),
          order_by ::
            :id
            | :nr
            | :name_1
            | :updated_at
            | :id_desc
            | :nr_desc
            | :offset_desc
            | :updated_at_desc
            | :id_asc
            | :nr_asc
            | :offset_asc
            | :updated_at_asc
            | nil,
          limit :: pos_integer() | nil,
          offset :: non_neg_integer() | nil,
          show_archived :: boolean() | nil
        ) :: {:ok, [BexioApiClient.Contacts.Contact.t()]} | {:error, any()}
  def fetch_contacts(
        client,
        order_by \\ nil,
        limit \\ nil,
        offset \\ nil,
        show_archived \\ nil
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/contact",
          query: [order_by: order_by, limit: limit, offset: offset, show_archived: show_archived]
        )
      end,
      fn body -> Enum.map(body, &map_from_client/1) end
    )
  end

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
end
