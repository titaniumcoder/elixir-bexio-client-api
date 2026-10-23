defmodule BexioApiClient.Contacts.Contact do
  @moduledoc """
  Bexio Contact Module.
  """

  @typedoc """
  Bexio Contact (company or person).

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:nr` - must be a number, can also be used as integer; `nil` when assigned automatically
    * `:contact_type` - either `:company` or `:person`
    * `:name_1` - for `:company` the company name and for `:person` the last name
    * `:name_2` - for `:company` the company addition and for `:person` the first name
    * `:salutation_id`- reference to a TODO: salutation object
    * `:salutation_form` - ??
    * `:title_id` - reference to a TODO: title object
    * `:birthday` - birthday (`:person`) or foundation date (`:company`)
    * `:address` - street and additional address information
    * `:street_name` - street name (the `:address` field is deprecated by bexio in favor of the structured address fields)
    * `:house_number` - house number
    * `:address_addition` - additional address information
    * `:postcode` - postal code / zip
    * `:city` - city
    * `:country_id` - reference to a TODO: country object
    * `:mail` - email address
    * `:mail_second` - secondary email address
    * `:phone_fixed` - phone number (fixed)
    * `:phone_fixed_secondary` - secondary phone number (fixed)
    * `:phone_mobile` - phone number (mobile)
    * `:fax` - number for this old fax devices out there
    * `:url` - homepage url
    * `:skype_name` - Skype Name
    * `:remarks` - free text for remarks
    * `:lead?` - whether the contact is a lead
    * `:language_id` - reference to a TODO: language object
    * `:contact_group_ids` - reference to multiple TODO: contact group objects
    * `:contact_branch_ids` - reference to multiple TODO: contact sector objects
    * `:user_id` - creator of the record, reference to a TODO: user object
    * `:owner_id` - owner of the record, reference to a TODO: user object
    * `:updated_at` - date time of the last update (zurich time zone)
    * `:profile_image` - base64 encoded profile image (only part of the show-contact response)
  """
  @type t :: %__MODULE__{
          id: integer(),
          nr: integer() | nil,
          contact_type: :company | :person,
          name_1: String.t(),
          name_2: String.t(),
          salutation_id: integer(),
          salutation_form: integer(),
          title_id: integer(),
          birthday: Date.t(),
          address: String.t(),
          street_name: String.t() | nil,
          house_number: String.t() | nil,
          address_addition: String.t() | nil,
          postcode: String.t(),
          city: String.t(),
          country_id: integer(),
          mail: String.t(),
          mail_second: String.t(),
          phone_fixed: String.t(),
          phone_fixed_second: String.t(),
          phone_mobile: String.t(),
          fax: String.t(),
          url: String.t(),
          skype_name: String.t(),
          remarks: String.t(),
          lead?: boolean(),
          language_id: integer(),
          contact_group_ids: [integer()],
          contact_branch_ids: [integer()],
          user_id: integer(),
          owner_id: integer(),
          updated_at: NaiveDateTime.t(),
          profile_image: String.t() | nil
        }
  @enforce_keys [
    :id,
    :nr,
    :contact_type,
    :lead?,
    :name_1,
    :contact_group_ids,
    :contact_branch_ids,
    :user_id,
    :owner_id
  ]
  defstruct [
    :id,
    :nr,
    :contact_type,
    :name_1,
    :name_2,
    :salutation_id,
    :salutation_form,
    :title_id,
    :birthday,
    :address,
    :street_name,
    :house_number,
    :address_addition,
    :postcode,
    :city,
    :country_id,
    :mail,
    :mail_second,
    :phone_fixed,
    :phone_fixed_second,
    :phone_mobile,
    :fax,
    :url,
    :skype_name,
    :remarks,
    :lead?,
    :language_id,
    :contact_group_ids,
    :contact_branch_ids,
    :user_id,
    :owner_id,
    :updated_at,
    :profile_image
  ]

  @doc """
  Create a new contact
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        nr: nil,
        contact_type: :company,
        name_1: "",
        name_2: nil,
        salutation_id: nil,
        salutation_form: nil,
        title_id: nil,
        birthday: nil,
        address: nil,
        street_name: nil,
        house_number: nil,
        address_addition: nil,
        postcode: nil,
        city: nil,
        country_id: nil,
        mail: nil,
        mail_second: nil,
        phone_fixed: nil,
        phone_fixed_second: nil,
        phone_mobile: nil,
        fax: nil,
        url: nil,
        skype_name: nil,
        remarks: nil,
        lead?: false,
        language_id: nil,
        contact_group_ids: [],
        contact_branch_ids: [],
        user_id: nil,
        owner_id: nil,
        updated_at: nil,
        profile_image: nil
      },
      attrs
    )
  end
end
