defmodule BexioApiClient.Projects.ProjectType do
  @moduledoc """
  Bexio Project Type Module.
  """

  @typedoc """
  Bexio Project Type

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - the name of the project type (e.g. "Internal Project")
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t()
        }
  @enforce_keys [
    :id,
    :name
  ]
  defstruct [
    :id,
    :name
  ]
end
