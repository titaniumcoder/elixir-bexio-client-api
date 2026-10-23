defmodule BexioApiClient.Projects.WorkPackage do
  @moduledoc """
  Bexio Work Package Module (part of a project under /3.0/projects).
  """

  @typedoc """
  Bexio Work Package

  ## Fields:

    * `:id` - automatic id given by bexio, `nil` when creating a new work package
    * `:name` - the name of the work package
    * `:spent_time_in_hours` - time spent on the work package
    * `:estimated_time_in_hours` - estimated time on the work package
    * `:comment` - description for the work package
    * `:pr_milestone_id` - reference to a milestone object
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          name: String.t(),
          spent_time_in_hours: Decimal.t() | nil,
          estimated_time_in_hours: Decimal.t() | nil,
          comment: String.t() | nil,
          pr_milestone_id: integer() | nil
        }
  @enforce_keys [
    :name
  ]
  defstruct [
    :id,
    :name,
    :spent_time_in_hours,
    :estimated_time_in_hours,
    :comment,
    :pr_milestone_id
  ]

  @doc """
  Create a new work package.

  Only `:name` is required by the bexio API, everything else is optional.
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        name: "",
        spent_time_in_hours: nil,
        estimated_time_in_hours: nil,
        comment: "",
        pr_milestone_id: nil
      },
      attrs
    )
  end
end
