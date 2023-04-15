defmodule BexioApiClient.Accounting.Currency do
  @moduledoc """
  Bexio Currency Module.
  """

  @typedoc """
  Bexio Currency

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - Currency Name
    * `:round_factor` - How to round the given currency
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          round_factor: float()
        }
  @enforce_keys [:id, :name, :round_factor]
  defstruct [:id, :name, :round_factor]

  @doc """
  Rounds an amount to the given currency round factor
  """
  def round(nil, _currency), do: nil

  def round(%Decimal{} = t, %__MODULE__{round_factor: 0.01}), do: Decimal.round(t, 2)
  def round(%Decimal{} = t, %__MODULE__{round_factor: 0.1}), do: Decimal.round(t, 1)
  def round(%Decimal{} = t, %__MODULE__{round_factor: 1.0}), do: Decimal.round(t, 0)

  def round(%Decimal{} = t, %__MODULE__{round_factor: 0.05}) do
    t
    |> Decimal.mult(2)
    |> Decimal.round(1)
    |> Decimal.div(2)
  end

  def round(number, %__MODULE__{round_factor: 0.01}) when is_float(number),
    do: Float.round(number, 2)

  def round(number, %__MODULE__{round_factor: 0.1}) when is_float(number),
    do: Float.round(number, 1)

  def round(number, %__MODULE__{round_factor: 1.0}) when is_float(number),
    do: Float.round(number, 0)

  def round(number, %__MODULE__{round_factor: 0.05}) when is_float(number) do
    Float.round(number * 2, 1) / 2
  end
end
