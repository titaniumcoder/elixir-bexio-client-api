defmodule BexioApiClient.AccountingTest do
  use TestHelper

  use ExUnit.Case, async: true

  doctest BexioApiClient.Accounting

  alias BexioApiClient.SearchCriteria

  describe "fetching a list of accounts" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/accounts"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "account_no" => "3201",
              "name" => "Gross proceeds credit sales",
              "fibu_account_group_id" => 65,
              "account_type" => 1,
              "tax_id" => 40,
              "is_active" => true,
              "is_locked" => false
            },
            %{
              "id" => 2,
              "account_no" => "3202",
              "name" => "Gross proceeds credit sales 2",
              "fibu_account_group_id" => 66,
              "account_type" => 2,
              "tax_id" => 41,
              "is_active" => false,
              "is_locked" => true
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} = BexioApiClient.Accounting.fetch_accounts(client)

      assert result1.id == 1
      assert result1.account_no == "3201"
      assert result1.name == "Gross proceeds credit sales"
      assert result1.account_group_id == 65
      assert result1.account_type == :earning
      assert result1.tax_id == 40
      assert result1.active? == true
      assert result1.locked? == false

      assert result2.id == 2
      assert result2.account_no == "3202"
      assert result2.name == "Gross proceeds credit sales 2"
      assert result2.account_group_id == 66
      assert result2.account_type == :expenditure
      assert result2.tax_id == 41
      assert result2.active? == false
      assert result2.locked? == true
    end
  end

  describe "searching accounts" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/accounts/search"
        } = conn ->
          json(conn, [
            %{
              "id" => 1,
              "account_no" => "3201",
              "name" => "Gross proceeds credit sales",
              "fibu_account_group_id" => 65,
              "account_type" => 1,
              "tax_id" => 40,
              "is_active" => true,
              "is_locked" => false
            },
            %{
              "id" => 2,
              "account_no" => "3202-22",
              "name" => "Gross proceeds credit sales 2",
              "fibu_account_group_id" => 66,
              "account_type" => 2,
              "tax_id" => 41,
              "is_active" => false,
              "is_locked" => true
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} =
               BexioApiClient.Accounting.search_accounts(
                 client,
                 [
                   SearchCriteria.nil?(:account_no),
                   SearchCriteria.part_of(:name, ["fred", "queen"])
                 ]
               )

      assert result1.id == 1
      assert result1.account_no == "3201"
      assert result1.name == "Gross proceeds credit sales"
      assert result1.account_group_id == 65
      assert result1.account_type == :earning
      assert result1.tax_id == 40
      assert result1.active? == true
      assert result1.locked? == false

      assert result2.id == 2
      assert result2.account_no == "3202-22"
      assert result2.name == "Gross proceeds credit sales 2"
      assert result2.account_group_id == 66
      assert result2.account_type == :expenditure
      assert result2.tax_id == 41
      assert result2.active? == false
      assert result2.locked? == true
    end
  end

  describe "fetching a list of account groups" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/account_groups"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "account_no" => "1-1",
              "name" => "Assets",
              "parent_fibu_account_group_id" => 3,
              "is_active" => true,
              "is_locked" => false
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Accounting.fetch_account_groups(client)

      assert result.id == 1
      assert result.account_no == "1-1"
      assert result.name == "Assets"
      assert result.parent_fibu_account_group_id == 3
      assert result.active? == true
      assert result.locked? == false
    end
  end

  describe "fetching a list of calendar years" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/calendar_years"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "start" => "2018-01-01",
              "end" => "2018-12-31",
              "is_vat_subject" => true,
              "is_annual_reporting" => false,
              "created_at" => "2017-04-28T19:58:58+00:00",
              "updated_at" => "2018-04-30T19:58:58+00:00",
              "vat_accounting_method" => "effective",
              "vat_accounting_type" => "agreed"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Accounting.fetch_calendar_years(client)

      assert result.id == 1
      assert result.start == ~D[2018-01-01]
      assert result.end == ~D[2018-12-31]
      assert result.vat_subject? == true
      assert result.created_at == ~U[2017-04-28 19:58:58Z]
      assert result.updated_at == ~U[2018-04-30 19:58:58Z]
      assert result.vat_accounting_method == :effective
      assert result.vat_accounting_type == :agreed
    end
  end

  describe "fetching a list of currencies" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/currencies"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "CHF",
              "round_factor" => 0.05
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Accounting.fetch_currencies(client)

      assert result.id == 1
      assert result.name == "CHF"
      assert result.round_factor == 0.05
    end
  end

  describe "fetch exchange rates for currencies" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/currencies/1/exchange_rates"} = conn ->
          json(conn, [
            %{
              "factor_nr" => 1.2,
              "exchange_currency" => %{
                "id" => 1,
                "name" => "CHF",
                "round_factor" => 0.05
              }
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Accounting.fetch_exchange_rates(client, 1)

      assert result.factor == 1.2
      assert result.exchange_currency.id == 1
      assert result.exchange_currency.name == "CHF"
      assert result.exchange_currency.round_factor == 0.05
    end
  end

  describe "fetch a list of taxes" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/taxes"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "uuid" => "8078b1f3-f85b-4adf-aaa8-c3eeea964927",
              "name" => "lib.model.tax.ch.sales_7_7.name",
              "code" => "UN77",
              "digit" => 302,
              "type" => "sales_tax",
              "account_id" => 98,
              "tax_settlement_type" => "none",
              "value" => 7.7,
              "net_tax_value" => nil,
              "start_year" => 2017,
              "end_year" => 2018,
              "start_month" => 1,
              "end_month" => 12,
              "is_active" => true,
              "display_name" => "ZOLLM  - Import Mat/SV 100.00%"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Accounting.fetch_taxes(client)

      assert result.id == 1
      assert result.uuid == "8078b1f3-f85b-4adf-aaa8-c3eeea964927"
      assert result.name == "lib.model.tax.ch.sales_7_7.name"
      assert result.code == "UN77"
      assert result.digit == 302
      assert result.type == :sales_tax
      assert result.account_id == 98
      assert result.tax_settlement_type == "none"
      assert result.value == 7.7
      assert result.net_tax_value == nil
      assert result.start_year == 2017
      assert result.end_year == 2018
      assert result.active? == true
      assert result.display_name == "ZOLLM  - Import Mat/SV 100.00%"
    end
  end

  describe "creating calendar years" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/3.0/accounting/calendar_years"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["year"] == "2018"
          assert body_json["is_vat_subject"] == true
          assert body_json["is_annual_reporting"] == false
          assert body_json["vat_accounting_method"] == "effective"
          assert body_json["vat_accounting_type"] == "agreed"
          assert body_json["default_tax_income_id"] == 1
          assert body_json["default_tax_expense_id"] == 2

          json(conn, [
            %{
              "id" => 1,
              "start" => "2018-01-01",
              "end" => "2018-12-31",
              "is_vat_subject" => true,
              "is_annual_reporting" => false,
              "created_at" => "2017-04-28T19:58:58+00:00",
              "updated_at" => "2018-04-30T19:58:58+00:00",
              "vat_accounting_method" => "effective",
              "vat_accounting_type" => "agreed"
            }
          ])
      end)

      :ok
    end

    test "creates the calendar year" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.Accounting.create_calendar_year(client, "2018",
                 vat_subject?: true,
                 annual_reporting?: false,
                 vat_accounting_method: :effective,
                 vat_accounting_type: :agreed,
                 default_tax_income_id: 1,
                 default_tax_expense_id: 2
               )

      assert result.id == 1
      assert result.start == ~D[2018-01-01]
      assert result.end == ~D[2018-12-31]
      assert result.vat_subject? == true
      assert result.annual_reporting? == false
      assert result.created_at == ~U[2017-04-28 19:58:58Z]
      assert result.updated_at == ~U[2018-04-30 19:58:58Z]
      assert result.vat_accounting_method == :effective
      assert result.vat_accounting_type == :agreed
    end
  end

  describe "searching calendar years" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/3.0/accounting/calendar_years/search"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "start" => "2018-01-01",
              "end" => "2018-12-31",
              "is_vat_subject" => true,
              "is_annual_reporting" => false,
              "created_at" => "2017-04-28T19:58:58+00:00",
              "updated_at" => "2018-04-30T19:58:58+00:00",
              "vat_accounting_method" => "effective",
              "vat_accounting_type" => "agreed"
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.Accounting.search_calendar_years(
                 client,
                 [SearchCriteria.equal(:start, "2018-01-01")],
                 limit: 100
               )

      assert result.id == 1
      assert result.start == ~D[2018-01-01]
      assert result.end == ~D[2018-12-31]
      assert result.vat_subject? == true
    end
  end

  describe "fetching a single calendar year" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/calendar_years/1"} = conn ->
          json(conn, %{
            "id" => 1,
            "start" => "2018-01-01",
            "end" => "2018-12-31",
            "is_vat_subject" => true,
            "is_annual_reporting" => false,
            "created_at" => "2017-04-28T19:58:58+00:00",
            "updated_at" => "2018-04-30T19:58:58+00:00",
            "vat_accounting_method" => "effective",
            "vat_accounting_type" => "agreed"
          })

        %{method: "GET", request_path: "/3.0/accounting/calendar_years/2"} = conn ->
          send_resp(conn, 404, "Calendar year does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Accounting.fetch_calendar_year(client, 1)

      assert result.id == 1
      assert result.start == ~D[2018-01-01]
      assert result.end == ~D[2018-12-31]
      assert result.vat_subject? == true
      assert result.annual_reporting? == false
      assert result.vat_accounting_method == :effective
      assert result.vat_accounting_type == :agreed
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Calendar year does not exist"} =
               BexioApiClient.Accounting.fetch_calendar_year(client, 2)
    end
  end

  describe "fetching a list of business years" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/business_years"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "start" => "2018-01-01",
              "end" => "2018-12-31",
              "status" => "open",
              "closed_at" => "2019-04-28"
            },
            %{
              "id" => 2,
              "start" => "2019-01-01",
              "end" => "2019-12-31",
              "status" => "open",
              "closed_at" => nil
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} = BexioApiClient.Accounting.fetch_business_years(client)

      assert result1.id == 1
      assert result1.start == ~D[2018-01-01]
      assert result1.end == ~D[2018-12-31]
      assert result1.status == :open
      assert result1.closed_at == ~D[2019-04-28]

      assert result2.id == 2
      assert result2.start == ~D[2019-01-01]
      assert result2.end == ~D[2019-12-31]
      assert result2.status == :open
      assert result2.closed_at == nil
    end
  end

  describe "fetching a single business year" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/business_years/1"} = conn ->
          json(conn, %{
            "id" => 1,
            "start" => "2018-01-01",
            "end" => "2018-12-31",
            "status" => "open",
            "closed_at" => "2019-04-28"
          })

        %{method: "GET", request_path: "/3.0/accounting/business_years/2"} = conn ->
          send_resp(conn, 404, "Business year does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Accounting.fetch_business_year(client, 1)

      assert result.id == 1
      assert result.start == ~D[2018-01-01]
      assert result.end == ~D[2018-12-31]
      assert result.status == :open
      assert result.closed_at == ~D[2019-04-28]
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Business year does not exist"} =
               BexioApiClient.Accounting.fetch_business_year(client, 2)
    end
  end

  describe "fetching a list of vat periods" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/vat_periods"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "start" => "2018-01-01",
              "end" => "2018-03-31",
              "type" => "quarter",
              "status" => "closed",
              "closed_at" => "2018-04-28"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Accounting.fetch_vat_periods(client)

      assert result.id == 1
      assert result.start == ~D[2018-01-01]
      assert result.end == ~D[2018-03-31]
      assert result.type == :quarter
      assert result.status == :closed
      assert result.closed_at == ~D[2018-04-28]
    end
  end

  describe "fetching a single vat period" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/vat_periods/1"} = conn ->
          json(conn, %{
            "id" => 1,
            "start" => "2018-01-01",
            "end" => "2018-03-31",
            "type" => "quarter",
            "status" => "closed",
            "closed_at" => "2018-04-28"
          })

        %{method: "GET", request_path: "/3.0/accounting/vat_periods/2"} = conn ->
          send_resp(conn, 404, "Vat period does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Accounting.fetch_vat_period(client, 1)

      assert result.id == 1
      assert result.start == ~D[2018-01-01]
      assert result.end == ~D[2018-03-31]
      assert result.type == :quarter
      assert result.status == :closed
      assert result.closed_at == ~D[2018-04-28]
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Vat period does not exist"} =
               BexioApiClient.Accounting.fetch_vat_period(client, 2)
    end
  end

  describe "fetching the journal" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/journal"} = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["from"] == "2019-02-01"
          assert conn.query_params["to"] == "2019-02-28"
          assert conn.query_params["account_uuid"] == "456fc553-f42b-417e-a2af-dd5c5b9bade6"

          json(conn, [
            %{
              "id" => 1,
              "ref_id" => 13,
              "ref_uuid" => "456fc553-f42b-417e-a2af-dd5c5b9bade6",
              "ref_class" => "KbInvoice",
              "date" => "2019-02-17T00:00:00+02:00",
              "debit_account_id" => 77,
              "credit_account_id" => 139,
              "description" => "Website for client Smith",
              "amount" => 328.25,
              "currency_id" => 1,
              "currency_factor" => 1,
              "base_currency_id" => 1,
              "base_currency_amount" => 328.25
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.Accounting.fetch_journal(client,
                 from: ~D[2019-02-01],
                 to: ~D[2019-02-28],
                 account_uuid: "456fc553-f42b-417e-a2af-dd5c5b9bade6"
               )

      assert result.id == 1
      assert result.ref_id == 13
      assert result.ref_uuid == "456fc553-f42b-417e-a2af-dd5c5b9bade6"
      assert result.ref_class == :kb_invoice
      assert result.date == ~U[2019-02-16 22:00:00Z]
      assert result.debit_account_id == 77
      assert result.credit_account_id == 139
      assert result.description == "Website for client Smith"
      assert Decimal.equal?(result.amount, Decimal.new("328.25"))
      assert result.currency_id == 1
      assert result.currency_factor == 1
      assert result.base_currency_id == 1
      assert Decimal.equal?(result.base_currency_amount, Decimal.new("328.25"))
    end
  end

  describe "creating a currency" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/3.0/currencies"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["name"] == "CHF"
          assert body_json["round_factor"] == 0.05

          json(conn, %{
            "id" => 1,
            "name" => "CHF",
            "round_factor" => 0.05
          })
      end)

      :ok
    end

    test "creates the currency" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Accounting.create_currency(
                 client,
                 BexioApiClient.Accounting.Currency.new(%{name: "CHF", round_factor: 0.05})
               )

      assert result.id == 1
      assert result.name == "CHF"
      assert result.round_factor == 0.05
      assert result.exchange_rate == nil
    end
  end

  describe "fetching a single currency" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/currencies/1"} = conn ->
          json(conn, %{
            "id" => 1,
            "name" => "CHF",
            "round_factor" => 0.05
          })

        %{method: "GET", request_path: "/3.0/currencies/2"} = conn ->
          send_resp(conn, 404, "Currency does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Accounting.fetch_currency(client, 1)

      assert result.id == 1
      assert result.name == "CHF"
      assert result.round_factor == 0.05
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Currency does not exist"} =
               BexioApiClient.Accounting.fetch_currency(client, 2)
    end
  end

  describe "updating a currency" do
    setup do
      mock_request(fn
        %{method: "PATCH", request_path: "/3.0/currencies/1"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["round_factor"] == 0.1

          json(conn, %{
            "id" => 1,
            "name" => "CHF",
            "round_factor" => 0.1
          })
      end)

      :ok
    end

    test "updates the currency" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Accounting.edit_currency(
                 client,
                 BexioApiClient.Accounting.Currency.new(%{id: 1, name: "CHF", round_factor: 0.1})
               )

      assert result.id == 1
      assert result.name == "CHF"
      assert result.round_factor == 0.1
    end
  end

  describe "deleting a currency" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/3.0/currencies/1"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the currency" do
      client = BexioApiClient.new("123")

      assert {:ok, true} = BexioApiClient.Accounting.delete_currency(client, 1)
    end
  end

  describe "fetching currency codes" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/currencies/codes"} = conn ->
          json(conn, [["EUR", "GBP", "PLN"]])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, codes} = BexioApiClient.Accounting.fetch_currency_codes(client)
      assert codes == ["EUR", "GBP", "PLN"]
    end
  end

  describe "fetching a list of manual entries" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/manual_entries"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "type" => "manual_single_entry",
              "date" => "2019-11-17",
              "reference_nr" => "Booking BA-22",
              "created_by_user_id" => 1,
              "edited_by_user_id" => 1,
              "entries" => [
                %{
                  "id" => 32,
                  "date" => "2019-11-17",
                  "debit_account_id" => 77,
                  "credit_account_id" => 139,
                  "tax_id" => 3,
                  "tax_account_id" => 77,
                  "description" => "Payment for client Smith",
                  "amount" => 328.25,
                  "currency_id" => 1,
                  "base_currency_id" => 1,
                  "currency_factor" => 1,
                  "base_currency_amount" => 328.25,
                  "created_by_user_id" => 1,
                  "edited_by_user_id" => 1
                }
              ],
              "is_locked" => false,
              "locked_info" => "closed_business_year"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Accounting.fetch_manual_entries(client)

      assert result.id == 1
      assert result.type == :manual_single_entry
      assert result.date == ~D[2019-11-17]
      assert result.reference_nr == "Booking BA-22"
      assert result.created_by_user_id == 1
      assert result.edited_by_user_id == 1
      assert result.locked? == false
      assert result.locked_info == "closed_business_year"

      assert [line] = result.entries
      assert line.id == 32
      assert line.date == ~D[2019-11-17]
      assert line.debit_account_id == 77
      assert line.credit_account_id == 139
      assert line.tax_id == 3
      assert line.tax_account_id == 77
      assert line.description == "Payment for client Smith"
      assert Decimal.equal?(line.amount, Decimal.new("328.25"))
      assert line.currency_id == 1
      assert line.base_currency_id == 1
      assert line.currency_factor == 1
      assert Decimal.equal?(line.base_currency_amount, Decimal.new("328.25"))
      assert line.created_by_user_id == 1
      assert line.edited_by_user_id == 1
    end
  end

  describe "creating a manual entry" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/3.0/accounting/manual_entries"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["type"] == "manual_single_entry"
          assert body_json["date"] == "2019-11-17"
          assert body_json["reference_nr"] == "Booking BA-22"
          refute Map.has_key?(body_json, "id")

          assert [entry] = body_json["entries"]
          assert entry["debit_account_id"] == 77
          assert entry["credit_account_id"] == 139
          assert entry["tax_id"] == 3
          assert entry["tax_account_id"] == 77
          assert entry["description"] == "Payment for client Smith"
          assert entry["amount"] == "328.25"
          assert entry["currency_id"] == 1
          assert entry["currency_factor"] == 1
          refute Map.has_key?(entry, "id")
          refute Map.has_key?(entry, "base_currency_amount")

          json(conn, %{
            "id" => 1,
            "type" => "manual_single_entry",
            "date" => "2019-11-17",
            "reference_nr" => "Booking BA-22",
            "created_by_user_id" => 1,
            "edited_by_user_id" => 1,
            "entries" => [
              %{
                "id" => 32,
                "date" => "2019-11-17",
                "debit_account_id" => 77,
                "credit_account_id" => 139,
                "tax_id" => 3,
                "tax_account_id" => 77,
                "description" => "Payment for client Smith",
                "amount" => 328.25,
                "currency_id" => 1,
                "currency_factor" => 1
              }
            ],
            "is_locked" => false,
            "locked_info" => nil
          })
      end)

      :ok
    end

    test "creates the manual entry" do
      client = BexioApiClient.new("123")

      manual_entry =
        BexioApiClient.Accounting.ManualEntry.new(%{
          date: ~D[2019-11-17],
          reference_nr: "Booking BA-22",
          entries: [
            BexioApiClient.Accounting.ManualEntryLine.new(%{
              debit_account_id: 77,
              credit_account_id: 139,
              tax_id: 3,
              tax_account_id: 77,
              description: "Payment for client Smith",
              amount: Decimal.new("328.25"),
              currency_id: 1,
              currency_factor: 1
            })
          ]
        })

      assert {:ok, result} = BexioApiClient.Accounting.create_manual_entry(client, manual_entry)

      assert result.id == 1
      assert result.type == :manual_single_entry
      assert result.date == ~D[2019-11-17]
      assert result.reference_nr == "Booking BA-22"

      assert [line] = result.entries
      assert line.id == 32
      assert Decimal.equal?(line.amount, Decimal.new("328.25"))
    end
  end

  describe "editing a manual entry" do
    setup do
      mock_request(fn
        %{method: "PUT", request_path: "/3.0/accounting/manual_entries/1"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["id"] == 1
          assert body_json["type"] == "manual_single_entry"

          assert [entry] = body_json["entries"]
          assert entry["id"] == 32

          json(conn, %{
            "id" => 1,
            "type" => "manual_single_entry",
            "date" => "2019-11-17",
            "reference_nr" => "Booking BA-22",
            "created_by_user_id" => 1,
            "edited_by_user_id" => 1,
            "entries" => [
              %{
                "id" => 32,
                "date" => "2019-11-17",
                "debit_account_id" => 77,
                "credit_account_id" => 139,
                "tax_id" => 3,
                "tax_account_id" => 77,
                "description" => "Payment for client Smith",
                "amount" => 328.25,
                "currency_id" => 1,
                "currency_factor" => 1
              }
            ],
            "is_locked" => false,
            "locked_info" => nil
          })
      end)

      :ok
    end

    test "edits the manual entry" do
      client = BexioApiClient.new("123")

      manual_entry =
        BexioApiClient.Accounting.ManualEntry.new(%{
          id: 1,
          date: ~D[2019-11-17],
          reference_nr: "Booking BA-22",
          entries: [
            BexioApiClient.Accounting.ManualEntryLine.new(%{
              id: 32,
              debit_account_id: 77,
              credit_account_id: 139,
              amount: Decimal.new("328.25"),
              currency_id: 1
            })
          ]
        })

      assert {:ok, result} = BexioApiClient.Accounting.edit_manual_entry(client, manual_entry)

      assert result.id == 1
      assert [line] = result.entries
      assert line.id == 32
    end
  end

  describe "deleting a manual entry" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/3.0/accounting/manual_entries/1"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the manual entry" do
      client = BexioApiClient.new("123")

      assert {:ok, true} = BexioApiClient.Accounting.delete_manual_entry(client, 1)
    end
  end

  describe "fetching the next manual entry reference number" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/manual_entries/next_ref_nr"} = conn ->
          json(conn, %{"next_ref_nr" => "Booking BA-22"})
      end)

      :ok
    end

    test "returns the next reference number" do
      client = BexioApiClient.new("123")

      assert {:ok, "Booking BA-22"} =
               BexioApiClient.Accounting.fetch_next_manual_entry_reference_nr(client)
    end
  end

  describe "fetching files of a manual entry line" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/manual_entries/1/entries/32/files"} =
            conn ->
          json(conn, [manual_entry_file()])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.Accounting.fetch_manual_entry_line_files(client, 1, 32)

      assert result.id == 1
      assert result.uuid == "474cc93a-2d6f-47e9-bd3f-a5b5a1941314"
      assert result.name == "screenshot"
      assert result.size_in_bytes == 218_476
      assert result.extension == :png
      assert result.mime_type == "image/png"
      assert result.uploader_email == "contact@example.org"
      assert result.user_id == 1
      assert result.archived? == false
      assert result.source_type == :web
      assert result.source_id == 2
      assert result.referenced? == false
      assert result.created_at == ~U[2018-06-09 08:52:10Z]
      assert result.data == nil
    end
  end

  describe "adding a file to a manual entry line" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/3.0/accounting/manual_entries/1/entries/32/files"} =
            conn ->
          assert ["multipart/form-data" <> _] = get_req_header(conn, "content-type")
          json(conn, [manual_entry_file()])
      end)

      :ok
    end

    test "uploads the file" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.Accounting.add_manual_entry_line_file(client, 1, 32, [
                 {:fileName1, {"<content>", filename: "screenshot.png"}}
               ])

      assert result.id == 1
      assert result.name == "screenshot"
    end
  end

  describe "fetching a file of a manual entry line" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/manual_entries/1/entries/32/files/1"} =
            conn ->
          json(conn, Map.put(manual_entry_file(), "data", "aGVsbG8="))
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Accounting.fetch_manual_entry_line_file(client, 1, 32, 1)

      assert result.id == 1
      assert result.name == "screenshot"
      assert result.data == "aGVsbG8="
    end
  end

  describe "deleting the connection between a file and a manual entry line" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/3.0/accounting/manual_entries/1/entries/32/files/1"} =
            conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the connection" do
      client = BexioApiClient.new("123")

      assert {:ok, true} =
               BexioApiClient.Accounting.delete_manual_entry_line_file(client, 1, 32, 1)
    end
  end

  describe "fetching files of a manual compound entry" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/manual_entries/1/files"} = conn ->
          json(conn, [manual_entry_file()])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.Accounting.fetch_manual_compound_entry_files(client, 1)

      assert result.id == 1
      assert result.name == "screenshot"
    end
  end

  describe "adding a file to a manual compound entry" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/3.0/accounting/manual_entries/1/files"} = conn ->
          assert ["multipart/form-data" <> _] = get_req_header(conn, "content-type")
          json(conn, [manual_entry_file()])
      end)

      :ok
    end

    test "uploads the file" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.Accounting.add_manual_compound_entry_file(client, 1, [
                 {:fileName1, {"<content>", filename: "screenshot.png"}}
               ])

      assert result.id == 1
      assert result.name == "screenshot"
    end
  end

  describe "fetching a file of a manual compound entry" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/accounting/manual_entries/1/files/1"} = conn ->
          json(conn, Map.put(manual_entry_file(), "data", "aGVsbG8="))
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Accounting.fetch_manual_compound_entry_file(client, 1, 1)

      assert result.id == 1
      assert result.name == "screenshot"
      assert result.data == "aGVsbG8="
    end
  end

  describe "deleting the connection between a file and a manual compound entry" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/3.0/accounting/manual_entries/1/files/1"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the connection" do
      client = BexioApiClient.new("123")

      assert {:ok, true} =
               BexioApiClient.Accounting.delete_manual_compound_entry_file(client, 1, 1)
    end
  end

  describe "fetching a single tax" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/taxes/1"} = conn ->
          json(conn, %{
            "id" => 1,
            "uuid" => "8078b1f3-f85b-4adf-aaa8-c3eeea964927",
            "name" => "lib.model.tax.ch.sales_7_7.name",
            "code" => "UN77",
            "digit" => "302",
            "type" => "sales_tax",
            "account_id" => 98,
            "tax_settlement_type" => "none",
            "value" => 7.7,
            "net_tax_value" => nil,
            "start_year" => 2017,
            "end_year" => 2018,
            "start_month" => 1,
            "end_month" => 12,
            "is_active" => true,
            "display_name" => "ZOLLM  - Import Mat/SV 100.00%"
          })

        %{method: "GET", request_path: "/3.0/taxes/2"} = conn ->
          send_resp(conn, 404, "Tax does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Accounting.fetch_tax(client, 1)

      assert result.id == 1
      assert result.uuid == "8078b1f3-f85b-4adf-aaa8-c3eeea964927"
      assert result.name == "lib.model.tax.ch.sales_7_7.name"
      assert result.code == "UN77"
      assert result.digit == "302"
      assert result.type == :sales_tax
      assert result.account_id == 98
      assert result.tax_settlement_type == "none"
      assert result.value == 7.7
      assert result.net_tax_value == nil
      assert result.start_year == 2017
      assert result.end_year == 2018
      assert result.start_month == 1
      assert result.end_month == 12
      assert result.active? == true
      assert result.display_name == "ZOLLM  - Import Mat/SV 100.00%"
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Tax does not exist"} =
               BexioApiClient.Accounting.fetch_tax(client, 2)
    end
  end

  describe "deleting a tax" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/3.0/taxes/1"} = conn ->
          json(conn, %{"success" => true})

        %{method: "DELETE", request_path: "/3.0/taxes/2"} = conn ->
          send_resp(conn, 409, "Tax is in use")
      end)

      :ok
    end

    test "deletes the tax" do
      client = BexioApiClient.new("123")

      assert {:ok, true} = BexioApiClient.Accounting.delete_tax(client, 1)
    end

    test "fails on conflict" do
      client = BexioApiClient.new("123")

      assert {:error, :conflict, "Tax is in use"} =
               BexioApiClient.Accounting.delete_tax(client, 2)
    end
  end

  defp manual_entry_file do
    %{
      "id" => 1,
      "uuid" => "474cc93a-2d6f-47e9-bd3f-a5b5a1941314",
      "name" => "screenshot",
      "size_in_bytes" => 218_476,
      "extension" => "png",
      "mime_type" => "image/png",
      "uploader_email" => "contact@example.org",
      "user_id" => 1,
      "is_archived" => false,
      "source_id" => 2,
      "source_type" => "web",
      "is_referenced" => false,
      "created_at" => "2018-06-09T08:52:10+00:00"
    }
  end
end
