defmodule BexioApiClient.SalesOrderManagement.OrderRepetition do
  @moduledoc """
  Repetition of an order
  """

  @typedoc """
  Repetition of an order

  ## Fields:

    * `:start` - date the repetition starts
    * `:end` - date until the repetition is supposed to run. If empty an indefinite repetition is assumed.
    * `:repetition` - the repetition itself: either type `daily`, `weekly`, `monthly` or `yearly`
      with the according parameters (e.g. `%{type: :daily, interval: 1}`)
  """
  @type repetition_type :: :daily | :weekly | :monthly | :yearly

  @type repetition :: %{
          required(:type) => repetition_type(),
          required(:interval) => pos_integer()
        }

  @type t :: %__MODULE__{
          start: Date.t(),
          end: Date.t() | nil,
          repetition: repetition()
        }
  @enforce_keys [
    :start,
    :repetition
  ]
  defstruct [
    :start,
    :end,
    :repetition
  ]

  @doc """
  Create a new order repetition
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        start: Date.utc_today(),
        end: nil,
        repetition: %{type: :daily, interval: 1}
      },
      attrs
    )
  end
end
