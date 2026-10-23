defmodule BexioApiClient.PayrollTest do
  use TestHelper

  use ExUnit.Case, async: true

  doctest BexioApiClient.Payroll

  alias BexioApiClient.Payroll.Absence
  alias BexioApiClient.Payroll.Address
  alias BexioApiClient.Payroll.Employee

  @employee_id "497f6eca-6276-4993-bfeb-53cbbbba6f08"
  @absence_id "98d4a2a1-1a2b-4c3d-8e5f-6a7b8c9d0e1f"

  defp employee_response(extra_fields \\ %{}) do
    Map.merge(
      %{
        "id" => @employee_id,
        "first_name" => "Anna",
        "last_name" => "Muster",
        "date_of_birth" => "1990-05-21",
        "ahv_number" => "756.1234.5678.97",
        "gender" => "female",
        "nationality" => "CH",
        "stay_permit_category" => "string",
        "language" => "de",
        "marital_status" => "single",
        "email" => "anna.muster@example.com",
        "phone_number" => "+41 79 123 45 67",
        "hours_per_week" => 42,
        "employment_level" => 100,
        "annual_vacation_days_total" => 25,
        "address" => %{
          "complementary_line" => "c/o Muster",
          "street" => "Musterstrasse 1",
          "street_name" => "Musterstrasse",
          "house_number" => "1",
          "postbox" => "Postfach 10",
          "locality" => "Zurich",
          "zip_code" => "8000",
          "city" => "Zurich",
          "country" => "CH",
          "canton" => "ZH",
          "municipality_id" => "0261"
        },
        "personal_number" => "PN-1",
        "iban" => "CH9300762011623852957"
      },
      extra_fields
    )
  end

  defp absence_response do
    %{
      "id" => @absence_id,
      "reason" => "Injury",
      "start_date" => "2024-01-31",
      "end_date" => "2024-02-02",
      "half_day" => false,
      "continued_pay" => 8.5,
      "disability" => 0,
      "paid_hours" => 0
    }
  end

  describe "fetching a list of employees" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/4.0/payroll/employees"} = conn ->
          json(conn, %{"data" => [employee_response()]})
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Payroll.fetch_employees(client)

      assert result.id == @employee_id
      assert result.first_name == "Anna"
      assert result.last_name == "Muster"
      assert result.date_of_birth == ~D[1990-05-21]
      assert result.ahv_number == "756.1234.5678.97"
      assert result.gender == :female
      assert result.nationality == "CH"
      assert result.stay_permit_category == "string"
      assert result.language == :de
      assert result.marital_status == :single
      assert result.email == "anna.muster@example.com"
      assert result.phone_number == "+41 79 123 45 67"
      assert result.hours_per_week == 42
      assert result.employment_level == 100
      assert result.annual_vacation_days_total == 25
      assert result.personal_number == "PN-1"
      assert result.iban == "CH9300762011623852957"

      # not part of the list response
      assert result.annual_vacation_days_used == nil
      assert result.annual_vacation_days_left == nil
      assert result.effective_working_hours_per_week == nil

      assert %Address{} = result.address
      assert result.address.complementary_line == "c/o Muster"
      assert result.address.street == "Musterstrasse 1"
      assert result.address.street_name == "Musterstrasse"
      assert result.address.house_number == "1"
      assert result.address.postbox == "Postfach 10"
      assert result.address.locality == "Zurich"
      assert result.address.zip_code == "8000"
      assert result.address.city == "Zurich"
      assert result.address.country == "CH"
      assert result.address.canton == "ZH"
      assert result.address.municipality_id == "0261"
    end
  end

  describe "creating an employee" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/4.0/payroll/employees"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["email"] == "anna.muster@example.com"
          assert body_json["first_name"] == "Anna"
          assert body_json["last_name"] == "Muster"
          assert body_json["personal_number"] == "PN-1"
          assert body_json["nationality"] == "CH"
          assert body_json["iban"] == "CH9300762011623852957"
          assert body_json["ahv_number"] == "756.1234.5678.97"
          assert body_json["marital_status"] == "single"
          assert body_json["gender"] == "female"
          assert body_json["date_of_birth"] == "1990-05-21"
          assert body_json["language"] == "de"
          assert body_json["phone_number"] == "+41 79 123 45 67"
          assert body_json["annual_vacation_days"] == 25
          assert body_json["address"]["street_name"] == "Musterstrasse"
          assert body_json["address"]["house_number"] == "1"
          assert body_json["address"]["municipality_id"] == "0261"
          refute Map.has_key?(body_json["address"], "locality")

          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.send_resp(201, Jason.encode!(employee_response()))
      end)

      :ok
    end

    test "creates the new employee" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Payroll.create_employee(
                 client,
                 Employee.new(%{
                   email: "anna.muster@example.com",
                   first_name: "Anna",
                   last_name: "Muster",
                   personal_number: "PN-1",
                   nationality: "CH",
                   iban: "CH9300762011623852957",
                   ahv_number: "756.1234.5678.97",
                   marital_status: :single,
                   gender: :female,
                   date_of_birth: ~D[1990-05-21],
                   language: :de,
                   phone_number: "+41 79 123 45 67",
                   annual_vacation_days: 25,
                   address: %Address{
                     street_name: "Musterstrasse",
                     house_number: "1",
                     municipality_id: "0261"
                   }
                 })
               )

      assert result.id == @employee_id
      assert result.first_name == "Anna"
      assert result.last_name == "Muster"
      assert result.date_of_birth == ~D[1990-05-21]
      assert result.gender == :female
      assert result.language == :de
      assert result.marital_status == :single
      assert result.annual_vacation_days_total == 25
      assert result.address.street_name == "Musterstrasse"
    end

    test "fails on invalid data" do
      client = BexioApiClient.new("123")

      mock_request(fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(
          400,
          Jason.encode!(%{"status" => 400, "title" => "Malformed content"})
        )
      end)

      assert {:error, :bad_request, %{"status" => 400}} =
               BexioApiClient.Payroll.create_employee(client, Employee.new())
    end
  end

  describe "fetching a single employee" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/4.0/payroll/employees/" <> employee_id} = conn ->
          conn = fetch_query_params(conn)
          assert employee_id == @employee_id
          assert conn.query_params["date"] == "2024-07-01"

          json(
            conn,
            employee_response(%{
              "annual_vacation_days_used" => 5,
              "annual_vacation_days_left" => 20,
              "effective_working_hours_per_week" => 42
            })
          )
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Payroll.fetch_employee(client, @employee_id, ~D[2024-07-01])

      assert result.id == @employee_id
      assert result.annual_vacation_days_used == 5
      assert result.annual_vacation_days_left == 20
      assert result.effective_working_hours_per_week == 42
    end
  end

  describe "updating an employee" do
    setup do
      mock_request(fn
        %{method: "PATCH", request_path: "/4.0/payroll/employees/" <> employee_id} = conn ->
          assert employee_id == @employee_id

          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["first_name"] == "Anna"
          assert body_json["date_of_birth"] == "1990-05-21"
          assert body_json["address"]["street_name"] == "Musterstrasse"

          send_resp(conn, 204, "")
      end)

      :ok
    end

    test "updates the employee" do
      client = BexioApiClient.new("123")

      assert {:ok, true} =
               BexioApiClient.Payroll.update_employee(
                 client,
                 Employee.new(%{
                   id: @employee_id,
                   first_name: "Anna",
                   last_name: "Muster",
                   date_of_birth: ~D[1990-05-21],
                   address: %Address{street_name: "Musterstrasse"}
                 })
               )
    end
  end

  describe "fetching the absences of an employee" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/4.0/payroll/employees/" <> _rest
        } = conn ->
          conn = fetch_query_params(conn)
          assert conn.request_path == "/4.0/payroll/employees/#{@employee_id}/absences"
          assert conn.query_params["businessYear"] == "2024"

          json(conn, %{"data" => [absence_response()]})
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.Payroll.fetch_employee_absences(client, @employee_id, 2024)

      assert result.id == @absence_id
      assert result.reason == "Injury"
      assert result.start_date == ~D[2024-01-31]
      assert result.end_date == ~D[2024-02-02]
      assert result.half_day? == false
      assert result.continued_pay == Decimal.new("8.5")
      assert result.disability == Decimal.new(0)
      assert result.paid_hours == Decimal.new(0)
    end
  end

  describe "creating an absence for an employee" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/4.0/payroll/employees/" <> _rest
        } = conn ->
          assert conn.request_path == "/4.0/payroll/employees/#{@employee_id}/absences"

          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["reason"] == "Injury"
          assert body_json["start_date"] == "2024-01-31"
          assert body_json["end_date"] == "2024-02-02"
          assert body_json["half_day"] == false
          assert body_json["continued_pay"] == "8.5"

          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.send_resp(201, Jason.encode!(absence_response()))
      end)

      :ok
    end

    test "creates the new absence" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Payroll.create_employee_absence(
                 client,
                 @employee_id,
                 Absence.new(%{
                   reason: "Injury",
                   start_date: ~D[2024-01-31],
                   end_date: ~D[2024-02-02],
                   continued_pay: Decimal.new("8.5")
                 })
               )

      assert result.id == @absence_id
      assert result.reason == "Injury"
      assert result.start_date == ~D[2024-01-31]
      assert result.end_date == ~D[2024-02-02]
      assert result.half_day? == false
      assert result.continued_pay == Decimal.new("8.5")
    end
  end

  describe "fetching a single absence of an employee" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/4.0/payroll/employees/" <> _rest
        } = conn ->
          assert conn.request_path ==
                   "/4.0/payroll/employees/#{@employee_id}/absences/#{@absence_id}"

          json(conn, absence_response())
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Payroll.fetch_employee_absence(client, @employee_id, @absence_id)

      assert result.id == @absence_id
      assert result.reason == "Injury"
      assert result.start_date == ~D[2024-01-31]
    end

    test "fails on unknown absence id" do
      client = BexioApiClient.new("123")

      mock_request(fn conn ->
        Plug.Conn.send_resp(conn, 404, "Employee or absence not found")
      end)

      assert {:error, :not_found, "Employee or absence not found"} =
               BexioApiClient.Payroll.fetch_employee_absence(
                 client,
                 @employee_id,
                 "unknown-absence"
               )
    end
  end

  describe "updating an absence of an employee" do
    setup do
      mock_request(fn
        %{
          method: "PUT",
          request_path: "/4.0/payroll/employees/" <> _rest
        } = conn ->
          assert conn.request_path ==
                   "/4.0/payroll/employees/#{@employee_id}/absences/#{@absence_id}"

          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["reason"] == "Injury"
          assert body_json["start_date"] == "2024-01-31"
          assert body_json["half_day"] == true

          send_resp(conn, 204, "")
      end)

      :ok
    end

    test "updates the absence" do
      client = BexioApiClient.new("123")

      assert {:ok, true} =
               BexioApiClient.Payroll.update_employee_absence(
                 client,
                 @employee_id,
                 Absence.new(%{
                   id: @absence_id,
                   reason: "Injury",
                   start_date: ~D[2024-01-31],
                   half_day?: true
                 })
               )
    end
  end

  describe "deleting an absence of an employee" do
    setup do
      mock_request(fn
        %{
          method: "DELETE",
          request_path: "/4.0/payroll/employees/" <> _rest
        } = conn ->
          assert conn.request_path ==
                   "/4.0/payroll/employees/#{@employee_id}/absences/#{@absence_id}"

          send_resp(conn, 204, "")
      end)

      :ok
    end

    test "deletes the absence" do
      client = BexioApiClient.new("123")

      assert {:ok, true} =
               BexioApiClient.Payroll.delete_employee_absence(client, @employee_id, @absence_id)
    end

    test "fails on unknown absence id" do
      client = BexioApiClient.new("123")

      mock_request(fn conn ->
        Plug.Conn.send_resp(conn, 404, "Employee or absence not found")
      end)

      assert {:error, :not_found, "Employee or absence not found"} =
               BexioApiClient.Payroll.delete_employee_absence(
                 client,
                 @employee_id,
                 "unknown-absence"
               )
    end
  end

  describe "downloading the paystub pdf of an employee" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/4.0/payroll/employees/" <> _rest
        } = conn ->
          assert conn.request_path ==
                   "/4.0/payroll/employees/#{@employee_id}/paystub-pdf-download/2024/7"

          conn
          |> Plug.Conn.put_resp_content_type("application/pdf", nil)
          |> Plug.Conn.send_resp(200, "%PDF-1.4 fake pdf")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, {body, content_type}} =
               BexioApiClient.Payroll.download_paystub_pdf(client, @employee_id, 2024, 7)

      assert body == "%PDF-1.4 fake pdf"
      assert "application/pdf" in content_type
    end
  end
end
