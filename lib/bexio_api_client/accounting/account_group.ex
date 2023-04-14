defmodule BexioApiClient.Accounting.AccountGroup do
  @moduledoc """
  Bexio Account Group Module.
  """

  @typedoc """
  Bexio Account Group

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:account_no` - No of the account group
    * `:name` - Name of the account
    * `:parent_fibu_account_group_id` - The id of the parent account group, references an account group
    * `:active?` - Whether the account group is active. If the account group is inactive, accounts in this account group can not be used for new bookings.
    * `:locked?` - Determines if the account group is locked. Locked accounts can not be edited or deleted
  """
  @type t :: %__MODULE__{
          id: integer(),
          account_no: integer(),
          name: String.t(),
          parent_fibu_account_group_id: integer(),
          active?: boolean(),
          locked?: boolean()
        }
  @enforce_keys [:id, :name, :parent_fibu_account_group_id, :active?, :locked?]
  defstruct [
    :id,
    :account_no,
    :name,
    :parent_fibu_account_group_id,
    :active?,
    :locked?
  ]
end
