defmodule BexioApiClient.Timesheets.Tracking do
  @moduledoc """
  Bexio Timesheet Tracking Module.

  The tracking information of a timesheet. Two formats can be used to submit
  the tracked time: either type `duration` or type `range`. Only the
  `duration` format is documented in the bexio docs (see
  `docs/reference/timesheets.md`), so this struct only models the documented
  fields.
  """

  @typedoc """
  Bexio Timesheet Tracking

  ## Fields:

    * `:type` - either :duration or :range
    * `:date` - the tracked date
    * `:duration` - the tracked duration (e.g. "01:40") for type :duration
  """
  @type t :: %__MODULE__{
          type: :duration | :range,
          date: Date.t() | nil,
          duration: String.t() | nil
        }
  @enforce_keys [:type]
  defstruct [:type, :date, :duration]
end
