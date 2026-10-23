defmodule BexioApiClient.Accounting do
  @moduledoc """
  Bexio API for the accounting part of the API.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria

  alias BexioApiClient.Accounting.{
    Account,
    AccountGroup,
    CalendarYear,
    Currency,
    ExchangeRate,
    Tax
  }

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @type api_error_type :: BexioApiClient.Helpers.api_error_type()

  @doc """
  Fetch a list of accounts.
  """
  @spec fetch_accounts(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Account.t()]} | api_error_type()
  def fetch_accounts(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/accounts", params: opts_to_query(opts))
      end,
      &map_from_accounts/2
    )
  end

  @doc """
  Search accounts via query.
  The following search fields are supported:

  * account_no
  * fibo_account_group_id (TODO: test this)
  * name
  * account_type
  """
  @spec search_accounts(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Account.t()]} | api_error_type()
  def search_accounts(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/accounts/search",
          json: Enum.map(criteria, &update_account_type_in_search_criteria/1),
          params: opts_to_query(opts)
        )
      end,
      &map_from_accounts/2
    )
  end

  defp update_account_type_in_search_criteria(%SearchCriteria{
         field: :account_type,
         criteria: criteria,
         value: value
       }) do
    %SearchCriteria{
      field: :acount_type,
      criteria: criteria,
      value:
        case value do
          :earning -> 1
          :expenditure -> 2
          :active_account -> 3
          :passive_account -> 4
          :complete_account -> 5
        end
    }
  end

  defp update_account_type_in_search_criteria(search_criteria), do: search_criteria

  defp map_from_accounts(accounts, _env), do: Enum.map(accounts, &map_from_account/1)

  defp map_from_account(
         %{
           "id" => id,
           "account_no" => account_no,
           "name" => name,
           "fibu_account_group_id" => account_group_id,
           "account_type" => account_type_id,
           "tax_id" => tax_id,
           "is_active" => active?,
           "is_locked" => locked?
         },
         _env \\ nil
       ) do
    %Account{
      id: id,
      account_no: account_no,
      name: name,
      account_group_id: account_group_id,
      account_type: account_type(account_type_id),
      tax_id: tax_id,
      active?: active?,
      locked?: locked?
    }
  end

  defp account_type(1), do: :earning
  defp account_type(2), do: :expenditure
  defp account_type(3), do: :active_account
  defp account_type(4), do: :passive_account
  defp account_type(5), do: :complete_account

  @doc """
  Fetch a list of account groups.
  """
  @spec fetch_account_groups(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [AccountGroup.t()]} | api_error_type()
  def fetch_account_groups(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/account_groups", params: opts_to_query(opts))
      end,
      &map_from_account_groups/2
    )
  end

  defp map_from_account_groups(accounts, _env), do: Enum.map(accounts, &map_from_account_group/1)

  defp map_from_account_group(
         %{
           "id" => id,
           "account_no" => account_no,
           "name" => name,
           "parent_fibu_account_group_id" => parent_fibu_account_group_id,
           "is_active" => active?,
           "is_locked" => locked?
         },
         _env \\ nil
       ) do
    %AccountGroup{
      id: id,
      account_no: account_no,
      name: name,
      parent_fibu_account_group_id: parent_fibu_account_group_id,
      active?: active?,
      locked?: locked?
    }
  end

  @doc """
  Fetch a list of calendar years.
  """
  @spec fetch_calendar_years(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [CalendarYear.t()]} | api_error_type()
  def fetch_calendar_years(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/accounting/calendar_years", params: opts_to_query(opts))
      end,
      &map_from_calendar_years/2
    )
  end

  defp map_from_calendar_years(calendar_years, _env),
    do: Enum.map(calendar_years, &map_from_calendar_year/1)

  defp map_from_calendar_year(%{
         "id" => id,
         "start" => start,
         "end" => end_date,
         "is_vat_subject" => vat_subject?,
         "is_annual_reporting" => annual_reporting?,
         "created_at" => created_at,
         "updated_at" => updated_at,
         "vat_accounting_method" => vat_accounting_method,
         "vat_accounting_type" => vat_accounting_type
       }) do
    %CalendarYear{
      id: id,
      start: to_date(start),
      end: to_date(end_date),
      vat_subject?: vat_subject?,
      annual_reporting?: annual_reporting?,
      created_at: to_offset_datetime(created_at),
      updated_at: to_offset_datetime(updated_at),
      # both fields are null when the calendar year is not subjected to vat
      vat_accounting_method: to_enum(vat_accounting_method, [:effective, :net_tax]),
      vat_accounting_type: to_enum(vat_accounting_type, [:agreed, :collected])
    }
  end

  @doc """
  Fetch a list of currencies.
  """
  @spec fetch_currencies(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Currency.t()]} | api_error_type()
  def fetch_currencies(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/currencies", params: opts_to_query(opts))
      end,
      &map_from_currencies/2
    )
  end

  defp map_from_currencies(currencies, _env),
    do: Enum.map(currencies, &map_from_currency/1)

  defp map_from_currency(%{"id" => id, "name" => name, "round_factor" => round_factor} = currency) do
    %Currency{
      id: id,
      name: name,
      round_factor: round_factor,
      # embedded default exchange rate fields; not present/null for the base currency
      exchange_rate: Map.get(currency, "exchange_rate"),
      exchange_rate_date: to_date(Map.get(currency, "exchange_rate_date")),
      exchange_rate_id: Map.get(currency, "exchange_rate_id"),
      exchange_rate_to_ratio: Map.get(currency, "exchange_rate_to_ratio"),
      ratio: Map.get(currency, "ratio"),
      source: Map.get(currency, "source"),
      source_reason: Map.get(currency, "source_reason")
    }
  end

  @doc """
  Fetch a list of currency exchange rates.
  """
  @spec fetch_exchange_rates(
          req :: Req.Request.t(),
          id :: integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [ExchangeRate.t()]} | api_error_type()
  def fetch_exchange_rates(req, id, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/currencies/#{id}/exchange_rates", params: opts_to_query(opts))
      end,
      &map_from_exchange_rates/2
    )
  end

  defp map_from_exchange_rates(exchange_rates, _env),
    do: Enum.map(exchange_rates, &map_from_exchange_rate/1)

  defp map_from_exchange_rate(%{
         "factor_nr" => factor_nr,
         "exchange_currency" => exchange_currency
       }) do
    %ExchangeRate{
      factor: factor_nr,
      exchange_currency: map_from_currency(exchange_currency)
    }
  end

  @doc """
  Fetch a list of taxes.

  Arguments:

  * `date` - all taxes which are active at the date given
  * `types` - filter the types of tax (:sales_tax or :pre_tax)
  """
  @spec fetch_taxes(
          req :: Req.Request.t(),
          date :: Date.t() | nil,
          types :: :sales_tax | :pre_tax | nil,
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Tax.t()]} | api_error_type()
  def fetch_taxes(req, date \\ nil, types \\ nil, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req,
          url: "/3.0/taxes",
          params: opts |> opts_to_query() |> opts_with_date(date) |> opts_with_type(types)
        )
      end,
      &map_from_taxes/2
    )
  end

  defp opts_with_date(opts, nil), do: opts
  defp opts_with_date(opts, date), do: Keyword.put(opts, :date, Date.to_iso8601(date))
  defp opts_with_type(opts, nil), do: opts
  defp opts_with_type(type, opts), do: Keyword.put(opts, :types, type)

  defp map_from_taxes(taxes, _env), do: Enum.map(taxes, &map_from_tax/1)

  defp map_from_tax(%{
         "id" => id,
         "uuid" => uuid,
         "name" => name,
         "code" => code,
         "digit" => digit,
         "type" => type,
         "account_id" => account_id,
         "tax_settlement_type" => tax_settlement_type,
         "value" => value,
         "net_tax_value" => net_tax_value,
         "start_year" => start_year,
         "end_year" => end_year,
         "start_month" => start_month,
         "end_month" => end_month,
         "is_active" => active?,
         "display_name" => display_name
       }) do
    %Tax{
      id: id,
      uuid: uuid,
      name: name,
      code: code,
      digit: digit,
      type:
        to_enum(type, [
          :net_tax,
          :non_consideration_sales_tax,
          :pre_customs_tax_investment,
          :pre_customs_tax_material,
          :pre_regards_tax_investment,
          :pre_regards_tax_material,
          :pre_tax_investment,
          :pre_tax_material,
          :sales_tax
        ]),
      account_id: account_id,
      tax_settlement_type: tax_settlement_type,
      value: value,
      net_tax_value: net_tax_value,
      start_year: start_year,
      end_year: end_year,
      start_month: start_month,
      end_month: end_month,
      active?: active?,
      display_name: display_name
    }
  end
end
