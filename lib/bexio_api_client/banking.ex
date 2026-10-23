defmodule BexioApiClient.Banking do
  @moduledoc """
  Bexio API for the banking part of the API.

  Bank accounts are served by the bexio API v3 (`/3.0/banking/accounts`),
  payments by the bexio API v4 (`/4.0/banking/payments`). The docs model IBAN
  and QR payments as separate payload variants (`type`: `iban` or `qr`) of the
  same payments resource.
  """

  import BexioApiClient.Helpers

  alias BexioApiClient.Banking.{
    BankAccount,
    Payment,
    PaymentPurchaseReference,
    PaymentRecipient,
    PaymentRecipientAddress,
    PaymentSender
  }

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @type api_error_type :: BexioApiClient.Helpers.api_error_type()

  @type payment_list_opt ::
          {:filter_by, String.t()}
          | {:page, non_neg_integer()}
          | {:per_page, pos_integer()}

  # Bank accounts

  @doc """
  Fetch a list of all bank accounts which are shown on the banking component page.
  """
  @spec fetch_bank_accounts(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [BankAccount.t()]} | api_error_type()
  def fetch_bank_accounts(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/banking/accounts", params: opts_to_query(opts))
      end,
      &map_from_bank_accounts/2
    )
  end

  @doc """
  Fetch a single bank account which is shown on the banking component page.
  """
  @spec fetch_bank_account(
          req :: Req.Request.t(),
          bank_account_id :: pos_integer()
        ) :: {:ok, BankAccount.t()} | api_error_type()
  def fetch_bank_account(req, bank_account_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/banking/accounts/#{bank_account_id}")
      end,
      &map_from_bank_account/2
    )
  end

  defp map_from_bank_accounts(bank_accounts, _env),
    do: Enum.map(bank_accounts, &map_from_bank_account/1)

  defp map_from_bank_account(%{"id" => id, "name" => name} = bank_account, _env \\ nil) do
    %BankAccount{
      id: id,
      name: name,
      owner: Map.get(bank_account, "owner"),
      owner_address: Map.get(bank_account, "owner_address"),
      owner_house_number: Map.get(bank_account, "owner_house_number"),
      owner_zip: Map.get(bank_account, "owner_zip"),
      owner_city: Map.get(bank_account, "owner_city"),
      owner_country_code: Map.get(bank_account, "owner_country_code"),
      bc_nr: Map.get(bank_account, "bc_nr"),
      bank_name: Map.get(bank_account, "bank_name"),
      bank_nr: Map.get(bank_account, "bank_nr"),
      bank_account_nr: Map.get(bank_account, "bank_account_nr"),
      iban_nr: Map.get(bank_account, "iban_nr"),
      currency_id: Map.get(bank_account, "currency_id"),
      account_id: Map.get(bank_account, "account_id"),
      remarks: Map.get(bank_account, "remarks"),
      invoice_mode: Map.get(bank_account, "invoice_mode"),
      qr_invoice_iban: Map.get(bank_account, "qr_invoice_iban"),
      type: Map.get(bank_account, "type")
    }
  end

  # Payments

  @doc """
  Fetch a list of all payments.

  ## Options:

    * `:filter_by` - filters can be used in range `_`, separated by `;`,
      example: `filter_by: "amount:11.16_16.11;execution_date:2025-11-16_2025-12-16"`
    * `:page` - skip over a number of elements by specifying a page
    * `:per_page` - limit the number of results (max is 2000)
  """
  @spec fetch_payments(
          req :: Req.Request.t(),
          opts :: [payment_list_opt()]
        ) :: {:ok, [Payment.t()]} | api_error_type()
  def fetch_payments(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/4.0/banking/payments", params: payments_opts_to_query(opts))
      end,
      &map_from_payments/2
    )
  end

  defp payments_opts_to_query(opts) do
    opts
    |> Enum.map(fn
      {:filter_by, value} -> {:"filter-by", value}
      {:page, value} -> {:page, value}
      {:per_page, value} -> {:"per-page", value}
    end)
    |> Enum.filter(fn {_key, value} -> value != nil end)
  end

  @doc """
  Get a single payment. The payment id is the uuid of the payment.
  """
  @spec fetch_payment(
          req :: Req.Request.t(),
          payment_id :: String.t()
        ) :: {:ok, Payment.t()} | api_error_type()
  def fetch_payment(req, payment_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/4.0/banking/payments/#{payment_id}")
      end,
      &map_from_payment/2
    )
  end

  @doc """
  Create a payment. The type of the payment (`:iban` or `:qr`) determines which
  fields are required — see the `Payment` struct. The `account_id` is the uuid
  of the bank account the payment is sent from.
  """
  @spec create_payment(
          req :: Req.Request.t(),
          payment :: Payment.t()
        ) :: {:ok, Payment.t()} | api_error_type()
  def create_payment(req, payment) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/4.0/banking/payments", json: remap_create_payment(payment))
      end,
      &map_from_payment/2
    )
  end

  @doc """
  Update a payment (the update payload has no `account_id` and no `type` —
  the type of a payment cannot be changed).
  """
  @spec edit_payment(
          req :: Req.Request.t(),
          payment :: Payment.t()
        ) :: {:ok, Payment.t()} | api_error_type()
  def edit_payment(req, payment) do
    bexio_body_handling(
      fn ->
        Req.put(
          req,
          url: "/4.0/banking/payments/#{payment_id(payment)}",
          json: remap_edit_payment(payment)
        )
      end,
      &map_from_payment/2
    )
  end

  @doc """
  Permanently delete an existing payment. It cannot be undone.
  """
  @spec delete_payment(
          req :: Req.Request.t(),
          payment_id :: String.t()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_payment(req, payment_id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/4.0/banking/payments/#{payment_id}")
      end,
      &success_response/2
    )
  end

  @doc """
  Cancel an existing payment. Please note that a payment can only be cancelled
  when the status is "downloaded", "transferred" or "error".
  """
  @spec cancel_payment(
          req :: Req.Request.t(),
          payment_id :: String.t()
        ) :: {:ok, Payment.t()} | api_error_type()
  def cancel_payment(req, payment_id) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/4.0/banking/payments/#{payment_id}/cancel")
      end,
      &map_from_payment/2
    )
  end

  defp payment_id(%Payment{uuid: uuid, id: id}), do: uuid || id

  defp map_from_payments(payments, _env), do: Enum.map(payments, &map_from_payment/1)

  defp map_from_payment(
         %{
           "id" => id,
           "uuid" => uuid,
           "amount" => amount,
           "currency" => currency,
           "execution_date" => execution_date,
           "status" => status,
           "type" => type,
           "created_at" => created_at
         } = payment,
         _env \\ nil
       ) do
    %Payment{
      id: id,
      uuid: uuid,
      account_id: nil,
      sender: map_sender(Map.get(payment, "sender")),
      recipient: map_recipient(Map.get(payment, "recipient")),
      amount: parse_amount(amount),
      currency: currency,
      execution_date: to_date(execution_date),
      allowance: allowance(Map.get(payment, "allowance")),
      salary?: Map.get(payment, "is_salary"),
      instruction_id: Map.get(payment, "instruction_id"),
      purchase_reference: map_purchase_reference(Map.get(payment, "purchase_reference")),
      document_no: Map.get(payment, "document_no"),
      qr_reference_number: Map.get(payment, "qr_reference_number"),
      additional_information: Map.get(payment, "additional_information"),
      status: status,
      type: payment_type(type),
      due_date: to_date(Map.get(payment, "due_date")),
      created_at: parse_created_at(created_at),
      editing_restricted?: Map.get(payment, "is_editing_restricted"),
      message: nil
    }
  end

  defp map_sender(nil), do: nil

  defp map_sender(sender) do
    %PaymentSender{
      id: Map.get(sender, "id"),
      uuid: Map.get(sender, "uuid"),
      iban: Map.get(sender, "iban")
    }
  end

  defp map_recipient(nil), do: nil

  defp map_recipient(recipient) do
    %PaymentRecipient{
      name: Map.get(recipient, "name"),
      iban: Map.get(recipient, "iban"),
      address: map_recipient_address(Map.get(recipient, "address"))
    }
  end

  defp map_recipient_address(nil), do: nil

  defp map_recipient_address(address) do
    %PaymentRecipientAddress{
      street_name: Map.get(address, "street_name"),
      house_number: Map.get(address, "house_number"),
      zip: Map.get(address, "zip"),
      city: Map.get(address, "city"),
      country_code: Map.get(address, "country_code")
    }
  end

  defp map_purchase_reference(nil), do: nil

  defp map_purchase_reference(purchase_reference) do
    %PaymentPurchaseReference{
      bill_id: Map.get(purchase_reference, "bill_id"),
      bill_payment_id: Map.get(purchase_reference, "bill_payment_id")
    }
  end

  # The docs show the amount as a string ("10.5858") but declare it as a number
  defp parse_amount(nil), do: nil
  defp parse_amount(amount) when is_binary(amount), do: Decimal.new(amount)
  defp parse_amount(amount) when is_integer(amount), do: Decimal.new(amount)
  defp parse_amount(amount) when is_float(amount), do: Decimal.from_float(amount)

  # The docs do not declare a format for created_at ("string"); parse an
  # ISO8601 datetime with offset and fall back to a naive datetime
  defp parse_created_at(nil), do: nil

  defp parse_created_at(created_at) when is_binary(created_at) do
    case DateTime.from_iso8601(created_at) do
      {:ok, datetime, _offset} -> datetime
      {:error, _error} -> NaiveDateTime.from_iso8601!(created_at)
    end
  end

  defp allowance("fee_paid_by_payer"), do: :fee_paid_by_payer
  defp allowance("fee_paid_by_payee"), do: :fee_paid_by_payee
  defp allowance("fee_split"), do: :fee_split
  defp allowance("no_fee"), do: :no_fee
  defp allowance(_allowance), do: nil

  defp payment_type("iban"), do: :iban
  defp payment_type("qr"), do: :qr
  defp payment_type(_type), do: nil

  defp remap_create_payment(%Payment{} = payment) do
    payment
    |> remap_edit_payment()
    |> Map.put(:account_id, payment.account_id)
    |> Map.put(:type, payment_type_string(payment.type))
    |> Enum.filter(fn {_key, value} -> value != nil end)
    |> Enum.into(%{})
  end

  defp remap_edit_payment(%Payment{
         amount: amount,
         currency: currency,
         execution_date: execution_date,
         allowance: allowance,
         salary?: salary?,
         recipient: recipient,
         qr_reference_number: qr_reference_number,
         additional_information: additional_information,
         purchase_reference: purchase_reference,
         editing_restricted?: editing_restricted?,
         message: message
       }) do
    %{
      amount: decimal_to_string(amount),
      currency: currency,
      execution_date: to_iso8601(execution_date),
      allowance: allowance_string(allowance),
      salary?: salary?,
      recipient: remap_recipient(recipient),
      qr_reference_number: qr_reference_number,
      additional_information: additional_information,
      purchase_reference: remap_purchase_reference(purchase_reference),
      editing_restricted?: editing_restricted?,
      message: message
    }
    |> Enum.filter(fn {_key, value} -> value != nil end)
    |> Enum.into(%{})
  end

  defp remap_recipient(nil), do: nil

  defp remap_recipient(%PaymentRecipient{name: name, iban: iban, address: address}) do
    %{
      name: name,
      iban: iban,
      address: remap_recipient_address(address)
    }
    |> Enum.filter(fn {_key, value} -> value != nil end)
    |> Enum.into(%{})
  end

  defp remap_recipient_address(nil), do: nil

  defp remap_recipient_address(%PaymentRecipientAddress{
         street_name: street_name,
         house_number: house_number,
         zip: zip,
         city: city,
         country_code: country_code
       }) do
    %{
      street_name: street_name,
      house_number: house_number,
      zip: zip,
      city: city,
      country_code: country_code
    }
    |> Enum.filter(fn {_key, value} -> value != nil end)
    |> Enum.into(%{})
  end

  defp remap_purchase_reference(nil), do: nil

  defp remap_purchase_reference(%PaymentPurchaseReference{
         bill_id: bill_id,
         bill_payment_id: bill_payment_id
       }) do
    %{
      bill_id: bill_id,
      bill_payment_id: bill_payment_id
    }
    |> Enum.filter(fn {_key, value} -> value != nil end)
    |> Enum.into(%{})
  end

  defp decimal_to_string(nil), do: nil
  defp decimal_to_string(%Decimal{} = decimal), do: Decimal.to_string(decimal)

  defp allowance_string(:fee_paid_by_payer), do: "fee_paid_by_payer"
  defp allowance_string(:fee_paid_by_payee), do: "fee_paid_by_payee"
  defp allowance_string(:fee_split), do: "fee_split"
  defp allowance_string(:no_fee), do: "no_fee"
  defp allowance_string(_allowance), do: nil

  defp payment_type_string(:iban), do: "iban"
  defp payment_type_string(:qr), do: "qr"
  defp payment_type_string(_type), do: nil
end
