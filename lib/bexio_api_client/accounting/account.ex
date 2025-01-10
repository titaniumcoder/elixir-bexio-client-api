defmodule BexioApiClient.Accounting.Account do
  @moduledoc """
  Bexio Account Module.
  """

  @typedoc """
  Bexio Account

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:account_no` - No of the account (string <int32> but this seems wrong...)
    * `:name` - Name of the account
    * `:account_group_id` - The id of the associated account group. References an account group object
    * `:account_type` - the type of the account
    * `:tax_id` - References a tax object
    * `:active?` - Whether  the account is active. IF the account is inactive, it can not be used for new bookings
    * `:locked?` - Determines if the account is locked. Locked accounts can not be edited or deleted
  """
  @type t :: %__MODULE__{
          id: integer(),
          account_no: String.t(),
          name: String.t(),
          account_group_id: integer(),
          account_type:
            :earning | :expenditure | :active_account | :passive_account | :complete_account,
          tax_id: integer(),
          active?: boolean(),
          locked?: boolean()
        }
  @enforce_keys [:id, :name, :account_group_id, :account_type, :tax_id, :active?, :locked?]
  defstruct [
    :id,
    :account_no,
    :name,
    :account_group_id,
    :account_type,
    :tax_id,
    :active?,
    :locked?
  ]
end
