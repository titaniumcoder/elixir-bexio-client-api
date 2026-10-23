defmodule BexioApiClient.PurchaseTest do
  use TestHelper

  use ExUnit.Case, async: true

  doctest BexioApiClient.Contacts

  @bill_response %{
    "id" => "64bf865d-988a-496d-a24f-bab2d52e4b4a",
    "document_no" => "LR-12345",
    "title" => "Bill 42",
    "status" => "DRAFT",
    "firstname_suffix" => "LeSS",
    "lastname_company" => "Organisation",
    "created_at" => "2019-02-12T09:53:49",
    "supplier_id" => 1323,
    "vendor_ref" => "Reference text",
    "contact_partner_id" => 647,
    "bill_date" => "2019-02-12",
    "due_date" => "2019-03-14",
    "pending_amount" => 65.23,
    "amount_man" => 23.87,
    "amount_calc" => 23.9,
    "manual_amount" => true,
    "currency_code" => "USD",
    "exchange_rate" => 2.3455365492,
    "base_currency_code" => "USD",
    "item_net" => false,
    "split_into_line_items" => true,
    "purchase_order_id" => 637,
    "base_currency_amount" => 75.23,
    "overdue" => true,
    "qr_bill_information" =>
      "//S1/10/10201409/11/190512/20/1400.000-53/30/106017086/31/180508/32/7.7/40/2:10;0:30",
    "address" => %{
      "title" => "Prof",
      "salutation" => "Mrs",
      "firstname_suffix" => "John",
      "lastname_company" => "Newman",
      "address_line" => "Mega Street",
      "postcode" => "6694",
      "city" => "Tel Aviv",
      "country_code" => "CH",
      "main_contact_id" => 45,
      "contact_address_id" => 827,
      "type" => "PRIVATE"
    },
    "line_items" => [
      %{
        "id" => "2d267f64-6b94-4109-818e-c54515837004",
        "position" => 0,
        "title" => "First line item title",
        "tax_id" => 15,
        "tax_calc" => 12.89,
        "amount" => 56.8,
        "booking_account_id" => 16
      },
      %{
        "id" => "e33ecd04-188e-40b5-92eb-02f9efbf1b1c",
        "position" => 1,
        "title" => "Second line item title",
        "tax_id" => 15,
        "tax_calc" => 8.89,
        "amount" => 48.8,
        "booking_account_id" => 14
      }
    ],
    "discounts" => [
      %{
        "id" => "8b102a32-5bef-462e-a41b-9c00197c26b9",
        "position" => 1,
        "amount" => 56.8
      }
    ],
    "payment" => %{
      "type" => "IBAN",
      "bank_account_id" => 12,
      "fee" => "BY_SENDER",
      "execution_date" => "2019-03-15",
      "exchange_rate" => 2.34553,
      "amount" => 3.9,
      "iban" => "CH121234567812345678900",
      "name" => "LeSS Organisation",
      "address" => "1147 Super Street",
      "street" => "Super Street",
      "house_no" => 1147,
      "postcode" => "9999",
      "city" => "Tel Aviv",
      "country_code" => "CH",
      "message" => "This is a message.",
      "booking_text" => "Further education.",
      "salary_payment" => false,
      "reference_no" => "1212345675321984798456",
      "note" => "Some note text"
    },
    "attachment_ids" => [
      "e84b9fe2-3fe2-4fcf-8c30-298fe16adb14",
      "aa9fc418-f292-49ad-9a35-9869123d1091"
    ]
  }

  @expense_response %{
    "id" => "1355499f-aa07-4382-887e-acaf0323e6f6",
    "document_no" => "123",
    "title" => "Some Title",
    "status" => "DRAFT",
    "firstname_suffix" => "Less",
    "lastname_company" => "Organisation",
    "created_at" => "2019-03-23T09:53:49+0000",
    "supplier_id" => 1,
    "paid_on" => "2019-03-20",
    "bank_account_id" => 3,
    "booking_account_id" => 4,
    "currency_code" => "CHF",
    "base_currency_code" => "USD",
    "exchange_rate" => 1.4355684751,
    "amount" => 30.9,
    "tax_man" => 1.14,
    "tax_calc" => 3.45,
    "tax_id" => 6,
    "base_currency_amount" => 24.84,
    "transaction_id" => "b4229af3-a20f-4f68-b513-db651dd2c2ea",
    "invoice_id" => "9d47155f-eac4-491e-96d0-8e187c5a7ab6",
    "project_id" => "1a1864c0-ba80-46a8-ad89-ffd128db9456",
    "attachment_ids" => [
      "06573f59-01a2-493d-9876-462deda4cee3",
      "a230f087-f742-4259-925e-cf3abea5e6bf"
    ],
    "address" => %{
      "title" => "Prof",
      "salutation" => "Mrs",
      "firstname_suffix" => "John",
      "lastname_company" => "Newman",
      "address_line" => "Mega Street",
      "postcode" => "6694",
      "city" => "Tel Aviv",
      "country_code" => "CH",
      "main_contact_id" => 45,
      "contact_address_id" => 827,
      "type" => "PRIVATE"
    }
  }

  @purchase_order_response %{
    "id" => 1,
    "document_nr" => "RE-00001",
    "kb_payment_template_id" => 1,
    "payment_type_id" => 1,
    "title" => "purchase order example title",
    "contact_id" => 14,
    "contact_sub_id" => 1,
    "template_slug" => "581a8010821e01426b8b456b",
    "user_id" => 1,
    "project_id" => 1,
    "logopaper_id" => 1,
    "language" => %{
      "id" => 1,
      "name" => "Deutsch",
      "decimalpoint" => ".",
      "thousandsseparator" => "'",
      "iso_639_1" => "de",
      "date_format" => "d.m.Y"
    },
    "language_id" => 1,
    "bank_account_id" => 1,
    "currency" => %{
      "id" => 1,
      "name" => "CHF",
      "round_factor" => 0.05
    },
    "currency_id" => 1,
    "header" => "We would like to order the following products:",
    "footer" => "Many thanks for the fast processing of our order.",
    "total_rounding_difference" => -0.02,
    "mwst_type" => "included",
    "mwst_is_net" => true,
    "is_compact_view" => false,
    "show_position_taxes" => false,
    "salesman_user_id" => 1,
    "is_valid_from" => "2019-06-24",
    "is_valid_to" => "2019-07-24",
    "delivery_address_type" => "contact_address",
    "contact_address_manual" => "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
    "delivery_address_manual" => "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
    "nb_decimals_amount" => 2,
    "nb_decimals_price" => 2,
    "kb_item_status_id" => 22,
    "terms_of_payment_text" => "Payable within 30 days",
    "reference" => "Based on Quote Q-3860",
    "api_reference" => nil,
    "mail" => "support@bexio.com",
    "viewed_by_client_at" => "2020-07-24",
    "is_valid_until" => "2019-07-24",
    "created_at" => "2020-04-28T19:58:58+00:00",
    "updated_at" => "2020-04-30T19:58:58+00:00",
    "custom_translations" => %{},
    "date_format" => "d.m.Y",
    "positions" => %{
      "required" => [
        %{
          "type" => "text",
          "pos" => nil,
          "is_optional" => false,
          "id" => 1,
          "text" => "This position type allows to add free text to a document",
          "show_pos_nr" => false
        }
      ],
      "optional" => [
        %{
          "type" => "text",
          "pos" => nil,
          "is_optional" => false,
          "id" => 1,
          "text" => "This position type allows to add free text to a document",
          "show_pos_nr" => false
        }
      ],
      "discount" => [
        %{
          "type" => "discount",
          "pos" => nil,
          "is_optional" => false,
          "id" => 1,
          "text" => "Partner discount",
          "is_percentual" => true,
          "value" => 10,
          "discount_total" => 1.78
        }
      ]
    }
  }

  @outgoing_payment_response %{
    "id" => "f68e87e0-fa2d-4576-91c6-15f7b6876003",
    "status" => "DOWNLOADED",
    "created_at" => "2019-06-27T10:25:50+0200",
    "bill_id" => "22c306ad-c158-4792-b557-72340df816f5",
    "payment_type" => "IBAN",
    "execution_date" => "2019-10-15",
    "amount" => 45.98,
    "currency_code" => "CHF",
    "exchange_rate" => 1.0000000032,
    "note" => "Some notes",
    "sender_bank_account_id" => 2,
    "sender_iban" => "DE684734567812345678900",
    "sender_name" => "Sender name",
    "sender_street" => "Good Street",
    "sender_house_no" => "45",
    "sender_city" => "Warsaw",
    "sender_postcode" => "6723",
    "sender_country_code" => "PL",
    "sender_bc_no" => "238747349095789",
    "sender_bank_no" => "80759758235723820983",
    "sender_bank_name" => "Name of the Bank",
    "receiver_iban" => "CH121234567812345678900",
    "receiver_name" => "Receiver name",
    "receiver_street" => "Mega street",
    "receiver_house_no" => "10/20",
    "receiver_city" => "London",
    "receiver_postcode" => "3781",
    "receiver_country_code" => "CH",
    "receiver_bc_no" => "98364949095789",
    "receiver_bank_no" => "26597585382673",
    "receiver_bank_name" => "Some Bank name",
    "fee_type" => "BREAKDOWN",
    "is_salary_payment" => false,
    "reference_no" => "9568345675321984798456",
    "message" => "Some message",
    "booking_text" => "Swimming lessons",
    "banking_payment_id" => "f35d39a3-dfc4-43d1-bf38-387f821c0ed0",
    "banking_payment_entry_id" => "27c0d66a-8ea2-4b51-9ce0-372d3e0a4117",
    "transaction_id" => "b4f1e277-8424-48a7-a0b0-100646e82d25"
  }

  describe "fetching a list of bills" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/4.0/purchase/bills"} = conn ->
          json(conn, %{
            "data" => [
              %{
                "id" => "2af7df09-bf6b-4a6b-840f-142e337e692a",
                "created_at" => "2019-03-23T09:53:49+0000",
                "document_no" => "NO-1",
                "status" => "DRAFT",
                "vendor_ref" => "Vendor 1",
                "firstname_suffix" => "John",
                "lastname_company" => "Doe",
                "vendor" => "John Doe",
                "title" => "Title 1",
                "currency_code" => "CHF",
                "pending_amount" => 100.23,
                "net" => 0.45,
                "gross" => 13.42,
                "bill_date" => "2019-02-12",
                "due_date" => "2019-03-14",
                "overdue" => false,
                "booking_account_ids" => [
                  10,
                  12
                ],
                "attachment_ids" => [
                  "1cb712f3-652c-4707-9641-2de94f77e07d",
                  "ab2b0d50-f3b0-4773-9c65-6606657db25b",
                  "34ef8407-094a-419f-b649-789d36b5d145"
                ]
              },
              %{
                "id" => "99fd6dc2-09cf-4db6-8dfa-2b9b3b9394b1",
                "created_at" => "2019-05-23T09:53:49+0000",
                "document_no" => "NO-3",
                "status" => "BOOKED",
                "vendor_ref" => "Vendor 2",
                "firstname_suffix" => "James",
                "lastname_company" => "Doe",
                "vendor" => "James Doe",
                "title" => "Title 2",
                "currency_code" => "USD",
                "pending_amount" => 2.73,
                "net" => 0.01,
                "gross" => 1.42,
                "bill_date" => "2019-04-02",
                "due_date" => "2019-05-27",
                "overdue" => true,
                "booking_account_ids" => [
                  12,
                  134,
                  9
                ],
                "attachment_ids" => [
                  "1f1ef73d-6b4a-4de5-812c-27f8732be88b",
                  "d9d3a328-8c0b-4889-9b15-d3e9abc24df0"
                ]
              }
            ],
            "paging" => %{
              "page" => 1,
              "page_size" => 10,
              "page_count" => 50,
              "item_count" => 300
            }
          })
      end)

      :ok
    end

    test "shows valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, {[result1, result2], paging}} = BexioApiClient.Purchase.fetch_bills(client)

      assert paging.page == 1
      assert paging.page_size == 10
      assert paging.page_count == 50
      assert paging.item_count == 300

      assert result1.id == "2af7df09-bf6b-4a6b-840f-142e337e692a"
      assert result1.created_at == ~U[2019-03-23T09:53:49+0000]
      assert result1.document_no == "NO-1"
      assert result1.status == :draft
      assert result1.vendor_ref == "Vendor 1"
      assert result1.firstname_suffix == "John"
      assert result1.lastname_company == "Doe"
      assert result1.vendor == "John Doe"
      assert result1.title == "Title 1"
      assert result1.currency_code == "CHF"
      assert result1.pending_amount == 100.23
      assert result1.net == 0.45
      assert result1.gross == 13.42
      assert result1.bill_date == ~D[2019-02-12]
      assert result1.due_date == ~D[2019-03-14]
      assert result1.overdue? == false
      assert result1.booking_account_ids == [10, 12]

      assert result1.attachment_ids == [
               "1cb712f3-652c-4707-9641-2de94f77e07d",
               "ab2b0d50-f3b0-4773-9c65-6606657db25b",
               "34ef8407-094a-419f-b649-789d36b5d145"
             ]

      # fields of the single-bill response are nil in the list response
      assert result1.supplier_id == nil
      assert result1.line_items == []
      assert result1.payment == nil

      assert result2.id == "99fd6dc2-09cf-4db6-8dfa-2b9b3b9394b1"
      assert result2.created_at == ~U[2019-05-23T09:53:49+0000]
      assert result2.document_no == "NO-3"
      assert result2.status == :booked
      assert result2.vendor_ref == "Vendor 2"
      assert result2.firstname_suffix == "James"
      assert result2.lastname_company == "Doe"
      assert result2.vendor == "James Doe"
      assert result2.title == "Title 2"
      assert result2.currency_code == "USD"
      assert result2.pending_amount == 2.73
      assert result2.net == 0.01
      assert result2.gross == 1.42
      assert result2.bill_date == ~D[2019-04-02]
      assert result2.due_date == ~D[2019-05-27]
      assert result2.overdue? == true
      assert result2.booking_account_ids == [12, 134, 9]

      assert result2.attachment_ids == [
               "1f1ef73d-6b4a-4de5-812c-27f8732be88b",
               "d9d3a328-8c0b-4889-9b15-d3e9abc24df0"
             ]
    end
  end

  describe "fetching a single bill" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/4.0/purchase/bills/64bf865d-988a-496d-a24f-bab2d52e4b4a"} =
            conn ->
          json(conn, @bill_response)

        %{method: "GET", request_path: "/4.0/purchase/bills/unknown"} = conn ->
          send_resp(conn, 404, "Bill with specified id was not found")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      {:ok, result} =
        BexioApiClient.Purchase.fetch_bill(client, "64bf865d-988a-496d-a24f-bab2d52e4b4a")

      assert result.id == "64bf865d-988a-496d-a24f-bab2d52e4b4a"
      assert result.document_no == "LR-12345"
      assert result.title == "Bill 42"
      assert result.status == :draft
      assert result.supplier_id == 1323
      assert result.contact_partner_id == 647
      assert result.amount_man == 23.87
      assert result.amount_calc == 23.9
      assert result.manual_amount? == true
      assert result.exchange_rate == 2.3455365492
      assert result.base_currency_code == "USD"
      assert result.item_net? == false
      assert result.split_into_line_items? == true
      assert result.purchase_order_id == 637
      assert result.base_currency_amount == 75.23
      assert result.overdue? == true
      assert result.bill_date == ~D[2019-02-12]
      assert result.due_date == ~D[2019-03-14]
      assert result.address.lastname_company == "Newman"

      assert [line_item1, line_item2] = result.line_items
      assert line_item1.id == "2d267f64-6b94-4109-818e-c54515837004"
      assert line_item1.position == 0
      assert line_item1.tax_id == 15
      assert line_item1.tax_calc == 12.89
      assert line_item1.amount == 56.8
      assert line_item1.booking_account_id == 16
      assert line_item2.amount == 48.8

      assert [discount] = result.discounts
      assert discount.id == "8b102a32-5bef-462e-a41b-9c00197c26b9"
      assert discount.position == 1
      assert discount.amount == 56.8

      payment = result.payment
      assert payment.type == "IBAN"
      assert payment.bank_account_id == 12
      assert payment.fee == "BY_SENDER"
      assert payment.execution_date == ~D[2019-03-15]
      assert payment.exchange_rate == 2.34553
      assert payment.amount == 3.9
      assert payment.iban == "CH121234567812345678900"
      assert payment.house_no == 1147
      assert payment.salary_payment? == false
      assert payment.reference_no == "1212345675321984798456"

      # the documented single-bill response has created_at without an offset
      assert result.created_at == ~N[2019-02-12T09:53:49]
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Bill with specified id was not found"} =
               BexioApiClient.Purchase.fetch_bill(client, "unknown")
    end
  end

  describe "creating a bill" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/4.0/purchase/bills"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["supplier_id"] == 1323
          assert body_json["contact_partner_id"] == 647
          assert body_json["bill_date"] == "2019-02-12"
          assert body_json["due_date"] == "2019-03-14"
          assert body_json["amount_man"] == 23.8
          assert body_json["manual_amount"] == true
          assert body_json["currency_code"] == "CHF"
          assert body_json["item_net"] == false
          assert body_json["attachment_ids"] == ["e84b9fe2-3fe2-4fcf-8c30-298fe16adb14"]
          assert body_json["address"]["lastname_company"] == "Newman"

          assert body_json["line_items"] == [
                   %{
                     "position" => 0,
                     "title" => "First line item title",
                     "tax_id" => 15,
                     "amount" => 56.8,
                     "booking_account_id" => 16
                   }
                 ]

          assert body_json["discounts"] == [%{"position" => 1, "amount" => 56.8}]

          # nil fields are not sent
          refute Map.has_key?(body_json, "purchase_order_id")
          refute Map.has_key?(body_json, "payment")
          refute Map.has_key?(body_json, "document_no")

          json(conn, @bill_response)
      end)

      :ok
    end

    test "creates a new record" do
      client = BexioApiClient.new("123")

      bill =
        BexioApiClient.Purchase.Bill.new(%{
          supplier_id: 1323,
          contact_partner_id: 647,
          bill_date: ~D[2019-02-12],
          due_date: ~D[2019-03-14],
          amount_man: 23.8,
          amount_calc: 32.08,
          manual_amount?: true,
          currency_code: "CHF",
          item_net?: false,
          attachment_ids: ["e84b9fe2-3fe2-4fcf-8c30-298fe16adb14"],
          address: %BexioApiClient.Purchase.Address{lastname_company: "Newman"},
          line_items: [
            %BexioApiClient.Purchase.BillLineItem{
              position: 0,
              title: "First line item title",
              tax_id: 15,
              amount: 56.8,
              booking_account_id: 16
            }
          ],
          discounts: [%BexioApiClient.Purchase.BillDiscount{position: 1, amount: 56.8}]
        })

      {:ok, _record} = BexioApiClient.Purchase.create_bill(client, bill)
    end
  end

  describe "editing a bill" do
    setup do
      mock_request(fn
        %{method: "PUT", request_path: "/4.0/purchase/bills/64bf865d-988a-496d-a24f-bab2d52e4b4a"} =
            conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["document_no"] == "LR-12345"
          assert body_json["supplier_id"] == 1323
          assert body_json["split_into_line_items"] == true
          assert body_json["manual_amount"] == true
          assert body_json["currency_code"] == "CHF"

          json(conn, @bill_response)
      end)

      :ok
    end

    test "edits the record" do
      client = BexioApiClient.new("123")

      bill =
        BexioApiClient.Purchase.Bill.new(%{
          id: "64bf865d-988a-496d-a24f-bab2d52e4b4a",
          document_no: "LR-12345",
          supplier_id: 1323,
          contact_partner_id: 647,
          bill_date: ~D[2019-02-12],
          due_date: ~D[2019-03-14],
          amount_man: 23.8,
          manual_amount?: true,
          currency_code: "CHF",
          item_net?: false,
          split_into_line_items?: true,
          attachment_ids: []
        })

      {:ok, _record} = BexioApiClient.Purchase.edit_bill(client, bill.id, bill)
    end
  end

  describe "deleting a bill" do
    setup do
      mock_request(fn
        %{
          method: "DELETE",
          request_path: "/4.0/purchase/bills/64bf865d-988a-496d-a24f-bab2d52e4b4a"
        } =
            conn ->
          send_resp(conn, 204, "")
      end)

      :ok
    end

    test "deletes the record" do
      client = BexioApiClient.new("123")

      assert {:ok, true} =
               BexioApiClient.Purchase.delete_bill(client, "64bf865d-988a-496d-a24f-bab2d52e4b4a")
    end
  end

  describe "updating the status of a bill" do
    setup do
      mock_request(fn
        %{
          method: "PUT",
          request_path: "/4.0/purchase/bills/64bf865d-988a-496d-a24f-bab2d52e4b4a/bookings/BOOKED"
        } = conn ->
          json(conn, @bill_response)
      end)

      :ok
    end

    test "updates the status" do
      client = BexioApiClient.new("123")

      {:ok, _record} =
        BexioApiClient.Purchase.update_bill_status(
          client,
          "64bf865d-988a-496d-a24f-bab2d52e4b4a",
          :booked
        )
    end
  end

  describe "executing an action on a bill" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/4.0/purchase/bills/64bf865d-988a-496d-a24f-bab2d52e4b4a/actions"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          assert Jason.decode!(body) == %{"action" => "DUPLICATE"}

          json(conn, @bill_response)
      end)

      :ok
    end

    test "executes the action" do
      client = BexioApiClient.new("123")

      {:ok, _record} =
        BexioApiClient.Purchase.execute_bill_action(
          client,
          "64bf865d-988a-496d-a24f-bab2d52e4b4a",
          "DUPLICATE"
        )
    end
  end

  describe "fetching the bill document number validation" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/4.0/purchase/documentnumbers/bills"} = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["document_no"] == "AB-1234"

          json(conn, %{"valid" => false, "next_available_no" => "AB-1235"})
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.Purchase.fetch_bill_document_number(client, "AB-1234")

      assert result.valid? == false
      assert result.next_available_no == "AB-1235"
    end
  end

  describe "fetching a list of expenses" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/4.0/expenses"} = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["supplier_id"] == "1"
          assert conn.query_params["limit"] == "100"

          json(conn, %{
            "data" => [
              %{
                "id" => "e27be5f4-c8db-4193-92f3-1c6f1dc98f1b",
                "created_at" => "2019-03-23T09:53:49+0000",
                "document_no" => "NO-1",
                "status" => "DRAFT",
                "firstname_suffix" => "John",
                "lastname_company" => "Doe",
                "vendor" => "John Doe",
                "title" => "Title 1",
                "currency_code" => "CHF",
                "paid_on" => "2019-03-07",
                "booking_account_id" => 387,
                "net" => 26.65,
                "gross" => 29.43,
                "project_id" => "c14aa91c-b4f5-43ca-ae2a-882f94cd40f4",
                "chargeable_contact_id" => 4,
                "transaction_id" => "b388a4da-7085-475a-87a0-a2acb4d8d68f",
                "invoice_id" => "9d47155f-eac4-491e-96d0-8e187c5a7ab6",
                "attachment_ids" => [
                  "60dd4dfa-24a3-4114-a934-108380789edc",
                  "a3161942-1b1d-42c1-816d-dc44cd53c7e6"
                ]
              },
              %{
                "id" => "dd6d20f4-8c77-45ba-952f-84948798c79b",
                "created_at" => "2019-05-23T09:53:49+0000",
                "document_no" => "NO-3",
                "status" => "DONE",
                "vendor_ref" => "Vendor 2",
                "firstname_suffix" => "James",
                "lastname_company" => "Doe",
                "vendor" => "James Doe",
                "title" => "Title 2",
                "currency_code" => "USD",
                "paid_on" => "2018-02-07",
                "booking_account_id" => 7,
                "net" => 31.39,
                "gross" => 50.44,
                "project_id" => "1a1864c0-ba80-46a8-ad89-ffd128db9456",
                "chargeable_contact_id" => 7,
                "transaction_id" => "771590b0-a794-461f-a375-886e4634b618",
                "invoice_id" => "9d47155f-eac4-491e-96d0-8e187c5a7ab6",
                "attachment_ids" => [
                  "06573f59-01a2-493d-9876-462deda4cee3",
                  "a230f087-f742-4259-925e-cf3abea5e6bf"
                ]
              }
            ],
            "paging" => %{
              "page" => 1,
              "page_size" => 10,
              "page_count" => 50,
              "item_count" => 300
            }
          })
      end)

      :ok
    end

    test "shows valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, {[result1, result2], paging}} =
               BexioApiClient.Purchase.fetch_expenses(client, supplier_id: 1, limit: 100)

      assert paging.page == 1
      assert paging.page_size == 10
      assert paging.page_count == 50
      assert paging.item_count == 300

      assert result1.id == "e27be5f4-c8db-4193-92f3-1c6f1dc98f1b"
      assert result1.created_at == ~U[2019-03-23T09:53:49+0000]
      assert result1.document_no == "NO-1"
      assert result1.status == :draft
      assert result1.lastname_company == "Doe"
      assert result1.title == "Title 1"
      assert result1.currency_code == "CHF"
      assert result1.paid_on == ~D[2019-03-07]
      assert result1.booking_account_id == 387
      assert result1.project_id == "c14aa91c-b4f5-43ca-ae2a-882f94cd40f4"
      assert result1.transaction_id == "b388a4da-7085-475a-87a0-a2acb4d8d68f"
      assert result1.invoice_id == "9d47155f-eac4-491e-96d0-8e187c5a7ab6"
      # vendor_ref is only present on some list entries
      assert result1.vendor_ref == nil

      assert result2.status == :done
      assert result2.vendor_ref == "Vendor 2"
      assert result2.paid_on == ~D[2018-02-07]
    end
  end

  describe "fetching a single expense" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/4.0/expenses/1355499f-aa07-4382-887e-acaf0323e6f6"} =
            conn ->
          json(conn, @expense_response)

        %{method: "GET", request_path: "/4.0/expenses/unknown"} = conn ->
          send_resp(conn, 404, "Expense with specified id was not found")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      {:ok, result} =
        BexioApiClient.Purchase.fetch_expense(client, "1355499f-aa07-4382-887e-acaf0323e6f6")

      assert result.id == "1355499f-aa07-4382-887e-acaf0323e6f6"
      assert result.document_no == "123"
      assert result.title == "Some Title"
      assert result.status == :draft
      assert result.supplier_id == 1
      assert result.paid_on == ~D[2019-03-20]
      assert result.bank_account_id == 3
      assert result.booking_account_id == 4
      assert result.currency_code == "CHF"
      assert result.base_currency_code == "USD"
      assert result.exchange_rate == 1.4355684751
      assert result.amount == 30.9
      assert result.tax_man == 1.14
      assert result.tax_calc == 3.45
      assert result.tax_id == 6
      assert result.base_currency_amount == 24.84
      assert result.transaction_id == "b4229af3-a20f-4f68-b513-db651dd2c2ea"
      assert result.invoice_id == "9d47155f-eac4-491e-96d0-8e187c5a7ab6"
      assert result.project_id == "1a1864c0-ba80-46a8-ad89-ffd128db9456"
      assert result.address.lastname_company == "Newman"
      assert result.created_at == ~U[2019-03-23T09:53:49+0000]
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Expense with specified id was not found"} =
               BexioApiClient.Purchase.fetch_expense(client, "unknown")
    end
  end

  describe "creating an expense" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/4.0/expenses"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["paid_on"] == "2019-03-20"
          assert body_json["currency_code"] == "CHF"
          assert body_json["supplier_id"] == 123
          assert body_json["title"] == "Expense 42"
          assert body_json["bank_account_id"] == 5
          assert body_json["booking_account_id"] == 16
          assert body_json["amount"] == 80.54
          assert body_json["tax_id"] == 15

          assert body_json["attachment_ids"] == [
                   "3c570a07-1fa1-41e7-a761-0f486dfc01f6",
                   "138c5618-744c-4c05-b504-c034ccf5f7d9"
                 ]

          assert body_json["address"]["lastname_company"] == "Newman"

          # nil fields are not sent
          refute Map.has_key?(body_json, "document_no")
          refute Map.has_key?(body_json, "exchange_rate")

          json(conn, @expense_response)
      end)

      :ok
    end

    test "creates a new record" do
      client = BexioApiClient.new("123")

      expense =
        BexioApiClient.Purchase.Expense.new(%{
          paid_on: ~D[2019-03-20],
          currency_code: "CHF",
          supplier_id: 123,
          title: "Expense 42",
          bank_account_id: 5,
          booking_account_id: 16,
          amount: 80.54,
          tax_id: 15,
          attachment_ids: [
            "3c570a07-1fa1-41e7-a761-0f486dfc01f6",
            "138c5618-744c-4c05-b504-c034ccf5f7d9"
          ],
          address: %BexioApiClient.Purchase.Address{lastname_company: "Newman"}
        })

      {:ok, _record} = BexioApiClient.Purchase.create_expense(client, expense)
    end
  end

  describe "editing an expense" do
    setup do
      mock_request(fn
        %{method: "PUT", request_path: "/4.0/expenses/1355499f-aa07-4382-887e-acaf0323e6f6"} =
            conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["document_no"] == "LR-12345"
          assert body_json["paid_on"] == "2019-03-20"
          assert body_json["amount"] == 80.54

          json(conn, @expense_response)
      end)

      :ok
    end

    test "edits the record" do
      client = BexioApiClient.new("123")

      expense =
        BexioApiClient.Purchase.Expense.new(%{
          paid_on: ~D[2019-03-20],
          currency_code: "CHF",
          document_no: "LR-12345",
          amount: 80.54,
          attachment_ids: []
        })

      {:ok, _record} =
        BexioApiClient.Purchase.edit_expense(
          client,
          "1355499f-aa07-4382-887e-acaf0323e6f6",
          expense
        )
    end
  end

  describe "deleting an expense" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/4.0/expenses/1355499f-aa07-4382-887e-acaf0323e6f6"} =
            conn ->
          send_resp(conn, 204, "")
      end)

      :ok
    end

    test "deletes the record" do
      client = BexioApiClient.new("123")

      assert {:ok, true} =
               BexioApiClient.Purchase.delete_expense(
                 client,
                 "1355499f-aa07-4382-887e-acaf0323e6f6"
               )
    end
  end

  describe "updating the status of an expense" do
    setup do
      mock_request(fn
        %{
          method: "PUT",
          request_path: "/4.0/expenses/1355499f-aa07-4382-887e-acaf0323e6f6/bookings/DONE"
        } =
            conn ->
          json(conn, @expense_response)
      end)

      :ok
    end

    test "updates the status" do
      client = BexioApiClient.new("123")

      {:ok, _record} =
        BexioApiClient.Purchase.update_expense_status(
          client,
          "1355499f-aa07-4382-887e-acaf0323e6f6",
          :done
        )
    end
  end

  describe "executing an action on an expense" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/4.0/expenses/1355499f-aa07-4382-887e-acaf0323e6f6/actions"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          assert Jason.decode!(body) == %{"action" => "DUPLICATE"}

          json(conn, @expense_response)
      end)

      :ok
    end

    test "executes the action" do
      client = BexioApiClient.new("123")

      {:ok, _record} =
        BexioApiClient.Purchase.execute_expense_action(
          client,
          "1355499f-aa07-4382-887e-acaf0323e6f6",
          "DUPLICATE"
        )
    end
  end

  describe "fetching the expense document number validation" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/4.0/expenses/documentnumbers"} = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["document_no"] == "AB-1234"

          json(conn, %{"valid" => true})
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.Purchase.fetch_expense_document_number(client, "AB-1234")

      assert result.valid? == true
      assert result.next_available_no == nil
    end
  end

  describe "fetching a list of purchase orders" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/purchase_orders"} = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["limit"] == "500"
          assert conn.query_params["offset"] == "50"
          assert conn.query_params["order_by"] == "id_desc"

          # the list response does not contain positions
          json(conn, [Map.delete(@purchase_order_response, "positions")])
      end)

      :ok
    end

    test "shows valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.Purchase.fetch_purchase_orders(client,
                 limit: 500,
                 offset: 50,
                 order_by: :id_desc
               )

      assert result.id == 1
      assert result.document_nr == "RE-00001"
      assert result.title == "purchase order example title"
      assert result.contact_id == 14
      assert result.user_id == 1
      assert result.language_id == 1
      assert result.language["name"] == "Deutsch"
      assert result.currency["name"] == "CHF"
      assert result.currency_id == 1
      assert result.total_rounding_difference == -0.02
      assert result.mwst_type == :included
      assert result.mwst_is_net? == true
      assert result.compact_view? == false
      assert result.show_position_taxes? == false
      assert result.valid_from == ~D[2019-06-24]
      assert result.valid_to == ~D[2019-07-24]
      assert result.delivery_address_type == :contact_address
      assert result.kb_item_status_id == 22
      assert result.terms_of_payment_text == "Payable within 30 days"
      assert result.reference == "Based on Quote Q-3860"
      assert result.api_reference == nil
      assert result.mail == "support@bexio.com"
      assert result.viewed_by_client_at == ~D[2020-07-24]
      assert result.valid_until == ~D[2019-07-24]
      assert result.created_at == ~U[2020-04-28T19:58:58Z]
      assert result.updated_at == ~U[2020-04-30T19:58:58Z]
      assert result.custom_translations == %{}
      assert result.date_format == "d.m.Y"
      # positions are only returned by the create/update responses
      assert result.positions == nil
    end
  end

  describe "fetching a single purchase order" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/purchase_orders/1"} = conn ->
          json(conn, @purchase_order_response)

        %{method: "GET", request_path: "/3.0/purchase_orders/2"} = conn ->
          send_resp(conn, 404, "Purchase order with specified id was not found")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.Purchase.fetch_purchase_order(client, 1)

      assert result.id == 1
      assert result.document_nr == "RE-00001"
      assert result.mwst_type == :included
      assert result.positions["required"] != []
      assert result.positions["discount"] != []

      assert [discount_position] = result.positions["discount"]
      assert discount_position["type"] == "discount"
      assert discount_position["is_percentual"] == true
      assert discount_position["value"] == 10
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Purchase order with specified id was not found"} =
               BexioApiClient.Purchase.fetch_purchase_order(client, 2)
    end
  end

  describe "creating a purchase order" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/3.0/purchase_orders"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["document_nr"] == "RE-00001"
          assert body_json["contact_id"] == 14
          assert body_json["user_id"] == 1
          assert body_json["mwst_type"] == "included"
          assert body_json["mwst_is_net"] == true
          assert body_json["is_valid_from"] == "2019-06-24"
          assert body_json["nb_decimals_amount"] == 2

          # nil fields are not sent
          refute Map.has_key?(body_json, "title")
          refute Map.has_key?(body_json, "logopaper_id")
          refute Map.has_key?(body_json, "api_reference")

          json(conn, @purchase_order_response)
      end)

      :ok
    end

    test "creates a new record" do
      client = BexioApiClient.new("123")

      purchase_order =
        BexioApiClient.Purchase.PurchaseOrder.new(%{
          document_nr: "RE-00001",
          contact_id: 14,
          user_id: 1,
          mwst_type: :included,
          mwst_is_net?: true,
          valid_from: ~D[2019-06-24]
        })

      {:ok, _record} = BexioApiClient.Purchase.create_purchase_order(client, purchase_order)
    end
  end

  describe "editing a purchase order" do
    setup do
      mock_request(fn
        %{method: "PUT", request_path: "/3.0/purchase_orders/1"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["id"] == 1
          assert body_json["document_nr"] == "RE-00001"
          assert body_json["contact_id"] == 14

          json(conn, @purchase_order_response)
      end)

      :ok
    end

    test "edits the record" do
      client = BexioApiClient.new("123")

      purchase_order =
        BexioApiClient.Purchase.PurchaseOrder.new(%{
          id: 1,
          document_nr: "RE-00001",
          contact_id: 14,
          user_id: 1
        })

      {:ok, _record} = BexioApiClient.Purchase.edit_purchase_order(client, 1, purchase_order)
    end
  end

  describe "deleting a purchase order" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/3.0/purchase_orders/1"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the record" do
      client = BexioApiClient.new("123")

      assert {:ok, true} = BexioApiClient.Purchase.delete_purchase_order(client, 1)
    end
  end

  describe "fetching a list of outgoing payments" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/4.0/purchase/outgoing-payments"} = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["bill_id"] == "176a1442-d66d-4907-b8c8-6dad090452a8"

          json(conn, %{
            "data" => [
              %{
                "id" => "46913fdc-802b-49ba-99d7-4ccc13cccfc2",
                "bill_id" => "176a1442-d66d-4907-b8c8-6dad090452a8",
                "payment_type" => "MANUAL",
                "execution_date" => "2019-10-15",
                "status" => "TRANSFERRED",
                "amount" => 45.98,
                "sender_bank_account_id" => 4,
                "receiver_account_no" => "657858734587301523",
                "receiver_iban" => "DE121234567812345678900",
                "banking_payment_id" => "0c8b18af-9a66-4c89-b01a-8abab642d69a",
                "transaction_id" => "f020b371-939e-427a-8175-eceb8dea17b3"
              },
              %{
                "id" => "176a1442-d66d-4907-b8c8-6dad090452a8",
                "bill_id" => "869f16ee-d688-476b-9f18-9bb608fdc21f",
                "payment_type" => "IBAN",
                "status" => "PENDING",
                "execution_date" => "2019-09-25",
                "amount" => 95.2,
                "sender_bank_account_id" => 96,
                "receiver_account_no" => "253458734587301523",
                "receiver_iban" => "ES121234567812345678900",
                "banking_payment_id" => "f7e53b5e-a496-4bce-94b5-97f739dc4d5b",
                "transaction_id" => "b3bafed8-fe0f-414d-b360-b50734fb199c"
              }
            ],
            "paging" => %{
              "page" => 1,
              "page_size" => 10,
              "page_count" => 50,
              "item_count" => 300
            }
          })
      end)

      :ok
    end

    test "shows valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, {[result1, result2], paging}} =
               BexioApiClient.Purchase.fetch_outgoing_payments(
                 client,
                 "176a1442-d66d-4907-b8c8-6dad090452a8"
               )

      assert paging.page == 1
      assert paging.page_size == 10
      assert paging.page_count == 50
      assert paging.item_count == 300

      assert result1.id == "46913fdc-802b-49ba-99d7-4ccc13cccfc2"
      assert result1.bill_id == "176a1442-d66d-4907-b8c8-6dad090452a8"
      assert result1.payment_type == :manual
      assert result1.execution_date == ~D[2019-10-15]
      assert result1.status == :transferred
      assert result1.amount == 45.98
      assert result1.sender_bank_account_id == 4
      # deprecated by bexio, still returned in the list response
      assert result1.receiver_account_no == "657858734587301523"
      assert result1.receiver_iban == "DE121234567812345678900"
      assert result1.banking_payment_id == "0c8b18af-9a66-4c89-b01a-8abab642d69a"
      assert result1.transaction_id == "f020b371-939e-427a-8175-eceb8dea17b3"

      assert result2.payment_type == :iban
      assert result2.status == :pending
      assert result2.amount == 95.2
      # fields of the single-payment response are nil in the list response
      assert result2.currency_code == nil
      assert result2.fee_type == nil
      assert result2.salary_payment? == nil
    end
  end

  describe "fetching a single outgoing payment" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/4.0/purchase/outgoing-payments/f68e87e0-fa2d-4576-91c6-15f7b6876003"
        } =
            conn ->
          json(conn, @outgoing_payment_response)

        %{method: "GET", request_path: "/4.0/purchase/outgoing-payments/unknown"} = conn ->
          send_resp(conn, 404, "Outgoing Payment with specified id was not found")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      {:ok, result} =
        BexioApiClient.Purchase.fetch_outgoing_payment(
          client,
          "f68e87e0-fa2d-4576-91c6-15f7b6876003"
        )

      assert result.id == "f68e87e0-fa2d-4576-91c6-15f7b6876003"
      assert result.status == :downloaded
      assert result.created_at == ~U[2019-06-27T08:25:50Z]
      assert result.bill_id == "22c306ad-c158-4792-b557-72340df816f5"
      assert result.payment_type == :iban
      assert result.execution_date == ~D[2019-10-15]
      assert result.amount == 45.98
      assert result.currency_code == "CHF"
      assert result.exchange_rate == 1.0000000032
      assert result.note == "Some notes"
      assert result.sender_bank_account_id == 2
      assert result.sender_iban == "DE684734567812345678900"
      assert result.sender_name == "Sender name"
      assert result.sender_house_no == "45"
      assert result.sender_city == "Warsaw"
      assert result.sender_country_code == "PL"
      assert result.receiver_iban == "CH121234567812345678900"
      assert result.receiver_name == "Receiver name"
      assert result.receiver_country_code == "CH"
      assert result.fee_type == :breakdown
      assert result.salary_payment? == false
      assert result.reference_no == "9568345675321984798456"
      assert result.message == "Some message"
      assert result.booking_text == "Swimming lessons"
      assert result.banking_payment_id == "f35d39a3-dfc4-43d1-bf38-387f821c0ed0"
      assert result.banking_payment_entry_id == "27c0d66a-8ea2-4b51-9ce0-372d3e0a4117"
      assert result.transaction_id == "b4f1e277-8424-48a7-a0b0-100646e82d25"
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Outgoing Payment with specified id was not found"} =
               BexioApiClient.Purchase.fetch_outgoing_payment(client, "unknown")
    end
  end

  describe "creating an outgoing payment" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/4.0/purchase/outgoing-payments"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["bill_id"] == "13e24b2d-355a-424f-9c80-f457c7ddd555"
          assert body_json["payment_type"] == "IBAN"
          assert body_json["execution_date"] == "2020-11-13"
          assert body_json["amount"] == 78.64
          assert body_json["currency_code"] == "EUR"
          assert body_json["exchange_rate"] == 1.211
          assert body_json["is_salary_payment"] == true
          assert body_json["fee_type"] == "BY_SENDER"
          assert body_json["sender_bank_account_id"] == 2
          assert body_json["sender_iban"] == "CH5604835012345678009"
          assert body_json["sender_name"] == "Muster Hans"
          assert body_json["receiver_iban"] == "DE91100000000123456789"
          assert body_json["receiver_name"] == "bexio ag"
          assert body_json["receiver_country_code"] == "CH"

          # nil fields are not sent
          refute Map.has_key?(body_json, "note")
          refute Map.has_key?(body_json, "receiver_account_no")
          refute Map.has_key?(body_json, "booking_text")

          json(conn, @outgoing_payment_response)
      end)

      :ok
    end

    test "creates a new record" do
      client = BexioApiClient.new("123")

      outgoing_payment =
        BexioApiClient.Purchase.OutgoingPayment.new(%{
          bill_id: "13e24b2d-355a-424f-9c80-f457c7ddd555",
          payment_type: :iban,
          execution_date: ~D[2020-11-13],
          amount: 78.64,
          currency_code: "EUR",
          exchange_rate: 1.211,
          salary_payment?: true,
          fee_type: :by_sender,
          sender_bank_account_id: 2,
          sender_iban: "CH5604835012345678009",
          sender_name: "Muster Hans",
          sender_city: "London",
          sender_postcode: "6723",
          sender_street: "address no 2",
          receiver_iban: "DE91100000000123456789",
          receiver_name: "bexio ag",
          receiver_street: "Reinluftweg 1",
          receiver_city: "Wattwil",
          receiver_postcode: "9630",
          receiver_country_code: "CH"
        })

      {:ok, _record} = BexioApiClient.Purchase.create_outgoing_payment(client, outgoing_payment)
    end
  end

  describe "editing an outgoing payment" do
    setup do
      mock_request(fn
        %{method: "PUT", request_path: "/4.0/purchase/outgoing-payments"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["payment_id"] == "1701eb40-d4ea-4617-a8e0-e40e68cbc1d8"
          assert body_json["execution_date"] == "2025-06-12"
          assert body_json["amount"] == 100
          assert body_json["fee_type"] == "BY_SENDER"
          assert body_json["is_salary_payment"] == false
          assert body_json["receiver_iban"] == "NL40INGB5940297536"
          assert body_json["receiver_name"] == "Vare Back"
          assert body_json["receiver_country_code"] == "CH"

          # nil fields are not sent
          refute Map.has_key?(body_json, "reference_no")
          refute Map.has_key?(body_json, "message")

          json(conn, @outgoing_payment_response)
      end)

      :ok
    end

    test "edits the record" do
      client = BexioApiClient.new("123")

      outgoing_payment =
        BexioApiClient.Purchase.OutgoingPayment.new(%{
          id: "1701eb40-d4ea-4617-a8e0-e40e68cbc1d8",
          execution_date: ~D[2025-06-12],
          amount: 100,
          fee_type: :by_sender,
          salary_payment?: false,
          receiver_iban: "NL40INGB5940297536",
          receiver_name: "Vare Back",
          receiver_street: "Kniestrasse",
          receiver_house_no: "1437223",
          receiver_city: "Jona",
          receiver_postcode: "8645",
          receiver_country_code: "CH"
        })

      {:ok, _record} = BexioApiClient.Purchase.edit_outgoing_payment(client, outgoing_payment)
    end
  end

  describe "deleting an outgoing payment" do
    setup do
      mock_request(fn
        %{
          method: "DELETE",
          request_path: "/4.0/purchase/outgoing-payments/f68e87e0-fa2d-4576-91c6-15f7b6876003"
        } =
            conn ->
          send_resp(conn, 204, "")
      end)

      :ok
    end

    test "deletes the record" do
      client = BexioApiClient.new("123")

      assert {:ok, true} =
               BexioApiClient.Purchase.delete_outgoing_payment(
                 client,
                 "f68e87e0-fa2d-4576-91c6-15f7b6876003"
               )
    end
  end
end
