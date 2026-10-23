defmodule BexioApiClient.Payroll.Absence do
  @moduledoc """
  Absence of a payroll employee.
  """

  @typedoc """
  Absence of a payroll employee.

  The `:reason` is a free-form string, currently supported by bexio: `Injury`,
  `Sickness`, `MaternityLeave`, `MilitaryLeave`, `Vacation`,
  `InterruptionOfWork`. New reasons might be added in the future, so it is not
  parsed into an atom.
  """
  @type t :: %__MODULE__{
          id: String.t(),
          reason: String.t(),
          start_date: Date.t(),
          end_date: Date.t() | nil,
          half_day?: boolean(),
          continued_pay: Decimal.t() | nil,
          disability: Decimal.t() | nil,
          paid_hours: Decimal.t() | nil
        }
  @enforce_keys [:id, :reason, :start_date, :half_day?]
  defstruct [
    :id,
    :reason,
    :start_date,
    :end_date,
    :half_day?,
    :continued_pay,
    :disability,
    :paid_hours
  ]

  @doc """
  Builds a new absence for creating or updating via the API.
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        reason: nil,
        start_date: nil,
        end_date: nil,
        half_day?: false,
        continued_pay: nil,
        disability: nil,
        paid_hours: nil
      },
      attrs
    )
  end
end
