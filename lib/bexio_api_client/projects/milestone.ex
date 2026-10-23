defmodule BexioApiClient.Projects.Milestone do
  @moduledoc """
  Bexio Milestone Module (part of a project under /3.0/projects).
  """

  @typedoc """
  Bexio Milestone

  ## Fields:

    * `:id` - automatic id given by bexio, `nil` when creating a new milestone
    * `:name` - the name of the milestone
    * `:end_date` - the end date for the milestone
    * `:comment` - description for the milestone
    * `:pr_parent_milestone_id` - higher level milestone this milestone belongs to
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          name: String.t(),
          end_date: Date.t() | nil,
          comment: String.t() | nil,
          pr_parent_milestone_id: integer() | nil
        }
  @enforce_keys [
    :name
  ]
  defstruct [
    :id,
    :name,
    :end_date,
    :comment,
    :pr_parent_milestone_id
  ]

  @doc """
  Create a new milestone.

  Only `:name` is required by the bexio API, everything else is optional.
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        name: "",
        end_date: nil,
        comment: "",
        pr_parent_milestone_id: nil
      },
      attrs
    )
  end
end
