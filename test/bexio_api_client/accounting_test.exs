defmodule BexioApiClient.AccountingTest do
  use ExUnit.Case, async: true
  doctest BexioApiClient.Accounting

  alias BexioApiClient.SearchCriteria

  import Tesla.Mock

  describe "fetching a list of accounts" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/accounts"} ->
          json([
            %{
              "id" => 1,
              "account_no" => "3201",
              "name" => "Gross proceeds credit sales",
              "account_group_id" => 65,
              "account_type" => 1,
              "tax_id" => 40,
              "is_active" => true,
              "is_locked" => false
            },
            %{
              "id" => 2,
              "account_no" => "3202",
              "name" => "Gross proceeds credit sales 2",
              "account_group_id" => 66,
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [result1, result2]} = BexioApiClient.Accounting.fetch_accounts(client)

      assert result1.id == 1
      assert result1.account_no == 3201
      assert result1.name == "Gross proceeds credit sales"
      assert result1.account_group_id == 65
      assert result1.account_type == :earning
      assert result1.tax_id == 40
      assert result1.active? == true
      assert result1.locked? == false

      assert result2.id == 2
      assert result2.account_no == 3202
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
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/accounts/search",
          body: _body
        } ->
          json([
            %{
              "id" => 1,
              "account_no" => "3201",
              "name" => "Gross proceeds credit sales",
              "account_group_id" => 65,
              "account_type" => 1,
              "tax_id" => 40,
              "is_active" => true,
              "is_locked" => false
            },
            %{
              "id" => 2,
              "account_no" => "3202",
              "name" => "Gross proceeds credit sales 2",
              "account_group_id" => 66,
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [result1, result2]} =
               BexioApiClient.Accounting.search_accounts(
                 client,
                 [
                   SearchCriteria.nil?(:account_no),
                   SearchCriteria.part_of(:name, ["fred", "queen"])
                 ]
               )

      assert result1.id == 1
      assert result1.account_no == 3201
      assert result1.name == "Gross proceeds credit sales"
      assert result1.account_group_id == 65
      assert result1.account_type == :earning
      assert result1.tax_id == 40
      assert result1.active? == true
      assert result1.locked? == false

      assert result2.id == 2
      assert result2.account_no == 3202
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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/account_groups"} ->
          json([
            %{
              "id" => 1,
              "account_no" => "1",
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [result]} = BexioApiClient.Accounting.fetch_account_groups(client)

      assert result.id == 1
      assert result.account_no == 1
      assert result.name == "Assets"
      assert result.parent_fibu_account_group_id == 3
      assert result.active? == true
      assert result.locked? == false
    end
  end

  describe "fetching a list of calendar years" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/3.0/calendar_years"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
end
