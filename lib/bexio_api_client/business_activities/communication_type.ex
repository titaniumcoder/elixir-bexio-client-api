defmodule BexioApiClient.BusinessActivities.CommunicationType do
  @moduledoc """
  Bexio Communication Type (communication kind) Module.
  """

  @typedoc """
  Bexio Communication Type (communication kind).

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - name of the communication type
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t()
        }
  @enforce_keys [:id, :name]
  defstruct [:id, :name]
end
