defmodule BexioApiClient.Purchase do
  import BexioApiClient.Helpers

  @moduledoc """
  Purchase Part of the API
  """
  alias BexioApiClient.Global.Paging
  alias BexioApiClient.Purchase.Address
  alias BexioApiClient.Purchase.Bill
  alias BexioApiClient.Purchase.BillDiscount
  alias BexioApiClient.Purchase.BillLineItem
  alias BexioApiClient.Purchase.BillPayment
  alias BexioApiClient.Purchase.DocumentNumber
  alias BexioApiClient.Purchase.Expense
  alias BexioApiClient.Purchase.OutgoingPayment
  alias BexioApiClient.Purchase.PurchaseOrder

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @type api_error_type :: BexioApiClient.Helpers.api_error_type()

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
          req :: Req.Request.t(),
          search_term :: String.t() | nil,
          fields :: list(String.t()) | nil,
          search_args :: bill_search_args(),
          opts :: [GlobalArguments.paging_arg()]
        ) :: {:ok, {[Bill.t()], Paging.t()}} | api_error_type()
  def fetch_bills(
        req,
        search_term \\ nil,
        fields \\ nil,
        search_args \\ [],
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req,
          url: "/4.0/purchase/bills",
          params:
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

  @doc """
  Endpoint for retrieving a single Bill by id
  """
  @spec fetch_bill(
          req :: Req.Request.t(),
          id :: String.t()
        ) :: {:ok, Bill.t()} | api_error_type()
  def fetch_bill(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/4.0/purchase/bills/#{id}")
      end,
      &map_from_bill/2
    )
  end

  @doc """
  Endpoint for creating a Bill
  """
  @spec create_bill(
          req :: Req.Request.t(),
          bill :: Bill.t()
        ) :: {:ok, Bill.t()} | api_error_type()
  def create_bill(req, bill) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/4.0/purchase/bills", json: remap_create_bill(bill))
      end,
      &map_from_bill/2
    )
  end

  @doc """
  Endpoint for updating a Bill
  """
  @spec edit_bill(
          req :: Req.Request.t(),
          id :: String.t(),
          bill :: Bill.t()
        ) :: {:ok, Bill.t()} | api_error_type()
  def edit_bill(req, id, bill) do
    bexio_body_handling(
      fn ->
        Req.put(req, url: "/4.0/purchase/bills/#{id}", json: remap_edit_bill(bill))
      end,
      &map_from_bill/2
    )
  end

  @doc """
  Endpoint for deleting a Bill by id. Bill can be removed when it is in status :draft only.
  """
  @spec delete_bill(
          req :: Req.Request.t(),
          id :: String.t()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_bill(req, id) do
    bexio_body_handling(
      fn -> delete_204_as_success(Req.delete(req, url: "/4.0/purchase/bills/#{id}")) end,
      &success_response/2
    )
  end

  @type bill_booking_status :: :draft | :booked

  @doc """
  Endpoint for updating the status of a Bill (changing status to :booked or back to :draft).

  Changing status to :booked triggers specific validations on the Bill (see the
  Bexio API documentation for `PUT /4.0/purchase/bills/{id}/bookings/{status}`).
  """
  @spec update_bill_status(
          req :: Req.Request.t(),
          id :: String.t(),
          status :: bill_booking_status()
        ) :: {:ok, Bill.t()} | api_error_type()
  def update_bill_status(req, id, status) do
    bexio_body_handling(
      fn ->
        Req.put(req, url: "/4.0/purchase/bills/#{id}/bookings/#{booking_status(status)}")
      end,
      &map_from_bill/2
    )
  end

  @doc """
  Endpoint for executing actions for a Bill, e.g. `DUPLICATE`.
  """
  @spec execute_bill_action(
          req :: Req.Request.t(),
          id :: String.t(),
          action :: String.t()
        ) :: {:ok, Bill.t()} | api_error_type()
  def execute_bill_action(req, id, action) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/4.0/purchase/bills/#{id}/actions", json: %{action: action})
      end,
      &map_from_bill/2
    )
  end

  @doc """
  Endpoint for validating whether a Bill document number is available or not.
  """
  @spec fetch_bill_document_number(
          req :: Req.Request.t(),
          document_no :: String.t()
        ) :: {:ok, DocumentNumber.t()} | api_error_type()
  def fetch_bill_document_number(req, document_no) do
    bexio_body_handling(
      fn ->
        Req.get(req,
          url: "/4.0/purchase/documentnumbers/bills",
          params: [document_no: document_no]
        )
      end,
      &map_from_document_number/2
    )
  end

  defp booking_status(status), do: status |> Atom.to_string() |> String.upcase()

  defp remap_create_bill(%Bill{} = bill) do
    %{
      supplier_id: bill.supplier_id,
      vendor_ref: bill.vendor_ref,
      title: bill.title,
      contact_partner_id: bill.contact_partner_id,
      bill_date: to_iso8601(bill.bill_date),
      due_date: to_iso8601(bill.due_date),
      amount_man: bill.amount_man,
      amount_calc: bill.amount_calc,
      manual_amount: bill.manual_amount?,
      currency_code: bill.currency_code,
      exchange_rate: bill.exchange_rate,
      base_currency_amount: bill.base_currency_amount,
      item_net: bill.item_net?,
      purchase_order_id: bill.purchase_order_id,
      qr_bill_information: bill.qr_bill_information,
      attachment_ids: bill.attachment_ids,
      address: remap_address(bill.address),
      line_items: Enum.map(bill.line_items, &remap_line_item/1),
      discounts: Enum.map(bill.discounts, &remap_discount/1),
      payment: remap_payment(bill.payment)
    }
    |> compact()
  end

  defp remap_edit_bill(%Bill{} = bill) do
    %{
      document_no: bill.document_no,
      title: bill.title,
      supplier_id: bill.supplier_id,
      vendor_ref: bill.vendor_ref,
      amount_man: bill.amount_man,
      amount_calc: bill.amount_calc,
      manual_amount: bill.manual_amount?,
      contact_partner_id: bill.contact_partner_id,
      bill_date: to_iso8601(bill.bill_date),
      due_date: to_iso8601(bill.due_date),
      currency_code: bill.currency_code,
      exchange_rate: bill.exchange_rate,
      item_net: bill.item_net?,
      split_into_line_items: bill.split_into_line_items?,
      base_currency_amount: bill.base_currency_amount,
      attachment_ids: bill.attachment_ids,
      address: remap_address(bill.address),
      line_items: Enum.map(bill.line_items, &remap_line_item/1),
      discounts: Enum.map(bill.discounts, &remap_discount/1),
      payment: remap_payment(bill.payment)
    }
    |> compact()
  end

  defp compact(map) do
    map
    |> Enum.filter(fn {_k, v} -> not is_nil(v) end)
    |> Enum.into(%{})
  end

  defp remap_address(nil), do: nil

  defp remap_address(%Address{} = address) do
    %{
      title: address.title,
      salutation: address.salutation,
      firstname_suffix: address.firstname_suffix,
      lastname_company: address.lastname_company,
      address_line: address.address_line,
      postcode: address.postcode,
      city: address.city,
      country_code: address.country_code,
      main_contact_id: address.main_contact_id,
      contact_address_id: address.contact_address_id,
      type: address.type
    }
    |> compact()
  end

  defp remap_line_item(%BillLineItem{} = line_item) do
    %{
      id: line_item.id,
      position: line_item.position,
      title: line_item.title,
      tax_id: line_item.tax_id,
      amount: line_item.amount,
      booking_account_id: line_item.booking_account_id
    }
    |> compact()
  end

  defp remap_discount(%BillDiscount{} = discount) do
    %{
      id: discount.id,
      position: discount.position,
      amount: discount.amount
    }
    |> compact()
  end

  defp remap_payment(nil), do: nil

  defp remap_payment(%BillPayment{} = payment) do
    %{
      type: payment.type,
      bank_account_id: payment.bank_account_id,
      fee: payment.fee,
      execution_date: to_iso8601(payment.execution_date),
      exchange_rate: payment.exchange_rate,
      amount: payment.amount,
      iban: payment.iban,
      name: payment.name,
      address: payment.address,
      street: payment.street,
      house_no: payment.house_no,
      postcode: payment.postcode,
      city: payment.city,
      country_code: payment.country_code,
      message: payment.message,
      booking_text: payment.booking_text,
      salary_payment: payment.salary_payment?,
      reference_no: payment.reference_no,
      note: payment.note
    }
    |> compact()
  end

  defp map_from_paged_bills(body, env), do: map_from_paged(body, &map_from_bill/1, env)

  defp map_from_paged_expenses(body, env), do: map_from_paged(body, &map_from_expense/1, env)

  defp map_from_paged_outgoing_payments(body, env),
    do: map_from_paged(body, &map_from_outgoing_payment/1, env)

  defp map_from_paged(%{"data" => data, "paging" => paging}, item_mapper, _env) do
    %{
      "page" => page,
      "page_size" => page_size,
      "page_count" => page_count,
      "item_count" => item_count
    } = paging

    {
      Enum.map(data, item_mapper),
      %Paging{
        page: page,
        page_size: page_size,
        page_count: page_count,
        item_count: item_count
      }
    }
  end

  defp map_from_bill(
         %{
           "id" => id,
           "created_at" => created_at,
           "document_no" => document_no,
           "status" => status,
           "vendor_ref" => vendor_ref,
           "firstname_suffix" => firstname_suffix,
           "lastname_company" => lastname_company,
           "title" => title,
           "currency_code" => currency_code,
           "pending_amount" => pending_amount,
           "bill_date" => bill_date,
           "due_date" => due_date,
           "overdue" => overdue?,
           "attachment_ids" => attachment_ids
         } = bill,
         _env \\ nil
       ) do
    %Bill{
      id: id,
      created_at: convert_date_time(created_at),
      document_no: document_no,
      status: map_status(status),
      vendor_ref: vendor_ref,
      firstname_suffix: firstname_suffix,
      lastname_company: lastname_company,
      # vendor, net and gross are absent from the single-bill response
      vendor: Map.get(bill, "vendor"),
      title: title,
      currency_code: currency_code,
      pending_amount: pending_amount,
      net: Map.get(bill, "net"),
      gross: Map.get(bill, "gross"),
      bill_date: Date.from_iso8601!(bill_date),
      due_date: Date.from_iso8601!(due_date),
      overdue?: overdue?,
      # booking_account_ids is absent from the single-bill response
      booking_account_ids: Map.get(bill, "booking_account_ids"),
      attachment_ids: attachment_ids,
      # fields of the single-bill response only, absent in the list response
      supplier_id: Map.get(bill, "supplier_id"),
      contact_partner_id: Map.get(bill, "contact_partner_id"),
      amount_man: Map.get(bill, "amount_man"),
      amount_calc: Map.get(bill, "amount_calc"),
      manual_amount?: Map.get(bill, "manual_amount"),
      exchange_rate: Map.get(bill, "exchange_rate"),
      base_currency_code: Map.get(bill, "base_currency_code"),
      base_currency_amount: Map.get(bill, "base_currency_amount"),
      item_net?: Map.get(bill, "item_net"),
      split_into_line_items?: Map.get(bill, "split_into_line_items"),
      purchase_order_id: Map.get(bill, "purchase_order_id"),
      qr_bill_information: Map.get(bill, "qr_bill_information"),
      address: map_from_address(Map.get(bill, "address")),
      line_items: map_from_line_items(Map.get(bill, "line_items")),
      discounts: map_from_discounts(Map.get(bill, "discounts")),
      payment: map_from_payment(Map.get(bill, "payment"))
    }
  end

  defp map_from_address(nil), do: nil

  defp map_from_address(
         %{
           "firstname_suffix" => firstname_suffix,
           "lastname_company" => lastname_company,
           "address_line" => address_line,
           "postcode" => postcode,
           "city" => city,
           "country_code" => country_code,
           "main_contact_id" => main_contact_id,
           "contact_address_id" => contact_address_id,
           "type" => type
         } = address
       ) do
    %Address{
      firstname_suffix: firstname_suffix,
      lastname_company: lastname_company,
      address_line: address_line,
      postcode: postcode,
      city: city,
      country_code: country_code,
      main_contact_id: main_contact_id,
      contact_address_id: contact_address_id,
      type: type,
      title: Map.get(address, "title"),
      salutation: Map.get(address, "salutation")
    }
  end

  defp map_from_line_items(nil), do: []

  defp map_from_line_items(line_items) do
    Enum.map(line_items, &map_from_line_item/1)
  end

  defp map_from_line_item(%{
         "id" => id,
         "position" => position,
         "title" => title,
         "tax_id" => tax_id,
         "tax_calc" => tax_calc,
         "amount" => amount,
         "booking_account_id" => booking_account_id
       }) do
    %BillLineItem{
      id: id,
      position: position,
      title: title,
      tax_id: tax_id,
      tax_calc: tax_calc,
      amount: amount,
      booking_account_id: booking_account_id
    }
  end

  defp map_from_discounts(nil), do: []

  defp map_from_discounts(discounts) do
    Enum.map(discounts, &map_from_discount/1)
  end

  defp map_from_discount(%{"id" => id, "position" => position, "amount" => amount}) do
    %BillDiscount{
      id: id,
      position: position,
      amount: amount
    }
  end

  defp map_from_payment(nil), do: nil

  defp map_from_payment(%{
         "type" => type,
         "bank_account_id" => bank_account_id,
         "fee" => fee,
         "execution_date" => execution_date,
         "exchange_rate" => exchange_rate,
         "amount" => amount,
         "iban" => iban,
         "name" => name,
         "address" => address,
         "street" => street,
         "house_no" => house_no,
         "postcode" => postcode,
         "city" => city,
         "country_code" => country_code,
         "message" => message,
         "booking_text" => booking_text,
         "salary_payment" => salary_payment?,
         "reference_no" => reference_no,
         "note" => note
       }) do
    %BillPayment{
      type: type,
      bank_account_id: bank_account_id,
      fee: fee,
      execution_date: to_date(execution_date),
      exchange_rate: exchange_rate,
      amount: amount,
      iban: iban,
      name: name,
      address: address,
      street: street,
      house_no: house_no,
      postcode: postcode,
      city: city,
      country_code: country_code,
      message: message,
      booking_text: booking_text,
      salary_payment?: salary_payment?,
      reference_no: reference_no,
      note: note
    }
  end

  defp map_status(status), do: Map.get(@status_map, String.downcase(status))

  ### Bexio API for the expenses part of the API.

  @type expense_search_args :: [
          vendor: String.t(),
          gross_min: float(),
          gross_max: float(),
          net_min: float(),
          net_max: float(),
          paid_on_start: Date.t(),
          paid_on_end: Date.t(),
          created_at_start: DateTime.t(),
          created_at_end: DateTime.t(),
          title: String.t(),
          currency_code: String.t(),
          document_no: String.t(),
          supplier_id: integer(),
          project_id: String.t()
        ]
  defp expense_search_args_to_query(opts) do
    opts
  end

  @doc """
  Endpoint for retrieving Expenses

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:limit` - limit the number of results (default: 100)
    * `:page` - current page
    * `:order` - sorting order, example `order=asc&order=desc`
    * `:sort` - field to sort by, example `sort=document_no`
    * `:vendor` - filter for Expense 'vendor', text containing in fields lastname_company and firstname_suffix
    * `:gross_min`/`:gross_max` - filter for Expense 'gross', the lowest/greatest accepted value
    * `:net_min`/`:net_max` - filter for Expense 'net', the lowest/greatest accepted value
    * `:paid_on_start`/`:paid_on_end` - filter for Expense 'paid_on', the earliest/latest accepted date
    * `:created_at_start`/`:created_at_end` - filter for Expense 'created_at', the earliest/latest accepted date
    * `:title` - filter for Expense 'title', text containing in field
    * `:currency_code` - filter for Expense 'currency_code', text containing in field
    * `:document_no` - filter for Expense 'document_no', text containing in field
    * `:supplier_id` - filter for Expense 'supplier_id'
    * `:project_id` - filter for Expense 'project_id'
  """
  @spec fetch_expenses(
          req :: Req.Request.t(),
          search_args :: expense_search_args(),
          opts :: [GlobalArguments.paging_arg()]
        ) :: {:ok, {[Expense.t()], Paging.t()}} | api_error_type()
  def fetch_expenses(req, search_args \\ [], opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req,
          url: "/4.0/expenses",
          params:
            Keyword.merge(
              expense_search_args_to_query(search_args),
              opts_to_query(opts)
            )
            |> Keyword.filter(fn {_k, v} -> v != nil end)
        )
      end,
      &map_from_paged_expenses/2
    )
  end

  @doc """
  Endpoint for retrieving a single Expense by id
  """
  @spec fetch_expense(
          req :: Req.Request.t(),
          id :: String.t()
        ) :: {:ok, Expense.t()} | api_error_type()
  def fetch_expense(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/4.0/expenses/#{id}")
      end,
      &map_from_expense/2
    )
  end

  @doc """
  Endpoint for creating an Expense
  """
  @spec create_expense(
          req :: Req.Request.t(),
          expense :: Expense.t()
        ) :: {:ok, Expense.t()} | api_error_type()
  def create_expense(req, expense) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/4.0/expenses", json: remap_create_expense(expense))
      end,
      &map_from_expense/2
    )
  end

  @doc """
  Endpoint for updating an Expense
  """
  @spec edit_expense(
          req :: Req.Request.t(),
          id :: String.t(),
          expense :: Expense.t()
        ) :: {:ok, Expense.t()} | api_error_type()
  def edit_expense(req, id, expense) do
    bexio_body_handling(
      fn ->
        Req.put(req, url: "/4.0/expenses/#{id}", json: remap_edit_expense(expense))
      end,
      &map_from_expense/2
    )
  end

  @doc """
  Endpoint for deleting an Expense by id. Expense cannot be removed when it is :done.
  """
  @spec delete_expense(
          req :: Req.Request.t(),
          id :: String.t()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_expense(req, id) do
    bexio_body_handling(
      fn -> delete_204_as_success(Req.delete(req, url: "/4.0/expenses/#{id}")) end,
      &success_response/2
    )
  end

  @type expense_booking_status :: :draft | :done

  @doc """
  Endpoint for updating the status of an Expense (changing status to :done or back to :draft).

  Changing status triggers specific validations on the Expense (see the
  Bexio API documentation for `PUT /4.0/expenses/{id}/bookings/{status}`).
  """
  @spec update_expense_status(
          req :: Req.Request.t(),
          id :: String.t(),
          status :: expense_booking_status()
        ) :: {:ok, Expense.t()} | api_error_type()
  def update_expense_status(req, id, status) do
    bexio_body_handling(
      fn ->
        Req.put(req, url: "/4.0/expenses/#{id}/bookings/#{booking_status(status)}")
      end,
      &map_from_expense/2
    )
  end

  @doc """
  Endpoint for executing actions for an Expense, e.g. `DUPLICATE`.
  """
  @spec execute_expense_action(
          req :: Req.Request.t(),
          id :: String.t(),
          action :: String.t()
        ) :: {:ok, Expense.t()} | api_error_type()
  def execute_expense_action(req, id, action) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/4.0/expenses/#{id}/actions", json: %{action: action})
      end,
      &map_from_expense/2
    )
  end

  @doc """
  Endpoint for validating whether an Expense document number is available or not.
  """
  @spec fetch_expense_document_number(
          req :: Req.Request.t(),
          document_no :: String.t()
        ) :: {:ok, DocumentNumber.t()} | api_error_type()
  def fetch_expense_document_number(req, document_no) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/4.0/expenses/documentnumbers", params: [document_no: document_no])
      end,
      &map_from_document_number/2
    )
  end

  defp remap_create_expense(%Expense{} = expense) do
    %{
      paid_on: to_iso8601(expense.paid_on),
      currency_code: expense.currency_code,
      exchange_rate: expense.exchange_rate,
      supplier_id: expense.supplier_id,
      title: expense.title,
      bank_account_id: expense.bank_account_id,
      booking_account_id: expense.booking_account_id,
      amount: expense.amount,
      tax_id: expense.tax_id,
      base_currency_amount: expense.base_currency_amount,
      attachment_ids: expense.attachment_ids,
      address: remap_address(expense.address)
    }
    |> compact()
  end

  defp remap_edit_expense(%Expense{} = expense) do
    %{
      paid_on: to_iso8601(expense.paid_on),
      currency_code: expense.currency_code,
      exchange_rate: expense.exchange_rate,
      supplier_id: expense.supplier_id,
      document_no: expense.document_no,
      title: expense.title,
      bank_account_id: expense.bank_account_id,
      booking_account_id: expense.booking_account_id,
      amount: expense.amount,
      tax_id: expense.tax_id,
      base_currency_amount: expense.base_currency_amount,
      attachment_ids: expense.attachment_ids,
      address: remap_address(expense.address)
    }
    |> compact()
  end

  defp map_from_expense(
         %{
           "id" => id,
           "created_at" => created_at,
           "document_no" => document_no,
           "status" => status,
           "firstname_suffix" => firstname_suffix,
           "lastname_company" => lastname_company,
           "paid_on" => paid_on,
           "booking_account_id" => booking_account_id,
           "currency_code" => currency_code,
           "attachment_ids" => attachment_ids
         } = expense,
         _env \\ nil
       ) do
    %Expense{
      id: id,
      created_at: convert_date_time(created_at),
      document_no: document_no,
      status: map_expense_status(status),
      firstname_suffix: firstname_suffix,
      lastname_company: lastname_company,
      paid_on: Date.from_iso8601!(paid_on),
      booking_account_id: booking_account_id,
      currency_code: currency_code,
      attachment_ids: attachment_ids,
      # the list response only contains a subset of the fields
      title: Map.get(expense, "title"),
      supplier_id: Map.get(expense, "supplier_id"),
      vendor: Map.get(expense, "vendor"),
      vendor_ref: Map.get(expense, "vendor_ref"),
      bank_account_id: Map.get(expense, "bank_account_id"),
      base_currency_code: Map.get(expense, "base_currency_code"),
      exchange_rate: Map.get(expense, "exchange_rate"),
      amount: Map.get(expense, "amount"),
      net: Map.get(expense, "net"),
      gross: Map.get(expense, "gross"),
      tax_man: Map.get(expense, "tax_man"),
      tax_calc: Map.get(expense, "tax_calc"),
      tax_id: Map.get(expense, "tax_id"),
      base_currency_amount: Map.get(expense, "base_currency_amount"),
      transaction_id: Map.get(expense, "transaction_id"),
      invoice_id: Map.get(expense, "invoice_id"),
      project_id: Map.get(expense, "project_id"),
      address: map_from_address(Map.get(expense, "address"))
    }
  end

  defp map_expense_status("DRAFT"), do: :draft
  defp map_expense_status("DONE"), do: :done

  ### Bexio API for the purchase orders part of the API (v3).

  @doc """
  Fetch a list of purchase orders.

  ## Arguments:

    * `:limit` - limit the number of results (default: 500, max: 2000)
    * `:offset` - skip over a number of elements by specifying an offset value for the query
    * `:order_by` - defines the order of the results (`:id`, `:total`, `:total_net`, `:total_gross`,
      `:updated_at`), `_asc`/`_desc` can be appended to sort ascending (default) or descending
  """
  @spec fetch_purchase_orders(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [PurchaseOrder.t()]} | api_error_type()
  def fetch_purchase_orders(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/purchase_orders", params: opts_to_query(opts))
      end,
      &map_from_purchase_orders/2
    )
  end

  @doc """
  This action fetches a single purchase order
  """
  @spec fetch_purchase_order(
          req :: Req.Request.t(),
          purchase_order_id :: pos_integer()
        ) :: {:ok, PurchaseOrder.t()} | api_error_type()
  def fetch_purchase_order(req, purchase_order_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/purchase_orders/#{purchase_order_id}")
      end,
      &map_from_purchase_order/2
    )
  end

  @doc """
  This action creates a new purchase order
  """
  @spec create_purchase_order(
          req :: Req.Request.t(),
          purchase_order :: PurchaseOrder.t()
        ) :: {:ok, PurchaseOrder.t()} | api_error_type()
  def create_purchase_order(req, purchase_order) do
    bexio_body_handling(
      fn ->
        Req.post(req,
          url: "/3.0/purchase_orders",
          json: remap_purchase_order(purchase_order)
        )
      end,
      &map_from_purchase_order/2
    )
  end

  @doc """
  This action updates a purchase order.
  """
  @spec edit_purchase_order(
          req :: Req.Request.t(),
          purchase_order_id :: pos_integer(),
          purchase_order :: PurchaseOrder.t()
        ) :: {:ok, PurchaseOrder.t()} | api_error_type()
  def edit_purchase_order(req, purchase_order_id, purchase_order) do
    bexio_body_handling(
      fn ->
        Req.put(req,
          url: "/3.0/purchase_orders/#{purchase_order_id}",
          json: remap_purchase_order(purchase_order)
        )
      end,
      &map_from_purchase_order/2
    )
  end

  @doc """
  This action permanently deletes a purchase order. It cannot be undone.
  """
  @spec delete_purchase_order(
          req :: Req.Request.t(),
          purchase_order_id :: pos_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_purchase_order(req, purchase_order_id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/3.0/purchase_orders/#{purchase_order_id}")
      end,
      &success_response/2
    )
  end

  defp remap_purchase_order(%PurchaseOrder{} = purchase_order) do
    %{
      id: purchase_order.id,
      document_nr: purchase_order.document_nr,
      kb_payment_template_id: purchase_order.kb_payment_template_id,
      payment_type_id: purchase_order.payment_type_id,
      title: purchase_order.title,
      contact_id: purchase_order.contact_id,
      contact_sub_id: purchase_order.contact_sub_id,
      template_slug: purchase_order.template_slug,
      user_id: purchase_order.user_id,
      project_id: purchase_order.project_id,
      logopaper_id: purchase_order.logopaper_id,
      language: purchase_order.language,
      language_id: purchase_order.language_id,
      bank_account_id: purchase_order.bank_account_id,
      currency: purchase_order.currency,
      currency_id: purchase_order.currency_id,
      header: purchase_order.header,
      footer: purchase_order.footer,
      mwst_type: map_mwst_type(purchase_order.mwst_type),
      mwst_is_net: purchase_order.mwst_is_net?,
      is_compact_view: purchase_order.compact_view?,
      show_position_taxes: purchase_order.show_position_taxes?,
      salesman_user_id: purchase_order.salesman_user_id,
      is_valid_from: to_iso8601(purchase_order.valid_from),
      is_valid_to: to_iso8601(purchase_order.valid_to),
      delivery_address_type: map_delivery_address_type(purchase_order.delivery_address_type),
      contact_address_manual: purchase_order.contact_address_manual,
      delivery_address_manual: purchase_order.delivery_address_manual,
      nb_decimals_amount: purchase_order.nb_decimals_amount,
      nb_decimals_price: purchase_order.nb_decimals_price,
      terms_of_payment_text: purchase_order.terms_of_payment_text,
      reference: purchase_order.reference,
      api_reference: purchase_order.api_reference,
      mail: purchase_order.mail,
      is_valid_until: to_iso8601(purchase_order.valid_until),
      created_at: to_iso8601(purchase_order.created_at),
      updated_at: to_iso8601(purchase_order.updated_at),
      custom_translations: purchase_order.custom_translations,
      date_format: purchase_order.date_format,
      positions: purchase_order.positions
    }
    |> compact()
    |> remove_document_no_if_nil()
  end

  defp map_mwst_type(nil), do: nil
  defp map_mwst_type(type), do: Atom.to_string(type)

  defp map_delivery_address_type(nil), do: nil
  defp map_delivery_address_type(type), do: Atom.to_string(type)

  defp map_from_purchase_orders(purchase_orders, _env),
    do: Enum.map(purchase_orders, &map_from_purchase_order/1)

  defp map_from_purchase_order(
         %{
           "id" => id,
           "document_nr" => document_nr,
           "kb_payment_template_id" => kb_payment_template_id,
           "payment_type_id" => payment_type_id,
           "title" => title,
           "contact_id" => contact_id,
           "contact_sub_id" => contact_sub_id,
           "template_slug" => template_slug,
           "user_id" => user_id,
           "project_id" => project_id,
           "language" => language,
           "language_id" => language_id,
           "bank_account_id" => bank_account_id,
           "currency" => currency,
           "currency_id" => currency_id,
           "header" => header,
           "footer" => footer,
           "total_rounding_difference" => total_rounding_difference,
           "mwst_type" => mwst_type,
           "mwst_is_net" => mwst_is_net?,
           "is_compact_view" => is_compact_view?,
           "show_position_taxes" => show_position_taxes?,
           "salesman_user_id" => salesman_user_id,
           "is_valid_from" => is_valid_from,
           "is_valid_to" => is_valid_to,
           "delivery_address_type" => delivery_address_type,
           "contact_address_manual" => contact_address_manual,
           "delivery_address_manual" => delivery_address_manual,
           "nb_decimals_amount" => nb_decimals_amount,
           "nb_decimals_price" => nb_decimals_price,
           "kb_item_status_id" => kb_item_status_id,
           "terms_of_payment_text" => terms_of_payment_text,
           "reference" => reference,
           "api_reference" => api_reference,
           "mail" => mail,
           "viewed_by_client_at" => viewed_by_client_at,
           "is_valid_until" => is_valid_until,
           "created_at" => created_at,
           "updated_at" => updated_at
         } = purchase_order,
         _env \\ nil
       ) do
    %PurchaseOrder{
      id: id,
      document_nr: document_nr,
      kb_payment_template_id: kb_payment_template_id,
      payment_type_id: payment_type_id,
      title: title,
      contact_id: contact_id,
      contact_sub_id: contact_sub_id,
      template_slug: template_slug,
      user_id: user_id,
      project_id: project_id,
      logopaper_id: Map.get(purchase_order, "logopaper_id"),
      language: language,
      language_id: language_id,
      bank_account_id: bank_account_id,
      currency: currency,
      currency_id: currency_id,
      header: header,
      footer: footer,
      total_rounding_difference: total_rounding_difference,
      mwst_type: map_purchase_order_mwst_type(mwst_type),
      mwst_is_net?: mwst_is_net?,
      compact_view?: is_compact_view?,
      show_position_taxes?: show_position_taxes?,
      salesman_user_id: salesman_user_id,
      valid_from: to_date(is_valid_from),
      valid_to: to_date(is_valid_to),
      delivery_address_type: map_purchase_order_delivery_address_type(delivery_address_type),
      contact_address_manual: contact_address_manual,
      delivery_address_manual: delivery_address_manual,
      nb_decimals_amount: nb_decimals_amount,
      nb_decimals_price: nb_decimals_price,
      kb_item_status_id: kb_item_status_id,
      terms_of_payment_text: terms_of_payment_text,
      reference: reference,
      api_reference: api_reference,
      mail: mail,
      viewed_by_client_at: to_date(viewed_by_client_at),
      valid_until: to_date(is_valid_until),
      created_at: to_offset_datetime(created_at),
      updated_at: to_offset_datetime(updated_at),
      custom_translations: Map.get(purchase_order, "custom_translations"),
      date_format: Map.get(purchase_order, "date_format"),
      positions: Map.get(purchase_order, "positions")
    }
  end

  defp map_purchase_order_mwst_type("included"), do: :included
  defp map_purchase_order_mwst_type("excluded"), do: :excluded
  defp map_purchase_order_mwst_type("exempt"), do: :exempt

  defp map_purchase_order_delivery_address_type("contact_address"), do: :contact_address
  defp map_purchase_order_delivery_address_type("manual"), do: :manual

  ### Bexio API for the outgoing payments part of the API.

  @doc """
  Endpoint for retrieving Outgoing Payments for a Bill

  ## Arguments:

    * `:bill_id` - id of Bill for which Outgoing Payments were created
    * `:limit` - limit the number of results (default: 100)
    * `:page` - current page
    * `:order` - sorting order (`:asc` or `:desc`)
    * `:sort` - field to sort by
  """
  @spec fetch_outgoing_payments(
          req :: Req.Request.t(),
          bill_id :: String.t(),
          opts :: [GlobalArguments.paging_arg()]
        ) :: {:ok, {[OutgoingPayment.t()], Paging.t()}} | api_error_type()
  def fetch_outgoing_payments(req, bill_id, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req,
          url: "/4.0/purchase/outgoing-payments",
          params:
            [bill_id: bill_id]
            |> Keyword.merge(opts_to_query(opts))
            |> Keyword.filter(fn {_k, v} -> v != nil end)
        )
      end,
      &map_from_paged_outgoing_payments/2
    )
  end

  @doc """
  Endpoint for retrieving a single Outgoing Payment by id
  """
  @spec fetch_outgoing_payment(
          req :: Req.Request.t(),
          id :: String.t()
        ) :: {:ok, OutgoingPayment.t()} | api_error_type()
  def fetch_outgoing_payment(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/4.0/purchase/outgoing-payments/#{id}")
      end,
      &map_from_outgoing_payment/2
    )
  end

  @doc """
  Endpoint for creating an Outgoing Payment
  """
  @spec create_outgoing_payment(
          req :: Req.Request.t(),
          outgoing_payment :: OutgoingPayment.t()
        ) :: {:ok, OutgoingPayment.t()} | api_error_type()
  def create_outgoing_payment(req, outgoing_payment) do
    bexio_body_handling(
      fn ->
        Req.post(req,
          url: "/4.0/purchase/outgoing-payments",
          json: remap_create_outgoing_payment(outgoing_payment)
        )
      end,
      &map_from_outgoing_payment/2
    )
  end

  @doc """
  Endpoint for editing an Outgoing Payment. The id of the payment is taken from
  `outgoing_payment.id` and sent as `payment_id` (bulk edit endpoint).
  """
  @spec edit_outgoing_payment(
          req :: Req.Request.t(),
          outgoing_payment :: OutgoingPayment.t()
        ) :: {:ok, OutgoingPayment.t()} | api_error_type()
  def edit_outgoing_payment(req, outgoing_payment) do
    bexio_body_handling(
      fn ->
        Req.put(req,
          url: "/4.0/purchase/outgoing-payments",
          json: remap_edit_outgoing_payment(outgoing_payment)
        )
      end,
      &map_from_outgoing_payment/2
    )
  end

  @doc """
  Endpoint for deleting an Outgoing Payment by id. Payment cannot be removed when it is
  reconciled (`:transaction_id` is not `nil`) or its Business Year is Closed or Locked.
  """
  @spec delete_outgoing_payment(
          req :: Req.Request.t(),
          id :: String.t()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_outgoing_payment(req, id) do
    bexio_body_handling(
      fn ->
        delete_204_as_success(Req.delete(req, url: "/4.0/purchase/outgoing-payments/#{id}"))
      end,
      &success_response/2
    )
  end

  defp remap_create_outgoing_payment(%OutgoingPayment{} = payment) do
    %{
      bill_id: payment.bill_id,
      payment_type: map_payment_type(payment.payment_type),
      execution_date: to_iso8601(payment.execution_date),
      amount: payment.amount,
      currency_code: payment.currency_code,
      exchange_rate: payment.exchange_rate,
      note: payment.note,
      sender_bank_account_id: payment.sender_bank_account_id,
      sender_iban: payment.sender_iban,
      sender_name: payment.sender_name,
      sender_street: payment.sender_street,
      sender_house_no: payment.sender_house_no,
      sender_city: payment.sender_city,
      sender_postcode: payment.sender_postcode,
      sender_country_code: payment.sender_country_code,
      sender_bc_no: payment.sender_bc_no,
      sender_bank_no: payment.sender_bank_no,
      sender_bank_name: payment.sender_bank_name,
      receiver_account_no: payment.receiver_account_no,
      receiver_iban: payment.receiver_iban,
      receiver_name: payment.receiver_name,
      receiver_street: payment.receiver_street,
      receiver_house_no: payment.receiver_house_no,
      receiver_city: payment.receiver_city,
      receiver_postcode: payment.receiver_postcode,
      receiver_country_code: payment.receiver_country_code,
      receiver_bc_no: payment.receiver_bc_no,
      receiver_bank_no: payment.receiver_bank_no,
      receiver_bank_name: payment.receiver_bank_name,
      fee_type: map_fee_type(payment.fee_type),
      is_salary_payment: payment.salary_payment?,
      reference_no: payment.reference_no,
      message: payment.message,
      booking_text: payment.booking_text
    }
    |> compact()
  end

  defp remap_edit_outgoing_payment(%OutgoingPayment{} = payment) do
    %{
      payment_id: payment.id,
      execution_date: to_iso8601(payment.execution_date),
      amount: payment.amount,
      fee_type: map_fee_type(payment.fee_type),
      is_salary_payment: payment.salary_payment?,
      reference_no: payment.reference_no,
      message: payment.message,
      receiver_iban: payment.receiver_iban,
      receiver_name: payment.receiver_name,
      receiver_street: payment.receiver_street,
      receiver_house_no: payment.receiver_house_no,
      receiver_city: payment.receiver_city,
      receiver_postcode: payment.receiver_postcode,
      receiver_country_code: payment.receiver_country_code
    }
    |> compact()
  end

  defp map_payment_type(nil), do: nil
  defp map_payment_type(type), do: type |> Atom.to_string() |> String.upcase()

  defp map_fee_type(nil), do: nil
  defp map_fee_type(:by_sender), do: "BY_SENDER"
  defp map_fee_type(:by_receiver), do: "BY_RECEIVER"
  defp map_fee_type(:breakdown), do: "BREAKDOWN"
  defp map_fee_type(:no_fee), do: "NO_FEE"

  defp map_from_outgoing_payment(
         %{
           "id" => id,
           "bill_id" => bill_id,
           "payment_type" => payment_type,
           "execution_date" => execution_date,
           "status" => status,
           "amount" => amount,
           "sender_bank_account_id" => sender_bank_account_id
         } = outgoing_payment,
         _env \\ nil
       ) do
    %OutgoingPayment{
      id: id,
      bill_id: bill_id,
      payment_type: map_outgoing_payment_type(payment_type),
      execution_date: to_date(execution_date),
      status: map_outgoing_payment_status(status),
      amount: amount,
      sender_bank_account_id: sender_bank_account_id,
      created_at: convert_date_time(Map.get(outgoing_payment, "created_at")),
      currency_code: Map.get(outgoing_payment, "currency_code"),
      exchange_rate: Map.get(outgoing_payment, "exchange_rate"),
      note: Map.get(outgoing_payment, "note"),
      sender_iban: Map.get(outgoing_payment, "sender_iban"),
      sender_name: Map.get(outgoing_payment, "sender_name"),
      sender_street: Map.get(outgoing_payment, "sender_street"),
      sender_house_no: Map.get(outgoing_payment, "sender_house_no"),
      sender_city: Map.get(outgoing_payment, "sender_city"),
      sender_postcode: Map.get(outgoing_payment, "sender_postcode"),
      sender_country_code: Map.get(outgoing_payment, "sender_country_code"),
      sender_bc_no: Map.get(outgoing_payment, "sender_bc_no"),
      sender_bank_no: Map.get(outgoing_payment, "sender_bank_no"),
      sender_bank_name: Map.get(outgoing_payment, "sender_bank_name"),
      # deprecated by bexio, still present in the list response
      receiver_account_no: Map.get(outgoing_payment, "receiver_account_no"),
      receiver_iban: Map.get(outgoing_payment, "receiver_iban"),
      receiver_name: Map.get(outgoing_payment, "receiver_name"),
      receiver_street: Map.get(outgoing_payment, "receiver_street"),
      receiver_house_no: Map.get(outgoing_payment, "receiver_house_no"),
      receiver_city: Map.get(outgoing_payment, "receiver_city"),
      receiver_postcode: Map.get(outgoing_payment, "receiver_postcode"),
      receiver_country_code: Map.get(outgoing_payment, "receiver_country_code"),
      receiver_bc_no: Map.get(outgoing_payment, "receiver_bc_no"),
      receiver_bank_no: Map.get(outgoing_payment, "receiver_bank_no"),
      receiver_bank_name: Map.get(outgoing_payment, "receiver_bank_name"),
      fee_type: map_outgoing_payment_fee_type(Map.get(outgoing_payment, "fee_type")),
      salary_payment?: Map.get(outgoing_payment, "is_salary_payment"),
      reference_no: Map.get(outgoing_payment, "reference_no"),
      message: Map.get(outgoing_payment, "message"),
      booking_text: Map.get(outgoing_payment, "booking_text"),
      banking_payment_id: Map.get(outgoing_payment, "banking_payment_id"),
      banking_payment_entry_id: Map.get(outgoing_payment, "banking_payment_entry_id"),
      transaction_id: Map.get(outgoing_payment, "transaction_id")
    }
  end

  defp map_outgoing_payment_type("IBAN"), do: :iban
  defp map_outgoing_payment_type("MANUAL"), do: :manual
  defp map_outgoing_payment_type("CASH_DISCOUNT"), do: :cash_discount
  defp map_outgoing_payment_type("QR"), do: :qr

  defp map_outgoing_payment_status("PENDING"), do: :pending
  defp map_outgoing_payment_status("TRANSFERRED"), do: :transferred
  defp map_outgoing_payment_status("DOWNLOADED"), do: :downloaded
  defp map_outgoing_payment_status("RECONCILED"), do: :reconciled

  defp map_outgoing_payment_fee_type(nil), do: nil
  defp map_outgoing_payment_fee_type("BY_SENDER"), do: :by_sender
  defp map_outgoing_payment_fee_type("BY_RECEIVER"), do: :by_receiver
  defp map_outgoing_payment_fee_type("BREAKDOWN"), do: :breakdown
  defp map_outgoing_payment_fee_type("NO_FEE"), do: :no_fee

  defp map_from_document_number(%{"valid" => valid?} = document_number, _env) do
    %DocumentNumber{
      valid?: valid?,
      next_available_no: Map.get(document_number, "next_available_no")
    }
  end

  # The delete endpoints of the v4 purchase API return 204 with an empty body;
  # reinterpret it as the common {"success": true} response.
  defp delete_204_as_success({:ok, %Req.Response{status: 204} = response}) do
    {:ok, %{response | status: 200, body: %{"success" => true}}}
  end

  defp delete_204_as_success(other), do: other

  defp convert_date_time(nil), do: nil

  defp convert_date_time(date_time) do
    case DateTime.from_iso8601(date_time) do
      {:ok, dt, _offset} ->
        dt

      # the single-bill response documents created_at without an offset
      {:error, _error} ->
        NaiveDateTime.from_iso8601!(date_time)
    end
  end
end
