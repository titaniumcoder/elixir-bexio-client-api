defmodule BexioApiClient.Accounting.ManualEntry do
  @moduledoc """
  Bexio Manual Entry Module.

  A manual entry (booking) in the account ledger, consisting of one or
  multiple `BexioApiClient.Accounting.ManualEntryLine`s.
  """

  alias BexioApiClient.Accounting.ManualEntryLine

  @typedoc """
  Bexio Manual Entry

  ## Fields:

    * `:id` - automatic id given by bexio (`nil` for a not yet created entry)
    * `:type` - either `:manual_single_entry`, `:manual_compound_entry` or `:manual_group_entry`
    * `:date` - the booking date
    * `:reference_nr` - a reference number for the booking
    * `:created_by_user_id` - the id of the user who created the entry
    * `:edited_by_user_id` - the id of the user who last edited the entry
    * `:entries` - the single booking lines of the entry
    * `:locked?` - whether the manual entry is locked (e.g. in a closed business year)
    * `:locked_info` - the reason why the manual entry is locked
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          type: :manual_single_entry | :manual_compound_entry | :manual_group_entry,
          date: Date.t(),
          reference_nr: String.t() | nil,
          created_by_user_id: integer() | nil,
          edited_by_user_id: integer() | nil,
          entries: [ManualEntryLine.t()],
          locked?: boolean(),
          locked_info: String.t() | nil
        }
  @enforce_keys [:id, :type, :date, :entries, :locked?]
  defstruct [
    :id,
    :type,
    :date,
    :reference_nr,
    :created_by_user_id,
    :edited_by_user_id,
    :entries,
    :locked?,
    :locked_info
  ]

  @doc """
  Create a new manual entry (for `create_manual_entry/2` or `edit_manual_entry/2`).
  The id, the user ids and the lock state are ignored when creating.
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        type: :manual_single_entry,
        date: nil,
        reference_nr: nil,
        created_by_user_id: nil,
        edited_by_user_id: nil,
        entries: [],
        locked?: false,
        locked_info: nil
      },
      attrs
    )
  end
end
