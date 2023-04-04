defmodule BexioApiClient.Purchase do
  import BexioApiClient.Helpers

  @moduledoc """
  Purchase Part of the API
  """
  alias BexioApiClient.Global.Paging
  alias BexioApiClient.Purchase.Bill

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
          limit :: pos_integer() | nil,
          page :: non_neg_integer() | nil,
          order :: String.t() | nil,
          sort :: String.t() | nil,
          search_term :: String.t() | nil,
          fields :: list(String.t()) | nil,
          status :: :drafts | :todo | :paid | :overdue | nil,
          bill_date_start :: Date.t() | nil,
          bill_date_end :: Date.t() | nil,
          due_date_start :: Date.t() | nil,
          due_date_end :: Date.t() | nil,
          vendor_ref :: String.t() | nil,
          title :: String.t() | nil,
          currency_code :: String.t() | nil,
          pending_amount_min :: float() | nil,
          pending_amount_max :: float() | nil,
          vendor :: String.t() | nil,
          gross_min :: float() | nil,
          gross_max :: float() | nil,
          net_min :: float() | nil,
          net_max :: float() | nil,
          document_no :: String.t() | nil,
          supplier_id :: String.t() | nil
        ) ::
          {:ok, {[BexioApiClient.Purchase.Bill.t()], BexioApiClient.Global.Paging}}
          | {:error, any()}
  def fetch_bills(
        client,
        limit \\ nil,
        page \\ nil,
        order \\ nil,
        sort \\ nil,
        search_term \\ nil,
        fields \\ nil,
        status \\ nil,
        bill_date_start \\ nil,
        bill_date_end \\ nil,
        due_date_start \\ nil,
        due_date_end \\ nil,
        vendor_ref \\ nil,
        title \\ nil,
        currency_code \\ nil,
        pending_amount_min \\ nil,
        pending_amount_max \\ nil,
        vendor \\ nil,
        gross_min \\ nil,
        gross_max \\ nil,
        net_min \\ nil,
        net_max \\ nil,
        document_no \\ nil,
        supplier_id \\ nil
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/4.0/purchase/bills",
          query: [
            limit: limit,
            page: page,
            order: order,
            sort: sort,
            search_term: search_term,
            fields: fields,
            status: status,
            bill_date_start: bill_date_start,
            bill_date_end: bill_date_end,
            due_date_start: due_date_start,
            due_date_end: due_date_end,
            vendor_ref: vendor_ref,
            title: title,
            currency_code: currency_code,
            pending_amount_min: pending_amount_min,
            pending_amount_max: pending_amount_max,
            vendor: vendor,
            gross_min: gross_min,
            gross_max: gross_max,
            net_min: net_min,
            net_max: net_max,
            document_no: document_no,
            supplier_id: supplier_id
          ]
        )
      end,
      &map_from_paged_bills/1
    )
  end

  defp map_from_paged_bills(%{
         "data" => bills,
         "paging" => %{
           "page" => page,
           "page_size" => page_size,
           "page_count" => page_count,
           "item_count" => item_count
         }
       }) do
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
         "overdue" => overdue,
         "booking_account_ids" => booking_account_ids,
         "attachment_ids" => attachment_ids
       }) do
    %Bill{
      id: id,
      created_at: convert_date_time(created_at),
      document_no: document_no,
      status: status |> String.downcase() |> String.to_existing_atom(),
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
      overdue: overdue,
      booking_account_ids: booking_account_ids,
      attachment_ids: attachment_ids
    }
  end

  defp convert_date_time(date_time) do
    case DateTime.from_iso8601(date_time) do
      {:ok, dt, _offset} -> dt
      {:error, _error} -> raise ArgumentError
    end
  end
end
