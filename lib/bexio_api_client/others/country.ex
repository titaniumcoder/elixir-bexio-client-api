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
          iso3166_alpha2: String.t()
        }
  @enforce_keys [:id, :name, :name_short, :iso3166_alpha2]
  defstruct [:id, :name, :name_short, :iso3166_alpha2]

  @doc """
  Create a new record.
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        name: "",
        name_short: "",
        iso3166_alpha2: ""
      },
      attrs
    )
  end
end
