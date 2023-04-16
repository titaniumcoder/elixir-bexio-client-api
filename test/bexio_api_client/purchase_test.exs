defmodule BexioApiClient.PurchaseTest do
  use ExUnit.Case, async: true
  doctest BexioApiClient.Contacts

  import Tesla.Mock

  describe "fetching a list of bills" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/4.0/purchase/bills"} ->
          json(%{
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
end
