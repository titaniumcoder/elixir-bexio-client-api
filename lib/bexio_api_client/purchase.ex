defmodule BexioApiClient.Purchase do
  import BexioApiClient.Helpers

  @moduledoc """
  Purchase Part of the API
  """
  alias BexioApiClient.Global.Paging
  alias BexioApiClient.Purchase.Bill

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @possible_bill_status [
    :draft,
    :booked,
    :partially_created,
    :created,
    :partially_sent,
    :sent,
    :partially_downloaded,
    :downloaded,
    :partially_paid,
    :paid,
    :partially_failed,
    :failed
  ]

  @status_map Enum.map(@possible_bill_status, fn v -> {Atom.to_string(v), v} end)
              |> Enum.into(%{})

  @type bill_search_args :: [
          bill_date_start: Date.t(),
          bill_date_end: Date.t(),
          due_date_start: Date.t(),
          due_date_end: Date.t(),
          vendor_ref: String.t(),
          title: String.t(),
          currency_code: String.t(),
          pending_amount_min: float(),
          pending_amount_max: float(),
          vendor: String.t(),
          gross_min: float(),
          gross_max: float(),
          net_min: float(),
          net_max: float(),
          document_no: String.t(),
          supplier_id: integer(),
          status: :drafts | :todo | :paid | :overdue
        ]
  defp bill_search_args_to_query(opts) do
    opts
  end

  @doc """
  Endpoint for retrieving Bills

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:limit` - limit the number of results (default: 500, max: 2000)
    * `:page` - current page
    * `:order` - sorting order, example `order=asc&order=desc`
    * `:sort` - field to sort by, example `sort=document_no`
    * `:search_term` - term for which application will look for (minimum 3 signs, maximum 255 signs), example `search_term=term`
    * `:fields` - Items enum, fields for which search will be run (if no fields specified then searching will be done for all allowed fields)
    * `:status` - filter for Bill 'status' (DRAFTS: [DRAFT], TODO: [BOOKED, PARTIALLY_CREATED, CREATED, PARTIALLY_SENT, SENT, PARTIALLY_DOWNLOADED, DOWNLOADED, PARTIALLY_PAID, PARTIALLY_FAILED, FAILED], PAID: [PAID], OVERDUE: [BOOKED, PARTIALLY_CREATED, CREATED, PARTIALLY_SENT, SENT, PARTIALLY_DOWNLOADED, DOWNLOADED, PARTIALLY_PAID, PARTIALLY_FAILED, FAILED]) and for 'onlyOverdue' (DRAFTS: [FALSE], TODOS: [FALSE], PAID: [FALSE], OVERDUE: [TRUE]). Choosing OVERDUE means that only Bills with 'due_date' before now will be shown
  """
  @spec fetch_bills(
          client :: Tesla.Client.t(),
          search_term :: String.t() | nil,
          fields :: list(String.t()) | nil,
          search_args :: bill_search_args(),
          opts :: [GlobalArguments.paging_arg()]
        ) :: {:ok, {[Bill.t()], Paging.t()}} | {:error, any()}
  def fetch_bills(
        client,
        search_term \\ nil,
        fields \\ nil,
        search_args \\ [],
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/4.0/purchase/bills",
          query:
            Keyword.merge(
              [
                search_term: search_term,
                fields: fields
              ],
              Keyword.merge(
                bill_search_args_to_query(search_args),
                opts_to_query(opts)
              )
            )
            |> Keyword.filter(fn {_k, v} -> v != nil end)
        )
      end,
      &map_from_paged_bills/2
    )
  end

  defp map_from_paged_bills(
         %{
           "data" => bills,
           "paging" => %{
             "page" => page,
             "page_size" => page_size,
             "page_count" => page_count,
             "item_count" => item_count
           }
         },
         _env
       ) do
    {
      Enum.map(bills, &map_from_bill/1),
      %Paging{
        page: page,
        page_size: page_size,
        page_count: page_count,
        item_count: item_count
      }
    }
  end

  defp map_from_bill(%{
         "id" => id,
         "created_at" => created_at,
         "document_no" => document_no,
         "status" => status,
         "vendor_ref" => vendor_ref,
         "firstname_suffix" => firstname_suffix,
         "lastname_company" => lastname_company,
         "vendor" => vendor,
         "title" => title,
         "currency_code" => currency_code,
         "pending_amount" => pending_amount,
         "net" => net,
         "gross" => gross,
         "bill_date" => bill_date,
         "due_date" => due_date,
         "overdue" => overdue?,
         "booking_account_ids" => booking_account_ids,
         "attachment_ids" => attachment_ids
       }) do
    %Bill{
      id: id,
      created_at: convert_date_time(created_at),
      document_no: document_no,
      status: map_status(status),
      vendor_ref: vendor_ref,
      firstname_suffix: firstname_suffix,
      lastname_company: lastname_company,
      vendor: vendor,
      title: title,
      currency_code: currency_code,
      pending_amount: pending_amount,
      net: net,
      gross: gross,
      bill_date: Date.from_iso8601!(bill_date),
      due_date: Date.from_iso8601!(due_date),
      overdue?: overdue?,
      booking_account_ids: booking_account_ids,
      attachment_ids: attachment_ids
    }
  end

  defp map_status(status), do: Map.get(@status_map, String.downcase(status))

  defp convert_date_time(date_time) do
    case DateTime.from_iso8601(date_time) do
      {:ok, dt, _offset} -> dt
      {:error, _error} -> raise ArgumentError
    end
  end
end
