defmodule BexioApiClient.Accounting do
  @moduledoc """
  Bexio API for the accounting part of the API.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria
  alias BexioApiClient.Accounting.{Account, AccountGroup, CalendarYear, Currency}

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
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/accounts", query: opts_to_query(opts))
      end,
      &map_from_accounts/1
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
    bexio_return_handling(
      fn ->
        Tesla.post(
          client,
          "/2.0/accounts/search",
          Enum.map(criteria, &update_account_type_in_search_criteria/1),
          query: opts_to_query(opts)
        )
      end,
      &map_from_accounts/1
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

  defp map_from_accounts(accounts), do: Enum.map(accounts, &map_from_account/1)

  defp map_from_account(%{
         "id" => id,
         "account_no" => account_no,
         "name" => name,
         "account_group_id" => account_group_id,
         "account_type" => account_type_id,
         "tax_id" => tax_id,
         "is_active" => active?,
         "is_locked" => locked?
       }) do
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
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/account_groups", query: opts_to_query(opts))
      end,
      &map_from_account_groups/1
    )
  end

  defp map_from_account_groups(accounts), do: Enum.map(accounts, &map_from_account_group/1)

  defp map_from_account_group(%{
         "id" => id,
         "account_no" => account_no,
         "name" => name,
         "parent_fibu_account_group_id" => parent_fibu_account_group_id,
         "is_active" => active?,
         "is_locked" => locked?
       }) do
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
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/3.0/calendar_years", query: opts_to_query(opts))
      end,
      &map_from_calendar_years/1
    )
  end

  defp map_from_calendar_years(calendar_years),
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
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/3.0/currencies", query: opts_to_query(opts))
      end,
      &map_from_currencies/1
    )
  end

  defp map_from_currencies(currencies),
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
end
