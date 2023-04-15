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

  @doc """
  Fetch a list of accounts.
  """
  @spec fetch_accounts(
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Account.t()]} | {:error, any()}
  def fetch_accounts(client, opts \\ []) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/accounts", query: opts_to_query(opts))
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
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Account.t()]} | {:error, any()}
  def search_accounts(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(
          client,
          "/2.0/accounts/search",
          Enum.map(criteria, &update_account_type_in_search_criteria/1),
          query: opts_to_query(opts)
        )
      end,
      &map_from_accounts/2
    )
  end

  defp update_account_type_in_search_criteria(%SearchCriteria{
         name: :account_type,
         criteria: criteria,
         value: value
       }) do
    %SearchCriteria{
      name: :acount_type,
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
           "account_group_id" => account_group_id,
           "account_type" => account_type_id,
           "tax_id" => tax_id,
           "is_active" => active?,
           "is_locked" => locked?
         },
         _env \\ nil
       ) do
    %Account{
      id: id,
      account_no: String.to_integer(account_no),
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
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [AccountGroup.t()]} | {:error, any()}
  def fetch_account_groups(client, opts \\ []) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/account_groups", query: opts_to_query(opts))
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
      account_no: String.to_integer(account_no),
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
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [CalendarYear.t()]} | {:error, any()}
  def fetch_calendar_years(client, opts \\ []) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/3.0/calendar_years", query: opts_to_query(opts))
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
      created_at: to_offset_datetime(created_at),
      updated_at: to_offset_datetime(updated_at),
      vat_accounting_method: String.to_atom(vat_accounting_method),
      vat_accounting_type: String.to_atom(vat_accounting_type)
    }
  end

  @doc """
  Fetch a list of currencies.
  """
  @spec fetch_currencies(
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Currency.t()]} | {:error, any()}
  def fetch_currencies(client, opts \\ []) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/3.0/currencies", query: opts_to_query(opts))
      end,
      &map_from_currencies/2
    )
  end

  defp map_from_currencies(currencies, _env),
    do: Enum.map(currencies, &map_from_currency/1)

  defp map_from_currency(%{
         "id" => id,
         "name" => name,
         "round_factor" => round_factor
       }) do
    %Currency{
      id: id,
      name: name,
      round_factor: round_factor
    }
  end

  @doc """
  Fetch a list of currency exchange rates.
  """
  @spec fetch_exchange_rates(
          client :: Tesla.Client.t(),
          id :: integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Currency.t()]} | {:error, any()}
  def fetch_exchange_rates(client, id, opts \\ []) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/3.0/currencies/#{id}/exchange_rates", query: opts_to_query(opts))
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
          client :: Tesla.Client.t(),
          date :: Date.t() | nil,
          types :: :sales_tax | :pre_tax | nil,
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Tax.t()]} | {:error, any()}
  def fetch_taxes(client, date \\ nil, types \\ nil, opts \\ []) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/3.0/taxes",
          query: opts |> opts_to_query() |> opts_with_date(date) |> opts_with_type(types)
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
         "is_active" => active?,
         "display_name" => display_name
       }) do
    %Tax{
      id: id,
      uuid: uuid,
      name: name,
      code: code,
      digit: digit,
      type: String.to_atom(type),
      account_id: account_id,
      tax_settlement_type: tax_settlement_type,
      value: value,
      net_tax_value: net_tax_value,
      start_year: start_year,
      end_year: end_year,
      active?: active?,
      display_name: display_name
    }
  end
end
