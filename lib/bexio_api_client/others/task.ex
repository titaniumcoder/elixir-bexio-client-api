defmodule BexioApiClient.Others.Task do
  @moduledoc """
  Bexio Task Module.
  """

  @typedoc """
  Bexio Task.
  """
  @type t :: %__MODULE__{
          id: integer(),
          user_id: integer(),
          finish_date: NaiveDateTime.t() | nil,
          subject: String.t(),
          place: integer() | nil,
          info: String.t(),
          contact_id: integer() | nil,
          sub_contact_id: integer() | nil,
          project_id: integer() | nil,
          entry_id: integer() | nil,
          module_id: integer() | nil,
          todo_status_id: integer(),
          todo_priority_id: integer() | nil,
          reminder?: boolean(),
          remember_type_id: integer() | nil,
          remember_time_id: integer() | nil,
          communication_kind_id: integer() | nil
        }
  @enforce_keys [:id, :user_id, :subject, :info, :reminder?, :todo_status_id]
  defstruct [
    :id,
    :user_id,
    :finish_date,
    :subject,
    :place,
    :info,
    :contact_id,
    :sub_contact_id,
    :project_id,
    :entry_id,
    :module_id,
    :todo_status_id,
    :todo_priority_id,
    :reminder?,
    :remember_type_id,
    :remember_time_id,
    :communication_kind_id
  ]
end
