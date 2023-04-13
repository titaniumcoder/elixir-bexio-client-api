defmodule BexioApiClient.Accounting do
  @moduledoc """
  Bexio API for the accounting part of the API.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria
  alias BexioApiClient.Accounting.Account

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
end
