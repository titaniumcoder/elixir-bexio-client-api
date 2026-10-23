defmodule BexioApiClient.Timesheets.TimesheetStatus do
  @moduledoc """
  Bexio Timesheet Status Module.
  """

  @typedoc """
  Bexio Timesheet Status

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - the name of the status
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t()
        }
  @enforce_keys [:id, :name]
  defstruct [:id, :name]
end
