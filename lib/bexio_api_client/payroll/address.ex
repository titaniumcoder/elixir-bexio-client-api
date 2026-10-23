defmodule BexioApiClient.Payroll.Address do
  @moduledoc """
  Address of a payroll employee.
  """

  @typedoc """
  Address of a payroll employee.
  """
  @type t :: %__MODULE__{
          complementary_line: String.t() | nil,
          street: String.t() | nil,
          street_name: String.t() | nil,
          house_number: String.t() | nil,
          postbox: String.t() | nil,
          locality: String.t() | nil,
          zip_code: String.t() | nil,
          city: String.t() | nil,
          country: String.t() | nil,
          canton: String.t() | nil,
          municipality_id: String.t() | nil
        }
  defstruct [
    :complementary_line,
    :street,
    :street_name,
    :house_number,
    :postbox,
    :locality,
    :zip_code,
    :city,
    :country,
    :canton,
    :municipality_id
  ]
end
