defmodule BexioApiClient.Timesheets.Timesheet do
  @moduledoc """
  Bexio Timesheet Module.
  """

  alias BexioApiClient.Timesheets.Tracking

  @typedoc """
  Bexio Timesheet

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:user_id` - References a user object
    * `:status_id` - References a timesheet status object
    * `:client_service_id` - References a business activity object
    * `:allowable_bill?` - whether the time can be billed
    * `:contact_id` - References a contact object
    * `:sub_contact_id` - References a contact object
    * `:pr_project_id` - References a project object
    * `:tracking` - the tracked time (see `BexioApiClient.Timesheets.Tracking`)
  """
  @type t :: %__MODULE__{
          id: integer(),
          user_id: integer(),
          status_id: integer() | nil,
          client_service_id: integer(),
          text: String.t() | nil,
          allowable_bill?: boolean(),
          charge: String.t() | nil,
          contact_id: integer() | nil,
          sub_contact_id: integer() | nil,
          pr_project_id: integer() | nil,
          pr_package_id: integer() | nil,
          pr_milestone_id: integer() | nil,
          travel_time: String.t() | nil,
          travel_charge: String.t() | nil,
          travel_distance: number() | nil,
          estimated_time: String.t() | nil,
          date: Date.t(),
          duration: String.t() | nil,
          running?: boolean(),
          tracking: Tracking.t()
        }
  @enforce_keys [:id, :user_id, :client_service_id, :allowable_bill?, :date]
  defstruct [
    :id,
    :user_id,
    :status_id,
    :client_service_id,
    :text,
    :allowable_bill?,
    :charge,
    :contact_id,
    :sub_contact_id,
    :pr_project_id,
    :pr_package_id,
    :pr_milestone_id,
    :travel_time,
    :travel_charge,
    :travel_distance,
    :estimated_time,
    :date,
    :duration,
    :running?,
    :tracking
  ]

  @doc """
  Create a new timesheet
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        user_id: nil,
        status_id: nil,
        client_service_id: nil,
        allowable_bill?: false,
        date: nil,
        tracking: nil
      },
      attrs
    )
  end
end
