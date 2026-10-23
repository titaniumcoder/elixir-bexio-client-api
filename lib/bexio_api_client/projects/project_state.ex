defmodule BexioApiClient.Projects.ProjectState do
  @moduledoc """
  Bexio Project Status Module.
  """

  @typedoc """
  Bexio Project Status

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - the name of the project status (e.g. "Active")
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
