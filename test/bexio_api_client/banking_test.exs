defmodule BexioApiClient.BankingTest do
  use TestHelper

  use ExUnit.Case, async: true

  doctest BexioApiClient.Banking

  alias BexioApiClient.Banking

  alias BexioApiClient.Banking.{
    BankAccount,
    Payment,
    PaymentPurchaseReference,
    PaymentRecipient,
    PaymentRecipientAddress,
    PaymentSender
  }

  @bank_account %{
    "id" => 4,
    "name" => "UBS",
    "owner" => "Metzgerei Schneider",
    "owner_address" => "Alte Jonastrasse 10",
    "owner_house_number" => 10,
    "owner_zip" => 8640,
    "owner_city" => "Rapperswil",
    "owner_country_code" => "CH",
    "bc_nr" => 250,
    "bank_name" => "UBS Switzerland AG",
    "bank_nr" => "UBSWCHZH86M",
    "bank_account_nr" => "25010367101Y",
    "iban_nr" => "CH560025025010367101Y",
    "currency_id" => 1,
    "account_id" => 77,
    "remarks" => "This is an additional description",
    "invoice_mode" => "qr_invoice",
    "qr_invoice_iban" => "CH4431999123000889012",
    "type" => "bank"
  }

  @payment %{
    "id" => 1,
    "uuid" => "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c",
    "sender" => %{
      "id" => 4,
      "uuid" => "8b472f0f-7f8b-4f0a-9c5e-0cb4e5e0080c",
      "iban" => "CH560025025010367101Y"
    },
    "recipient" => %{
      "name" => "John Doe / John Doe Company Name",
      "iban" => "CH3000784295116252003",
      "address" => %{
        "street_name" => "Föhrenstrasse",
        "house_number" => "34",
        "zip" => "5003",
        "city" => "Zürich",
        "country_code" => "CH"
      }
    },
    "amount" => "10.5858",
    "currency" => "CHF",
    "execution_date" => "2022-02-01",
    "allowance" => "fee_paid_by_payer",
    "is_salary" => false,
    "instruction_id" => "instruction-1",
    "purchase_reference" => %{
      "bill_id" => "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c",
      "bill_payment_id" => "98f2c638-ee51-4159-9c26-27958d8fd6be"
    },
    "document_no" => "0000044",
    "qr_reference_number" => "RF95000000000000000000011 / CH4431999123000889012",
    "additional_information" => "additional information",
    "status" => "open",
    "type" => "iban",
    "due_date" => "2022-02-01",
    "created_at" => "2022-01-31T10:00:00+01:00",
    "is_editing_restricted" => false
  }

  describe "fetching a list of bank accounts" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/banking/accounts"} = conn ->
          json(conn, [@bank_account])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = Banking.fetch_bank_accounts(client)

      assert %BankAccount{} = result
      assert result.id == 4
      assert result.name == "UBS"
      assert result.owner == "Metzgerei Schneider"
      assert result.owner_address == "Alte Jonastrasse 10"
      assert result.owner_house_number == 10
      assert result.owner_zip == 8640
      assert result.owner_city == "Rapperswil"
      assert result.owner_country_code == "CH"
      assert result.bc_nr == 250
      assert result.bank_name == "UBS Switzerland AG"
      assert result.bank_nr == "UBSWCHZH86M"
      assert result.bank_account_nr == "25010367101Y"
      assert result.iban_nr == "CH560025025010367101Y"
      assert result.currency_id == 1
      assert result.account_id == 77
      assert result.remarks == "This is an additional description"
      assert result.invoice_mode == "qr_invoice"
      assert result.qr_invoice_iban == "CH4431999123000889012"
      assert result.type == "bank"
    end

    test "passes limit and offset as query params" do
      client = BexioApiClient.new("123")

      mock_request(fn
        %{method: "GET", request_path: "/3.0/banking/accounts", query_params: query} = conn ->
          assert query["limit"] == "1"
          assert query["offset"] == "2"
          json(conn, [@bank_account])
      end)

      assert {:ok, [_result]} = Banking.fetch_bank_accounts(client, limit: 1, offset: 2)
    end
  end

  describe "fetching a single bank account" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/banking/accounts/4"} = conn ->
          json(conn, @bank_account)

        %{method: "GET", request_path: "/3.0/banking/accounts/99"} = conn ->
          send_resp(conn, 404, "Bank account does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = Banking.fetch_bank_account(client, 4)
      assert result.id == 4
      assert result.name == "UBS"
      assert result.iban_nr == "CH560025025010367101Y"
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Bank account does not exist"} =
               Banking.fetch_bank_account(client, 99)
    end
  end

  describe "fetching a list of payments" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/4.0/banking/payments"} = conn ->
          json(conn, [@payment])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = Banking.fetch_payments(client)

      assert %Payment{} = result
      assert result.id == 1
      assert result.uuid == "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c"
      assert result.account_id == nil

      assert %PaymentSender{} = result.sender
      assert result.sender.id == 4
      assert result.sender.uuid == "8b472f0f-7f8b-4f0a-9c5e-0cb4e5e0080c"
      assert result.sender.iban == "CH560025025010367101Y"

      assert %PaymentRecipient{} = result.recipient
      assert result.recipient.name == "John Doe / John Doe Company Name"
      assert result.recipient.iban == "CH3000784295116252003"

      assert %PaymentRecipientAddress{} = result.recipient.address
      assert result.recipient.address.street_name == "Föhrenstrasse"
      assert result.recipient.address.house_number == "34"
      assert result.recipient.address.zip == "5003"
      assert result.recipient.address.city == "Zürich"
      assert result.recipient.address.country_code == "CH"

      assert result.amount == Decimal.new("10.5858")
      assert result.currency == "CHF"
      assert result.execution_date == ~D[2022-02-01]
      assert result.allowance == :fee_paid_by_payer
      assert result.salary? == false
      assert result.instruction_id == "instruction-1"

      assert %PaymentPurchaseReference{} = result.purchase_reference
      assert result.purchase_reference.bill_id == "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c"

      assert result.purchase_reference.bill_payment_id ==
               "98f2c638-ee51-4159-9c26-27958d8fd6be"

      assert result.document_no == "0000044"
      assert result.qr_reference_number == "RF95000000000000000000011 / CH4431999123000889012"
      assert result.additional_information == "additional information"
      assert result.status == "open"
      assert result.type == :iban
      assert result.due_date == ~D[2022-02-01]
      assert result.created_at == ~U[2022-01-31 09:00:00Z]
      assert result.editing_restricted? == false
      assert result.message == nil
    end

    test "passes filter and paging as query params" do
      client = BexioApiClient.new("123")

      mock_request(fn
        %{method: "GET", request_path: "/4.0/banking/payments", query_params: query} = conn ->
          assert query["filter-by"] == "amount:11.16_16.11"
          assert query["page"] == "1"
          assert query["per-page"] == "20"
          json(conn, [@payment])
      end)

      assert {:ok, [_result]} =
               Banking.fetch_payments(client,
                 filter_by: "amount:11.16_16.11",
                 page: 1,
                 per_page: 20
               )
    end
  end

  describe "fetching a single payment" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/4.0/banking/payments/50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c"
        } =
            conn ->
          json(conn, @payment)

        %{method: "GET", request_path: "/4.0/banking/payments/unknown"} = conn ->
          send_resp(conn, 404, "Payment does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = Banking.fetch_payment(client, "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c")
      assert result.uuid == "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c"
      assert result.type == :iban
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Payment does not exist"} =
               Banking.fetch_payment(client, "unknown")
    end
  end

  describe "creating a payment" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/4.0/banking/payments"} = conn ->
          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.send_resp(201, Jason.encode!(@payment))
      end)

      :ok
    end

    test "creates a new record" do
      client = BexioApiClient.new("123")

      payment =
        Payment.new(%{
          account_id: "449e7a5c-69d3-4b8a-aaaf-5c9b713ebc65",
          type: :iban,
          amount: Decimal.new("10.5858"),
          currency: "CHF",
          execution_date: ~D[2025-11-16],
          recipient: %PaymentRecipient{
            name: "John Doe / John Doe Company Name",
            iban: "CH3000784295116252003"
          }
        })

      assert {:ok, result} = Banking.create_payment(client, payment)
      assert result.uuid == "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c"
      assert result.status == "open"
    end
  end

  describe "creating an invalid payment" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/4.0/banking/payments"} = conn ->
          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.send_resp(422, Jason.encode!(%{"errors" => %{"amount" => ["is invalid"]}}))
      end)

      :ok
    end

    test "fails on invalid data" do
      client = BexioApiClient.new("123")

      payment = Payment.new(%{type: :iban})

      assert {:error, :could_not_be_saved, %{"errors" => _}} =
               Banking.create_payment(client, payment)
    end
  end

  describe "updating a payment" do
    setup do
      mock_request(fn
        %{
          method: "PUT",
          request_path: "/4.0/banking/payments/50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c"
        } =
            conn ->
          json(conn, @payment)

        %{method: "PUT", request_path: "/4.0/banking/payments/unknown"} = conn ->
          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.send_resp(422, Jason.encode!(%{"errors" => %{"amount" => ["is invalid"]}}))
      end)

      :ok
    end

    test "updates the record" do
      client = BexioApiClient.new("123")

      payment =
        Payment.new(%{
          id: 1,
          uuid: "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c",
          amount: Decimal.new("10.5858"),
          currency: "CHF",
          execution_date: ~D[2025-11-16],
          recipient: %PaymentRecipient{
            name: "John Doe / John Doe Company Name",
            iban: "CH3000784295116252003"
          }
        })

      assert {:ok, result} = Banking.edit_payment(client, payment)
      assert result.uuid == "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c"
    end

    test "fails on invalid data" do
      client = BexioApiClient.new("123")

      payment = Payment.new(%{uuid: "unknown"})

      assert {:error, :could_not_be_saved, %{"errors" => _}} =
               Banking.edit_payment(client, payment)
    end
  end

  describe "deleting a payment" do
    setup do
      mock_request(fn %{
                        method: "DELETE",
                        request_path: "/4.0/banking/payments/50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c"
                      } =
                        conn ->
        json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the record" do
      client = BexioApiClient.new("123")

      {:ok, result} = Banking.delete_payment(client, "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c")
      assert result == true
    end
  end

  describe "cancelling a payment" do
    setup do
      mock_request(fn %{
                        method: "POST",
                        request_path:
                          "/4.0/banking/payments/50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c/cancel"
                      } =
                        conn ->
        json(conn, @payment)
      end)

      :ok
    end

    test "cancels the record" do
      client = BexioApiClient.new("123")

      {:ok, result} = Banking.cancel_payment(client, "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c")
      assert result.status == "open"
      assert result.type == :iban
    end
  end
end
