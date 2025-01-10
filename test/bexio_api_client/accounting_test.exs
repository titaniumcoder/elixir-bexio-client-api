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
end
