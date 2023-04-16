defmodule BexioApiClient.Others.Country do
  @moduledoc """
  Bexio Country Module.
  """

  @typedoc """
  Bexio Country.
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          name_short: String.t(),
          iso_3166_alpha2: String.t()
        }
  @enforce_keys [:id, :name, :name_short, :iso_3166_alpha2]
  defstruct [:id, :name, :name_short, :iso_3166_alpha2]
end
