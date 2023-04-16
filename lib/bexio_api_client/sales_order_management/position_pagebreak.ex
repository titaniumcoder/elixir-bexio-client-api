defmodule BexioApiClient.SalesOrderManagement.PositionPagebreak do
  @moduledoc """
  Pagebreak Position (KbPositionPagebreak)
  """

  @typedoc """
  Pagebreak Position

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:internal_pos` - internal position
    * `:optional?` - if pagebreak is optional
    * `:parent_id` - parent id
  """
  @type t :: %__MODULE__{
          id: integer(),
          internal_pos: integer,
          optional?: boolean(),
          parent_id: integer() | nil
        }
  @enforce_keys [
    :optional?
  ]
  defstruct [
    :id,
    :internal_pos,
    :optional?,
    :parent_id
  ]

  @doc """
  Create a new record.
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
    %__MODULE__{
      optional?: false
    }, attrs)
  end
end
