defmodule BexioApiClient.Payroll do
  @moduledoc """
  Bexio API for the payroll part of the API (the `/4.0/payroll` endpoints).
  """

  import BexioApiClient.Helpers

  alias BexioApiClient.Payroll.Absence
  alias BexioApiClient.Payroll.Address
  alias BexioApiClient.Payroll.Employee

  @type api_error_type :: BexioApiClient.Helpers.api_error_type()

  @doc """
  Fetch a list of all active employees.
  """
  @spec fetch_employees(req :: Req.Request.t()) ::
          {:ok, [Employee.t()]} | api_error_type()
  def fetch_employees(req) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/4.0/payroll/employees")
      end,
      &map_from_employees/2
    )
  end

  @doc """
  Create an employee.

  The nation (`nationality`) should be in ISO Alpha-2 format; the special
  values `'11'` mean 'unknown' and `'22'` mean 'stateless'.
  """
  @spec create_employee(req :: Req.Request.t(), employee :: Employee.t()) ::
          {:ok, Employee.t()} | api_error_type()
  def create_employee(req, employee) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/4.0/payroll/employees", json: remap_employee(employee))
      end,
      &map_from_employee/2
    )
  end

  @doc """
  Fetch a single employee on a specific date.

  The `date` is the date of the employee's state that is retrieved.
  """
  @spec fetch_employee(req :: Req.Request.t(), employee_id :: String.t(), date :: Date.t()) ::
          {:ok, Employee.t()} | api_error_type()
  def fetch_employee(req, employee_id, date) do
    bexio_body_handling(
      fn ->
        Req.get(req,
          url: "/4.0/payroll/employees/#{employee_id}",
          params: [date: to_iso8601(date)]
        )
      end,
      &map_from_employee/2
    )
  end

  @doc """
  Update an employee.
  """
  @spec update_employee(req :: Req.Request.t(), employee :: Employee.t()) ::
          {:ok, true} | api_error_type()
  def update_employee(req, employee) do
    bexio_no_content_handling(fn ->
      Req.patch(
        req,
        url: "/4.0/payroll/employees/#{employee.id}",
        json: remap_employee(employee)
      )
    end)
  end

  @doc """
  Fetch the absences of an employee for a given business year.
  """
  @spec fetch_employee_absences(
          req :: Req.Request.t(),
          employee_id :: String.t(),
          business_year :: integer()
        ) ::
          {:ok, [Absence.t()]} | api_error_type()
  def fetch_employee_absences(req, employee_id, business_year) do
    bexio_body_handling(
      fn ->
        Req.get(req,
          url: "/4.0/payroll/employees/#{employee_id}/absences",
          params: [businessYear: business_year]
        )
      end,
      &map_from_absences/2
    )
  end

  @doc """
  Create an absence for an employee.

  Currently supported reasons: `Injury`, `Sickness`, `MaternityLeave`,
  `MilitaryLeave`, `Vacation`, `InterruptionOfWork` (new reasons might be added
  by bexio in the future).
  """
  @spec create_employee_absence(
          req :: Req.Request.t(),
          employee_id :: String.t(),
          absence :: Absence.t()
        ) ::
          {:ok, Absence.t()} | api_error_type()
  def create_employee_absence(req, employee_id, absence) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/4.0/payroll/employees/#{employee_id}/absences",
          json: remap_absence(absence)
        )
      end,
      &map_from_absence/2
    )
  end

  @doc """
  Fetch a single absence of an employee.
  """
  @spec fetch_employee_absence(
          req :: Req.Request.t(),
          employee_id :: String.t(),
          absence_id :: String.t()
        ) ::
          {:ok, Absence.t()} | api_error_type()
  def fetch_employee_absence(req, employee_id, absence_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/4.0/payroll/employees/#{employee_id}/absences/#{absence_id}")
      end,
      &map_from_absence/2
    )
  end

  @doc """
  Update an existing absence of an employee.

  Unlike when creating an absence, all fields of the absence are required by
  the API.
  """
  @spec update_employee_absence(
          req :: Req.Request.t(),
          employee_id :: String.t(),
          absence :: Absence.t()
        ) ::
          {:ok, true} | api_error_type()
  def update_employee_absence(req, employee_id, absence) do
    bexio_no_content_handling(fn ->
      Req.put(
        req,
        url: "/4.0/payroll/employees/#{employee_id}/absences/#{absence.id}",
        json: remap_absence(absence)
      )
    end)
  end

  @doc """
  Delete an absence of an employee.
  """
  @spec delete_employee_absence(
          req :: Req.Request.t(),
          employee_id :: String.t(),
          absence_id :: String.t()
        ) ::
          {:ok, true} | api_error_type()
  def delete_employee_absence(req, employee_id, absence_id) do
    bexio_no_content_handling(fn ->
      Req.delete(req, url: "/4.0/payroll/employees/#{employee_id}/absences/#{absence_id}")
    end)
  end

  @doc """
  Download the paystub PDF for an employee for a given month.

  Returns the PDF file contents together with the response's content type.
  """
  @spec download_paystub_pdf(
          req :: Req.Request.t(),
          employee_id :: String.t(),
          year :: integer(),
          month :: integer()
        ) ::
          {:ok, {String.t(), any()}} | api_error_type()
  def download_paystub_pdf(req, employee_id, year, month) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/4.0/payroll/employees/#{employee_id}/paystub-pdf-download/#{year}/#{month}"
        )
      end,
      fn body, response -> {body, Req.Response.get_header(response, "content-type")} end
    )
  end

  defp map_from_employees(%{"data" => employees}, _response),
    do: Enum.map(employees, &map_from_employee/1)

  defp map_from_employee(
         %{
           "id" => id,
           "first_name" => first_name,
           "last_name" => last_name,
           "date_of_birth" => date_of_birth,
           "ahv_number" => ahv_number,
           "gender" => gender,
           "nationality" => nationality,
           "stay_permit_category" => stay_permit_category,
           "language" => language,
           "marital_status" => marital_status,
           "email" => email,
           "phone_number" => phone_number,
           "hours_per_week" => hours_per_week,
           "employment_level" => employment_level,
           "annual_vacation_days_total" => annual_vacation_days_total,
           "address" => address,
           "personal_number" => personal_number,
           "iban" => iban
         } = employee,
         _response \\ nil
       ) do
    %Employee{
      id: id,
      first_name: first_name,
      last_name: last_name,
      date_of_birth: to_date(date_of_birth),
      ahv_number: ahv_number,
      gender: to_enum(gender, [:male, :female]),
      nationality: nationality,
      stay_permit_category: stay_permit_category,
      language: to_enum(language, [:de, :it, :fr, :en]),
      marital_status:
        to_enum(marital_status, [
          :unknown,
          :single,
          :married,
          :separated,
          :registered_partnership,
          :partnership_dissolved_by_law,
          :partnership_dissolved_by_death,
          :partnership_dissolved_by_declaration_of_lost,
          :widowed,
          :divorced
        ]),
      email: email,
      phone_number: phone_number,
      hours_per_week: hours_per_week,
      employment_level: employment_level,
      annual_vacation_days_total: annual_vacation_days_total,
      address: if(is_nil(address), do: nil, else: map_from_address(address)),
      personal_number: personal_number,
      iban: iban,
      # not present in the list response
      annual_vacation_days_used: Map.get(employee, "annual_vacation_days_used"),
      annual_vacation_days_left: Map.get(employee, "annual_vacation_days_left"),
      effective_working_hours_per_week: Map.get(employee, "effective_working_hours_per_week")
    }
  end

  defp map_from_address(%{
         "complementary_line" => complementary_line,
         "street" => street,
         "street_name" => street_name,
         "house_number" => house_number,
         "postbox" => postbox,
         "locality" => locality,
         "zip_code" => zip_code,
         "city" => city,
         "country" => country,
         "canton" => canton,
         "municipality_id" => municipality_id
       }) do
    %Address{
      complementary_line: complementary_line,
      street: street,
      street_name: street_name,
      house_number: house_number,
      postbox: postbox,
      locality: locality,
      zip_code: zip_code,
      city: city,
      country: country,
      canton: canton,
      municipality_id: municipality_id
    }
  end

  defp map_from_absences(%{"data" => absences}, _response),
    do: Enum.map(absences, &map_from_absence/1)

  defp map_from_absence(
         %{
           "id" => id,
           "reason" => reason,
           "start_date" => start_date,
           "end_date" => end_date,
           "half_day" => half_day?,
           "continued_pay" => continued_pay,
           "disability" => disability,
           "paid_hours" => paid_hours
         },
         _response \\ nil
       ) do
    %Absence{
      id: id,
      reason: reason,
      start_date: Date.from_iso8601!(start_date),
      end_date: to_date(end_date),
      half_day?: half_day?,
      continued_pay: to_decimal_or_nil(continued_pay),
      disability: to_decimal_or_nil(disability),
      paid_hours: to_decimal_or_nil(paid_hours)
    }
  end

  # the absence amounts are documented as plain numbers and may be null
  defp to_decimal_or_nil(nil), do: nil
  defp to_decimal_or_nil(value) when is_binary(value), do: Decimal.new(value)
  defp to_decimal_or_nil(value) when is_integer(value), do: Decimal.new(value)
  defp to_decimal_or_nil(value) when is_float(value), do: Decimal.from_float(value)

  defp remap_employee(employee) do
    employee
    |> Map.take([
      :email,
      :first_name,
      :last_name,
      :personal_number,
      :nationality,
      :iban,
      :ahv_number,
      :marital_status,
      :gender,
      :language,
      :phone_number,
      :annual_vacation_days
    ])
    |> Map.put(:date_of_birth, to_iso8601(employee.date_of_birth))
    |> Map.put(:address, remap_address(employee.address))
  end

  defp remap_address(nil), do: nil

  defp remap_address(address) do
    address
    |> Map.from_struct()
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Enum.into(%{})
  end

  defp remap_absence(absence) do
    absence
    |> Map.take([:reason, :end_date])
    |> Map.put(:start_date, to_iso8601(absence.start_date))
    |> Map.put(:half_day, absence.half_day?)
    |> Map.put(:continued_pay, to_number_string(absence.continued_pay))
    |> Map.put(:disability, to_number_string(absence.disability))
    |> Map.put(:paid_hours, to_number_string(absence.paid_hours))
  end

  # numbers are sent as strings like in the other areas of this library
  defp to_number_string(nil), do: nil
  defp to_number_string(%Decimal{} = decimal), do: Decimal.to_string(decimal, :normal)
end
