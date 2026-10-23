defmodule BexioApiClient.Payroll.Employee do
  @moduledoc """
  Payroll Employee.
  """

  alias BexioApiClient.Payroll.Address

  @typedoc """
  Payroll Employee.

  ## Fields:

    * `:annual_vacation_days_used` - not part of the list response, only of the single/create response
    * `:annual_vacation_days_left` - not part of the list response, only of the single/create response
    * `:effective_working_hours_per_week` - not part of the list response, only of the single/create response
    * `:annual_vacation_days` - only used in create/update requests, the responses contain
      `:annual_vacation_days_total` instead
  """
  @type t :: %__MODULE__{
          id: String.t(),
          first_name: String.t(),
          last_name: String.t(),
          date_of_birth: Date.t() | nil,
          ahv_number: String.t() | nil,
          gender: :male | :female | nil,
          nationality: String.t() | nil,
          stay_permit_category: String.t() | nil,
          language: :de | :it | :fr | :en | nil,
          marital_status:
            :unknown
            | :single
            | :married
            | :separated
            | :registered_partnership
            | :partnership_dissolved_by_law
            | :partnership_dissolved_by_death
            | :partnership_dissolved_by_declaration_of_lost
            | :widowed
            | :divorced
            | nil,
          email: String.t() | nil,
          phone_number: String.t() | nil,
          hours_per_week: number() | nil,
          employment_level: number() | nil,
          annual_vacation_days_total: number() | nil,
          address: Address.t() | nil,
          personal_number: String.t() | nil,
          iban: String.t() | nil,
          annual_vacation_days_used: number() | nil,
          annual_vacation_days_left: number() | nil,
          effective_working_hours_per_week: number() | nil,
          annual_vacation_days: integer() | nil
        }
  @enforce_keys [:id, :first_name, :last_name]
  defstruct [
    :id,
    :first_name,
    :last_name,
    :date_of_birth,
    :ahv_number,
    :gender,
    :nationality,
    :stay_permit_category,
    :language,
    :marital_status,
    :email,
    :phone_number,
    :hours_per_week,
    :employment_level,
    :annual_vacation_days_total,
    :address,
    :personal_number,
    :iban,
    :annual_vacation_days_used,
    :annual_vacation_days_left,
    :effective_working_hours_per_week,
    :annual_vacation_days
  ]

  @doc """
  Builds a new employee for creating or updating via the API.
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        email: nil,
        first_name: nil,
        last_name: nil,
        personal_number: nil,
        nationality: nil,
        iban: nil,
        ahv_number: nil,
        marital_status: :unknown,
        gender: nil,
        date_of_birth: nil,
        address: nil,
        language: :de,
        phone_number: nil,
        annual_vacation_days: nil
      },
      attrs
    )
  end
end
