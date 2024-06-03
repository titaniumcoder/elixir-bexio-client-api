defmodule BexioApiClient.Others.Note do
  @moduledoc """
  Bexio Note Module.
  """

  @typedoc """
  Bexio Note.
  """
  @type t :: %__MODULE__{
          id: integer(),
          user_id: integer(),
          event_start_date: NaiveDateTime.t(),
          subject: String.t(),
          info: String.t() | nil,
          contact_id: integer() | nil,
          project_id: integer() | nil,
          entry_id: integer() | nil,
          module_id: integer() | nil
        }
  @enforce_keys [
    :id,
    :user_id,
    :event_start_date,
    :subject,
  ]
  defstruct [
    :id,
    :user_id,
    :event_start_date,
    :subject,
    :info,
    :contact_id,
    :project_id,
    :entry_id,
    :module_id
  ]
end
