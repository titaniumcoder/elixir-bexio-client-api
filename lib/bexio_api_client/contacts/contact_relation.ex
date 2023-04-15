defmodule BexioApiClient.Contacts.ContactRelation do
  @moduledoc """
  Bexio Contact Relation Module.
  """

  @typedoc """
  Bexio Contact Relation

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:contact_id` - References a contact object
    * `:contact_sub_id` - References a contact object
    * `:description` - description of the relation
    * `:updated_at` - date time of the last update (zurich time zone)
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          contact_id: pos_integer(),
          contact_sub_id: pos_integer(),
          description: String.t(),
          updated_at: NaiveDateTime.t()
        }
  @enforce_keys [:contact_id, :contact_sub_id]
  defstruct [:id, :contact_id, :contact_sub_id, :description, :updated_at]
end
