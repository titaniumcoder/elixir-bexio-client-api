defmodule BexioApiClient.SalesOrderManagementTest do
  use TestHelper

  use ExUnit.Case, async: true

  doctest BexioApiClient.Contacts

  alias BexioApiClient.SalesOrderManagement.{
    PositionDiscount,
    PositionItem,
    PositionSubtotal,
    PositionPagebreak,
    PositionText,
    PositionDefault,
    Quote,
    Order,
    Invoice
  }

  alias BexioApiClient.SearchCriteria

  describe "fetching a list of quotes" do
    setup do
      mock_request(fn conn ->
        json(conn, [
          %{
            "id" => 4,
            "document_nr" => "AN-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "project_id" => nil,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "payment_type_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "show_position_taxes" => false,
            "is_valid_from" => "2019-06-24",
            "is_valid_until" => "2019-07-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "delivery_address_type" => 0,
            "delivery_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 3,
            "api_reference" => nil,
            "viewed_by_client_at" => nil,
            "kb_terms_of_payment_template_id" => nil,
            "show_total" => true,
            "updated_at" => "2019-04-08 13:17:32",
            "template_slug" => "581a8010821e01426b8b456b",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ],
            "network_link" => ""
          }
        ])
      end)

      :ok
    end

    test "shows valid records" do
      client = BexioApiClient.new("123")

      {:ok, [record]} = BexioApiClient.SalesOrderManagement.fetch_quotes(client)

      assert record.id == 4
      assert record.document_nr == "AN-00001"
      assert record.title == nil
      assert record.contact_id == 14
      assert record.contact_sub_id == nil
      assert record.user_id == 1
      assert record.project_id == nil
      assert record.language_id == 1
      assert record.bank_account_id == 1
      assert record.currency_id == 1
      assert record.payment_type_id == 1

      assert record.header ==
               "Thank you very much for your inquiry. We would be pleased to make you the following offer:"

      assert record.footer ==
               "We hope that our offer meets your expectations and will be happy to answer your questions."

      assert Decimal.equal?(record.total_gross, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_net, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_taxes, Decimal.new("1.3706"))
      assert Decimal.equal?(record.total, Decimal.new("19.15"))
      assert record.total_rounding_difference == -0.02
      assert record.mwst_type == :including
      assert record.mwst_is_net? == true
      assert record.show_position_taxes? == false
      assert record.is_valid_from == ~D[2019-06-24]
      assert record.is_valid_until == ~D[2019-07-24]
      assert record.contact_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.delivery_address_type == 0
      assert record.delivery_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.kb_item_status == :confirmed
      assert record.api_reference == nil
      assert record.viewed_by_client_at == nil
      assert record.kb_terms_of_payment_template_id == nil
      assert record.show_total? == true
      assert record.updated_at == ~N[2019-04-08 13:17:32]
      assert record.template_slug == "581a8010821e01426b8b456b"
      assert record.network_link == ""
      assert Decimal.equal?(hd(record.taxs).percentage, Decimal.new("7.7"))
      assert Decimal.equal?(hd(record.taxs).value, Decimal.new("1.3706"))
    end
  end

  describe "searching quotes" do
    setup do
      mock_request(fn conn ->
        json(conn, [
          %{
            "id" => 4,
            "document_nr" => "AN-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "project_id" => nil,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "payment_type_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "show_position_taxes" => false,
            "is_valid_from" => "2019-06-24",
            "is_valid_until" => "2019-07-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "delivery_address_type" => 0,
            "delivery_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 3,
            "api_reference" => nil,
            "viewed_by_client_at" => nil,
            "kb_terms_of_payment_template_id" => nil,
            "show_total" => true,
            "updated_at" => "2019-04-08 13:17:32",
            "template_slug" => "581a8010821e01426b8b456b",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ],
            "network_link" => ""
          }
        ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      {:ok, [record]} =
        BexioApiClient.SalesOrderManagement.search_quotes(
          client,
          [
            SearchCriteria.equal(:id, 4)
          ],
          limit: 100,
          offset: 50,
          order_by: :id
        )

      assert record.id == 4
      assert record.document_nr == "AN-00001"
      assert record.title == nil
      assert record.contact_id == 14
      assert record.contact_sub_id == nil
      assert record.user_id == 1
      assert record.project_id == nil
      assert record.language_id == 1
      assert record.bank_account_id == 1
      assert record.currency_id == 1
      assert record.payment_type_id == 1

      assert record.header ==
               "Thank you very much for your inquiry. We would be pleased to make you the following offer:"

      assert record.footer ==
               "We hope that our offer meets your expectations and will be happy to answer your questions."

      assert Decimal.equal?(record.total_gross, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_net, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_taxes, Decimal.new("1.3706"))
      assert Decimal.equal?(record.total, Decimal.new("19.15"))
      assert record.total_rounding_difference == -0.02
      assert record.mwst_type == :including
      assert record.mwst_is_net? == true
      assert record.show_position_taxes? == false
      assert record.is_valid_from == ~D[2019-06-24]
      assert record.is_valid_until == ~D[2019-07-24]
      assert record.contact_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.delivery_address_type == 0
      assert record.delivery_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.kb_item_status == :confirmed
      assert record.api_reference == nil
      assert record.viewed_by_client_at == nil
      assert record.kb_terms_of_payment_template_id == nil
      assert record.show_total? == true
      assert record.updated_at == ~N[2019-04-08 13:17:32]
      assert record.template_slug == "581a8010821e01426b8b456b"
      assert record.network_link == ""
      assert Decimal.equal?(hd(record.taxs).percentage, Decimal.new("7.7"))
      assert Decimal.equal?(hd(record.taxs).value, Decimal.new("1.3706"))
    end
  end

  describe "fetching a single quote" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_offer/1"} = conn ->
          json(conn, %{
            "id" => 4,
            "document_nr" => "AN-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "project_id" => nil,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "payment_type_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "show_position_taxes" => false,
            "is_valid_from" => "2019-06-24",
            "is_valid_until" => "2019-07-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "delivery_address_type" => 0,
            "delivery_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 3,
            "api_reference" => nil,
            "viewed_by_client_at" => nil,
            "kb_terms_of_payment_template_id" => nil,
            "show_total" => true,
            "updated_at" => "2019-04-08 13:17:32",
            "template_slug" => "581a8010821e01426b8b456b",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ],
            "network_link" => ""
          })

        %{method: "GET", request_path: "/2.0/kb_offer/99"} = conn ->
          send_resp(conn, 404, "Offer does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      {:ok, record} = BexioApiClient.SalesOrderManagement.fetch_quote(client, 1)

      assert record.id == 4
      assert record.document_nr == "AN-00001"
      assert record.title == nil
      assert record.contact_id == 14
      assert record.contact_sub_id == nil
      assert record.user_id == 1
      assert record.project_id == nil
      assert record.language_id == 1
      assert record.bank_account_id == 1
      assert record.currency_id == 1
      assert record.payment_type_id == 1

      assert record.header ==
               "Thank you very much for your inquiry. We would be pleased to make you the following offer:"

      assert record.footer ==
               "We hope that our offer meets your expectations and will be happy to answer your questions."

      assert Decimal.equal?(record.total_gross, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_net, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_taxes, Decimal.new("1.3706"))
      assert Decimal.equal?(record.total, Decimal.new("19.15"))
      assert record.total_rounding_difference == -0.02
      assert record.mwst_type == :including
      assert record.mwst_is_net? == true
      assert record.show_position_taxes? == false
      assert record.is_valid_from == ~D[2019-06-24]
      assert record.is_valid_until == ~D[2019-07-24]
      assert record.contact_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.delivery_address_type == 0
      assert record.delivery_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.kb_item_status == :confirmed
      assert record.api_reference == nil
      assert record.viewed_by_client_at == nil
      assert record.kb_terms_of_payment_template_id == nil
      assert record.show_total? == true
      assert record.updated_at == ~N[2019-04-08 13:17:32]
      assert record.template_slug == "581a8010821e01426b8b456b"
      assert record.network_link == ""
      assert Decimal.equal?(hd(record.taxs).percentage, Decimal.new("7.7"))
      assert Decimal.equal?(hd(record.taxs).value, Decimal.new("1.3706"))
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Offer does not exist"} =
               BexioApiClient.SalesOrderManagement.fetch_quote(client, 99)
    end
  end

  describe "creating a quote" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/kb_offer"} = conn ->
          {:ok, body, _} = read_body(conn)
          json_body = Jason.decode!(body)

          assert json_body["contact_id"] == 14
          assert json_body["pr_project_id"] == 3
          assert json_body["mwst_is_net"] == true
          assert json_body["show_position_taxes"] == false
          assert json_body["is_valid_from"] == "2019-06-24"
          assert json_body["is_valid_until"] == "2019-07-24"
          assert json_body["mwst_type"] == 0
          assert Enum.at(json_body["positions"], 0)["type"] == "KbPositionCustom"
          assert Enum.at(json_body["positions"], 1)["type"] == "KbPositionArticle"
          assert Enum.at(json_body["positions"], 2)["type"] == "KbPositionText"
          assert Enum.at(json_body["positions"], 3)["type"] == "KbPositionPagebreak"
          assert Enum.at(json_body["positions"], 4)["type"] == "KbPositionSubtotal"
          assert Enum.at(json_body["positions"], 5)["type"] == "KbPositionDiscount"

          json(conn, %{
            "id" => 4,
            "document_nr" => "AN-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "project_id" => nil,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "payment_type_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "show_position_taxes" => false,
            "is_valid_from" => "2019-06-24",
            "is_valid_until" => "2019-07-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "delivery_address_type" => 0,
            "delivery_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 3,
            "api_reference" => nil,
            "viewed_by_client_at" => nil,
            "kb_terms_of_payment_template_id" => nil,
            "show_total" => true,
            "updated_at" => "2019-04-08 13:17:32",
            "template_slug" => "581a8010821e01426b8b456b",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ],
            "network_link" => ""
          })
      end)

      :ok
    end

    test "creates a new record" do
      client = BexioApiClient.new("123")

      {:ok, _record} =
        BexioApiClient.SalesOrderManagement.create_quote(
          client,
          Quote.new(%{
            document_nr: "AN-00004",
            contact_id: 14,
            is_valid_from: ~D[2019-06-24],
            is_valid_until: ~D[2019-07-24],
            project_id: 3,
            mwst_type: :including,
            user_id: 1,
            language_id: 1,
            bank_account_id: 1,
            currency_id: 1,
            payment_type_id: 1,
            header: "Header",
            footer: "Footer",
            mwst_is_net?: true,
            show_position_taxes?: false,
            contact_address: "",
            delivery_address_type: 0,
            delivery_address: "",
            show_total?: true,
            positions: [
              PositionDefault.new(),
              PositionItem.new(),
              PositionText.new(),
              PositionPagebreak.new(),
              PositionSubtotal.new(),
              PositionDiscount.new()
            ]
          })
        )
    end
  end

  describe "editing a quote" do
    setup do
      mock_request(fn %{method: "POST", request_path: "/2.0/kb_offer/4"} = conn ->
        {:ok, body, _} = read_body(conn)
        json_body = Jason.decode!(body)

        assert json_body["contact_id"] == 14
        assert json_body["pr_project_id"] == 3
        assert json_body["mwst_is_net"] == true
        assert json_body["show_position_taxes"] == false
        assert json_body["is_valid_from"] == "2019-06-24"
        assert json_body["is_valid_until"] == "2019-07-24"
        assert json_body["mwst_type"] == 0

        json(conn, %{
          "id" => 4,
          "document_nr" => "AN-00001",
          "title" => nil,
          "contact_id" => 14,
          "contact_sub_id" => nil,
          "user_id" => 1,
          "project_id" => nil,
          "logopaper_id" => 1,
          "language_id" => 1,
          "bank_account_id" => 1,
          "currency_id" => 1,
          "payment_type_id" => 1,
          "header" =>
            "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
          "footer" =>
            "We hope that our offer meets your expectations and will be happy to answer your questions.",
          "total_gross" => "17.800000",
          "total_net" => "17.800000",
          "total_taxes" => "1.3706",
          "total" => "19.150000",
          "total_rounding_difference" => -0.02,
          "mwst_type" => 0,
          "mwst_is_net" => true,
          "show_position_taxes" => false,
          "is_valid_from" => "2019-06-24",
          "is_valid_until" => "2019-07-24",
          "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
          "delivery_address_type" => 0,
          "delivery_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
          "kb_item_status_id" => 3,
          "api_reference" => nil,
          "viewed_by_client_at" => nil,
          "kb_terms_of_payment_template_id" => nil,
          "show_total" => true,
          "updated_at" => "2019-04-08 13:17:32",
          "template_slug" => "581a8010821e01426b8b456b",
          "taxs" => [
            %{
              "percentage" => "7.70",
              "value" => "1.3706"
            }
          ],
          "network_link" => ""
        })
      end)

      :ok
    end

    test "edits a new record" do
      client = BexioApiClient.new("123")

      {:ok, _record} =
        BexioApiClient.SalesOrderManagement.edit_quote(
          client,
          Quote.new(%{
            id: 4,
            document_nr: "AN-00004",
            contact_id: 14,
            is_valid_from: ~D[2019-06-24],
            is_valid_until: ~D[2019-07-24],
            project_id: 3,
            mwst_type: :including,
            user_id: 1,
            language_id: 1,
            bank_account_id: 1,
            currency_id: 1,
            payment_type_id: 1,
            header: "Header",
            footer: "Footer",
            mwst_is_net?: true,
            show_position_taxes?: false,
            contact_address: "",
            delivery_address_type: 0,
            delivery_address: "",
            show_total?: true,
            positions: [
              PositionDefault.new(),
              PositionItem.new(),
              PositionText.new(),
              PositionPagebreak.new(),
              PositionSubtotal.new(),
              PositionDiscount.new()
            ]
          })
        )
    end
  end

  describe "deleting a quote" do
    setup do
      mock_request(fn %{method: "DELETE", request_path: "/2.0/kb_offer/4"} = conn ->
        json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the record" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.delete_quote(client, 4)
      assert result == true
    end
  end

  describe "issueing a quote" do
    setup do
      mock_request(fn %{method: "POST", request_path: "/2.0/kb_offer/4/issue"} = conn ->
        json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.issue_quote(client, 4)
      assert result == true
    end
  end

  describe "revert issueing a quote" do
    setup do
      mock_request(fn %{method: "POST", request_path: "/2.0/kb_offer/4/revertIssue"} = conn ->
        json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.revert_issue_quote(client, 4)
      assert result == true
    end
  end

  describe "accepting a quote" do
    setup do
      mock_request(fn %{method: "POST", request_path: "/2.0/kb_offer/4/accept"} = conn ->
        json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.accept_quote(client, 4)
      assert result == true
    end
  end

  describe "declining a quote" do
    setup do
      mock_request(fn %{method: "POST", request_path: "/2.0/kb_offer/4/reject"} = conn ->
        json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.decline_quote(client, 4)
      assert result == true
    end
  end

  describe "reissuing a quote" do
    setup do
      mock_request(fn %{method: "POST", request_path: "/2.0/kb_offer/4/reissue"} = conn ->
        json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.reissue_quote(client, 4)
      assert result == true
    end
  end

  describe "marking quote as sent" do
    setup do
      mock_request(fn %{method: "POST", request_path: "/2.0/kb_offer/4/mark_as_sent"} = conn ->
        json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.mark_quote_as_sent(client, 4)
      assert result == true
    end
  end

  describe "showing pdf" do
    setup do
      mock_request(fn %{method: "GET", request_path: "/2.0/kb_offer/4/pdf"} = conn ->
        json(conn, %{
          "name" => "document-00005.pdf",
          "size" => 9768,
          "mime" => "application/pdf",
          "content" => "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
        })
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.quote_pdf(client, 4)
      assert result.name == "document-00005.pdf"
      assert result.size == 9768
      assert result.mime == "application/pdf"
      assert result.content == "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
    end
  end

  describe "fetching a list of orders" do
    setup do
      mock_request(fn %{method: "GET", request_path: "/2.0/kb_order"} = conn ->
        json(conn, [
          %{
            "id" => 4,
            "document_nr" => "O-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "project_id" => nil,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "payment_type_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "show_position_taxes" => false,
            "is_valid_from" => "2019-06-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "delivery_address_type" => 0,
            "delivery_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 6,
            "api_reference" => nil,
            "viewed_by_client_at" => nil,
            "is_recurring" => false,
            "updated_at" => "2019-04-08 13:17:32",
            "template_slug" => "581a8010821e01426b8b456b",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ],
            "network_link" => ""
          }
        ])
      end)

      :ok
    end

    test "shows valid records" do
      client = BexioApiClient.new("123")

      assert {:ok, [record]} = BexioApiClient.SalesOrderManagement.fetch_orders(client)

      assert record.id == 4
      assert record.document_nr == "O-00001"
      assert record.title == nil
      assert record.contact_id == 14
      assert record.contact_sub_id == nil
      assert record.user_id == 1
      assert record.project_id == nil
      assert record.language_id == 1
      assert record.bank_account_id == 1
      assert record.currency_id == 1
      assert record.payment_type_id == 1

      assert record.header ==
               "Thank you very much for your inquiry. We would be pleased to make you the following offer:"

      assert record.footer ==
               "We hope that our offer meets your expectations and will be happy to answer your questions."

      assert Decimal.equal?(record.total_gross, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_net, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_taxes, Decimal.new("1.3706"))
      assert Decimal.equal?(record.total, Decimal.new("19.15"))
      assert record.total_rounding_difference == -0.02
      assert record.mwst_type == :including
      assert record.mwst_is_net? == true
      assert record.show_position_taxes? == false
      assert record.is_valid_from == ~D[2019-06-24]
      assert record.contact_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.delivery_address_type == 0
      assert record.delivery_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.kb_item_status == :done
      assert record.api_reference == nil
      assert record.viewed_by_client_at == nil
      assert record.is_recurring? == false
      assert record.updated_at == ~N[2019-04-08 13:17:32]
      assert record.template_slug == "581a8010821e01426b8b456b"
      assert record.network_link == ""
      assert Decimal.equal?(hd(record.taxs).percentage, Decimal.new("7.7"))
      assert Decimal.equal?(hd(record.taxs).value, Decimal.new("1.3706"))
    end
  end

  describe "searching orders" do
    setup do
      mock_request(fn %{method: "POST", request_path: "/2.0/kb_order/search"} = conn ->
        json(conn, [
          %{
            "id" => 4,
            "document_nr" => "O-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "project_id" => nil,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "payment_type_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "show_position_taxes" => false,
            "is_valid_from" => "2019-06-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "delivery_address_type" => 0,
            "delivery_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 6,
            "api_reference" => nil,
            "viewed_by_client_at" => nil,
            "is_recurring" => false,
            "updated_at" => "2019-04-08 13:17:32",
            "template_slug" => "581a8010821e01426b8b456b",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ],
            "network_link" => ""
          }
        ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      assert {:ok, [record]} =
               BexioApiClient.SalesOrderManagement.search_orders(
                 client,
                 [
                   SearchCriteria.equal(:id, 4)
                 ],
                 limit: 100,
                 offset: 50,
                 order_by: :id
               )

      assert record.id == 4
      assert record.document_nr == "O-00001"
      assert record.title == nil
      assert record.contact_id == 14
      assert record.contact_sub_id == nil
      assert record.user_id == 1
      assert record.project_id == nil
      assert record.language_id == 1
      assert record.bank_account_id == 1
      assert record.currency_id == 1
      assert record.payment_type_id == 1

      assert record.header ==
               "Thank you very much for your inquiry. We would be pleased to make you the following offer:"

      assert record.footer ==
               "We hope that our offer meets your expectations and will be happy to answer your questions."

      assert Decimal.equal?(record.total_gross, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_net, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_taxes, Decimal.new("1.3706"))
      assert Decimal.equal?(record.total, Decimal.new("19.15"))
      assert record.total_rounding_difference == -0.02
      assert record.mwst_type == :including
      assert record.mwst_is_net? == true
      assert record.show_position_taxes? == false
      assert record.is_valid_from == ~D[2019-06-24]
      assert record.contact_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.delivery_address_type == 0
      assert record.delivery_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.kb_item_status == :done
      assert record.api_reference == nil
      assert record.viewed_by_client_at == nil
      assert record.is_recurring? == false
      assert record.updated_at == ~N[2019-04-08 13:17:32]
      assert record.template_slug == "581a8010821e01426b8b456b"
      assert record.network_link == ""
      assert Decimal.equal?(hd(record.taxs).percentage, Decimal.new("7.7"))
      assert Decimal.equal?(hd(record.taxs).value, Decimal.new("1.3706"))
    end
  end

  describe "fetching a single order" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_order/4"} = conn ->
          json(conn, %{
            "id" => 4,
            "document_nr" => "O-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "project_id" => nil,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "payment_type_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "show_position_taxes" => false,
            "is_valid_from" => "2019-06-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "delivery_address_type" => 0,
            "delivery_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 6,
            "api_reference" => nil,
            "viewed_by_client_at" => nil,
            "is_recurring" => false,
            "updated_at" => "2019-04-08 13:17:32",
            "template_slug" => "581a8010821e01426b8b456b",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ],
            "network_link" => ""
          })

        %{method: "GET", request_path: "/2.0/kb_order/99"} = conn ->
          send_resp(conn, 404, "Order does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, record} = BexioApiClient.SalesOrderManagement.fetch_order(client, 4)
      assert record.id == 4
      assert record.document_nr == "O-00001"
      assert record.title == nil
      assert record.contact_id == 14
      assert record.contact_sub_id == nil
      assert record.user_id == 1
      assert record.project_id == nil
      assert record.language_id == 1
      assert record.bank_account_id == 1
      assert record.currency_id == 1
      assert record.payment_type_id == 1

      assert record.header ==
               "Thank you very much for your inquiry. We would be pleased to make you the following offer:"

      assert record.footer ==
               "We hope that our offer meets your expectations and will be happy to answer your questions."

      assert Decimal.equal?(record.total_gross, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_net, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_taxes, Decimal.new("1.3706"))
      assert Decimal.equal?(record.total, Decimal.new("19.15"))
      assert record.total_rounding_difference == -0.02
      assert record.mwst_type == :including
      assert record.mwst_is_net? == true
      assert record.show_position_taxes? == false
      assert record.is_valid_from == ~D[2019-06-24]
      assert record.contact_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.delivery_address_type == 0
      assert record.delivery_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.kb_item_status == :done
      assert record.api_reference == nil
      assert record.viewed_by_client_at == nil
      assert record.is_recurring? == false
      assert record.updated_at == ~N[2019-04-08 13:17:32]
      assert record.template_slug == "581a8010821e01426b8b456b"
      assert record.network_link == ""
      assert Decimal.equal?(hd(record.taxs).percentage, Decimal.new("7.7"))
      assert Decimal.equal?(hd(record.taxs).value, Decimal.new("1.3706"))
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Order does not exist"} =
               BexioApiClient.SalesOrderManagement.fetch_order(client, 99)
    end
  end

  describe "creating an order" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/kb_order"} = conn ->
          {:ok, body, _} = read_body(conn)
          json_body = Jason.decode!(body)

          assert json_body["contact_id"] == 14
          assert json_body["pr_project_id"] == 3
          assert json_body["mwst_is_net"] == true
          assert json_body["show_position_taxes"] == false
          assert json_body["is_valid_from"] == "2019-06-24"
          assert json_body["mwst_type"] == 0
          assert Enum.at(json_body["positions"], 0)["type"] == "KbPositionCustom"
          assert Enum.at(json_body["positions"], 1)["type"] == "KbPositionArticle"
          assert Enum.at(json_body["positions"], 2)["type"] == "KbPositionText"
          assert Enum.at(json_body["positions"], 3)["type"] == "KbPositionPagebreak"
          assert Enum.at(json_body["positions"], 4)["type"] == "KbPositionSubtotal"
          assert Enum.at(json_body["positions"], 5)["type"] == "KbPositionDiscount"

          json(conn, %{
            "id" => 4,
            "document_nr" => "O-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "project_id" => nil,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "payment_type_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "show_position_taxes" => false,
            "is_valid_from" => "2019-06-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "delivery_address_type" => 0,
            "delivery_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 6,
            "api_reference" => nil,
            "viewed_by_client_at" => nil,
            "is_recurring" => false,
            "updated_at" => "2019-04-08 13:17:32",
            "template_slug" => "581a8010821e01426b8b456b",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ],
            "network_link" => ""
          })
      end)

      :ok
    end

    test "creates a new record" do
      client = BexioApiClient.new("123")

      {:ok, _record} =
        BexioApiClient.SalesOrderManagement.create_order(
          client,
          Order.new(%{
            document_nr: "AN-00004",
            contact_id: 14,
            is_valid_from: ~D[2019-06-24],
            project_id: 3,
            mwst_type: :including,
            user_id: 1,
            language_id: 1,
            bank_account_id: 1,
            currency_id: 1,
            payment_type_id: 1,
            header: "Header",
            footer: "Footer",
            mwst_is_net?: true,
            show_position_taxes?: false,
            contact_address: "",
            delivery_address_type: 0,
            delivery_address: "",
            show_total?: true,
            positions: [
              PositionDefault.new(),
              PositionItem.new(),
              PositionText.new(),
              PositionPagebreak.new(),
              PositionSubtotal.new(),
              PositionDiscount.new()
            ]
          })
        )
    end
  end

  describe "editing an order" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/kb_order/4"} = conn ->
          {:ok, body, _} = read_body(conn)
          json_body = Jason.decode!(body)

          assert json_body["contact_id"] == 14
          assert json_body["pr_project_id"] == 3
          assert json_body["mwst_is_net"] == true
          assert json_body["show_position_taxes"] == false
          assert json_body["is_valid_from"] == "2019-06-24"
          assert json_body["mwst_type"] == 0

          json(conn, %{
            "id" => 4,
            "document_nr" => "O-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "project_id" => nil,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "payment_type_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "show_position_taxes" => false,
            "is_valid_from" => "2019-06-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "delivery_address_type" => 0,
            "delivery_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 6,
            "api_reference" => nil,
            "viewed_by_client_at" => nil,
            "is_recurring" => false,
            "updated_at" => "2019-04-08 13:17:32",
            "template_slug" => "581a8010821e01426b8b456b",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ],
            "network_link" => ""
          })
      end)

      :ok
    end

    test "edits a new record" do
      client = BexioApiClient.new("123")

      {:ok, _record} =
        BexioApiClient.SalesOrderManagement.edit_order(
          client,
          Order.new(%{
            id: 4,
            document_nr: "AN-00004",
            contact_id: 14,
            is_valid_from: ~D[2019-06-24],
            project_id: 3,
            mwst_type: :including,
            user_id: 1,
            language_id: 1,
            bank_account_id: 1,
            currency_id: 1,
            payment_type_id: 1,
            header: "Header",
            footer: "Footer",
            mwst_is_net?: true,
            show_position_taxes?: false,
            contact_address: "",
            delivery_address_type: 0,
            delivery_address: "",
            show_total?: true,
            positions: [
              PositionDefault.new(),
              PositionItem.new(),
              PositionText.new(),
              PositionPagebreak.new(),
              PositionSubtotal.new(),
              PositionDiscount.new()
            ]
          })
        )
    end
  end

  describe "deleting an order" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/kb_order/4"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the record" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.delete_order(client, 4)
      assert result == true
    end
  end

  describe "showing order pdf" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_order/4/pdf"} = conn ->
          json(conn, %{
            "name" => "document-00005.pdf",
            "size" => 9768,
            "mime" => "application/pdf",
            "content" => "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
          })
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.order_pdf(client, 4)
      assert result.name == "document-00005.pdf"
      assert result.size == 9768
      assert result.mime == "application/pdf"
      assert result.content == "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
    end
  end

  describe "fetching a list of deliveries" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_delivery"} = conn ->
          json(conn, [
            %{
              "api_reference" => nil,
              "bank_account_id" => 1,
              "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
              "contact_id" => 14,
              "contact_sub_id" => nil,
              "currency_id" => 1,
              "delivery_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
              "delivery_address_type" => 0,
              "document_nr" => "O-00001",
              "header" => nil,
              "footer" => nil,
              "id" => 4,
              "is_valid_from" => "2019-06-24",
              "kb_item_status_id" => 18,
              "language_id" => 1,
              "logopaper_id" => 1,
              "mwst_is_net" => true,
              "mwst_type" => 0,
              "taxs" => [
                %{
                  "percentage" => "7.70",
                  "value" => "1.3706"
                }
              ],
              "title" => nil,
              "total" => "19.150000",
              "total_gross" => "17.800000",
              "total_net" => "17.800000",
              "total_rounding_difference" => -0.02,
              "total_taxes" => "1.3706",
              "updated_at" => "2019-04-08 13:17:32",
              "user_id" => 1,
              "viewed_by_client_at" => nil
            }
          ])
      end)

      :ok
    end

    test "shows valid records" do
      client = BexioApiClient.new("123")

      assert {:ok, [record]} = BexioApiClient.SalesOrderManagement.fetch_deliveries(client)

      assert record.id == 4
      assert record.document_nr == "O-00001"
      assert record.title == nil
      assert record.contact_id == 14
      assert record.contact_sub_id == nil
      assert record.user_id == 1
      assert record.language_id == 1
      assert record.bank_account_id == 1
      assert record.currency_id == 1

      assert record.header == nil
      assert record.footer == nil

      assert Decimal.equal?(record.total_gross, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_net, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_taxes, Decimal.new("1.3706"))
      assert Decimal.equal?(record.total, Decimal.new("19.15"))
      assert record.total_rounding_difference == -0.02
      assert record.mwst_type == :including
      assert record.mwst_is_net? == true
      assert record.is_valid_from == ~D[2019-06-24]
      assert record.contact_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.delivery_address_type == 0
      assert record.delivery_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.kb_item_status == :done
      assert record.api_reference == nil
      assert record.updated_at == ~N[2019-04-08 13:17:32]
      assert Decimal.equal?(hd(record.taxs).percentage, Decimal.new("7.7"))
      assert Decimal.equal?(hd(record.taxs).value, Decimal.new("1.3706"))
    end
  end

  describe "fetching a single delivery" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_delivery/4"} = conn ->
          json(conn, %{
            "id" => 4,
            "document_nr" => "O-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "is_valid_from" => "2019-06-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "delivery_address_type" => 0,
            "delivery_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 18,
            "api_reference" => nil,
            "updated_at" => "2019-04-08 13:17:32",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ]
          })

        %{method: "GET", request_path: "/2.0/kb_delivery/99"} = conn ->
          send_resp(conn, 404, "Delivery does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, record} = BexioApiClient.SalesOrderManagement.fetch_delivery(client, 4)
      assert record.id == 4
      assert record.document_nr == "O-00001"
      assert record.title == nil
      assert record.contact_id == 14
      assert record.contact_sub_id == nil
      assert record.user_id == 1
      assert record.language_id == 1
      assert record.bank_account_id == 1
      assert record.currency_id == 1

      assert record.header ==
               "Thank you very much for your inquiry. We would be pleased to make you the following offer:"

      assert record.footer ==
               "We hope that our offer meets your expectations and will be happy to answer your questions."

      assert Decimal.equal?(record.total_gross, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_net, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_taxes, Decimal.new("1.3706"))
      assert Decimal.equal?(record.total, Decimal.new("19.15"))
      assert record.total_rounding_difference == -0.02
      assert record.mwst_type == :including
      assert record.mwst_is_net? == true
      assert record.is_valid_from == ~D[2019-06-24]
      assert record.contact_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.delivery_address_type == 0
      assert record.delivery_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.kb_item_status == :done
      assert record.api_reference == nil
      assert record.updated_at == ~N[2019-04-08 13:17:32]
      assert Decimal.equal?(hd(record.taxs).percentage, Decimal.new("7.7"))
      assert Decimal.equal?(hd(record.taxs).value, Decimal.new("1.3706"))
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Delivery does not exist"} =
               BexioApiClient.SalesOrderManagement.fetch_delivery(client, 99)
    end
  end

  describe "issuing a delivery" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/kb_delivery/4/issue"} = conn ->
          json(conn, %{
            "success" => true
          })
      end)

      :ok
    end

    test "is successful" do
      client = BexioApiClient.new("123")

      {:ok, success} =
        BexioApiClient.SalesOrderManagement.issue_delivery(
          client,
          4
        )

      assert success == true
    end
  end

  describe "fetching a list of invoices" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice"} = conn ->
          json(conn, [
            %{
              "id" => 4,
              "document_nr" => "RE-00001",
              "title" => nil,
              "contact_id" => 14,
              "contact_sub_id" => nil,
              "user_id" => 1,
              "project_id" => nil,
              "logopaper_id" => 1,
              "language_id" => 1,
              "bank_account_id" => 1,
              "currency_id" => 1,
              "payment_type_id" => 1,
              "header" =>
                "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
              "footer" =>
                "We hope that our offer meets your expectations and will be happy to answer your questions.",
              "total_gross" => "17.800000",
              "total_net" => "17.800000",
              "total_taxes" => "1.3706",
              "total_received_payments" => "0.000000",
              "total_credit_vouchers" => "0.000000",
              "total_remaining_payments" => "19.150000",
              "total" => "19.150000",
              "total_rounding_difference" => -0.02,
              "mwst_type" => 0,
              "mwst_is_net" => true,
              "show_position_taxes" => false,
              "is_valid_from" => "2019-06-24",
              "is_valid_to" => "2019-07-24",
              "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
              "kb_item_status_id" => 7,
              "reference" => nil,
              "api_reference" => nil,
              "viewed_by_client_at" => nil,
              "updated_at" => "2019-04-08 13:17:32",
              "esr_id" => 1,
              "qr_invoice_id" => 1,
              "template_slug" => "581a8010821e01426b8b456b",
              "taxs" => [
                %{
                  "percentage" => "7.70",
                  "value" => "1.3706"
                }
              ],
              "network_link" => ""
            }
          ])
      end)

      :ok
    end

    test "shows valid records" do
      client = BexioApiClient.new("123")

      {:ok, [record]} = BexioApiClient.SalesOrderManagement.fetch_invoices(client)

      assert record.id == 4
      assert record.document_nr == "RE-00001"
      assert record.title == nil
      assert record.contact_id == 14
      assert record.contact_sub_id == nil
      assert record.user_id == 1
      assert record.project_id == nil
      assert record.language_id == 1
      assert record.bank_account_id == 1
      assert record.currency_id == 1
      assert record.payment_type_id == 1

      assert record.header ==
               "Thank you very much for your inquiry. We would be pleased to make you the following offer:"

      assert record.footer ==
               "We hope that our offer meets your expectations and will be happy to answer your questions."

      assert Decimal.equal?(record.total_gross, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_net, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_taxes, Decimal.new("1.3706"))
      assert Decimal.equal?(record.total, Decimal.new("19.15"))
      assert record.total_rounding_difference == -0.02
      assert record.mwst_type == :including
      assert record.mwst_is_net? == true
      assert record.show_position_taxes? == false
      assert record.is_valid_from == ~D[2019-06-24]
      assert record.is_valid_to == ~D[2019-07-24]
      assert record.contact_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.kb_item_status == :draft
      assert record.api_reference == nil
      assert record.viewed_by_client_at == nil
      assert record.updated_at == ~N[2019-04-08 13:17:32]
      assert record.template_slug == "581a8010821e01426b8b456b"
      assert record.network_link == ""
      assert Decimal.equal?(hd(record.taxs).percentage, Decimal.new("7.7"))
      assert Decimal.equal?(hd(record.taxs).value, Decimal.new("1.3706"))
    end
  end

  describe "searching invoices" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/search"
        } = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["limit"] == "100"
          assert conn.query_params["offset"] == "50"
          assert conn.query_params["order_by"] == "id"

          json(conn, [
            %{
              "id" => 4,
              "document_nr" => "RE-00001",
              "title" => nil,
              "contact_id" => 14,
              "contact_sub_id" => nil,
              "user_id" => 1,
              "project_id" => nil,
              "logopaper_id" => 1,
              "language_id" => 1,
              "bank_account_id" => 1,
              "currency_id" => 1,
              "payment_type_id" => 1,
              "header" =>
                "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
              "footer" =>
                "We hope that our offer meets your expectations and will be happy to answer your questions.",
              "total_gross" => "17.800000",
              "total_net" => "17.800000",
              "total_taxes" => "1.3706",
              "total_received_payments" => "0.000000",
              "total_credit_vouchers" => "0.000000",
              "total_remaining_payments" => "19.150000",
              "total" => "19.150000",
              "total_rounding_difference" => -0.02,
              "mwst_type" => 0,
              "mwst_is_net" => true,
              "show_position_taxes" => false,
              "is_valid_from" => "2019-06-24",
              "is_valid_to" => "2019-07-24",
              "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
              "kb_item_status_id" => 7,
              "reference" => nil,
              "api_reference" => nil,
              "viewed_by_client_at" => nil,
              "updated_at" => "2019-04-08 13:17:32",
              "esr_id" => 1,
              "qr_invoice_id" => 1,
              "template_slug" => "581a8010821e01426b8b456b",
              "taxs" => [
                %{
                  "percentage" => "7.70",
                  "value" => "1.3706"
                }
              ],
              "network_link" => ""
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      {:ok, [record]} =
        BexioApiClient.SalesOrderManagement.search_invoices(
          client,
          [
            SearchCriteria.equal(:id, 4)
          ],
          limit: 100,
          offset: 50,
          order_by: :id
        )

      assert record.id == 4
      assert record.document_nr == "RE-00001"
      assert record.title == nil
      assert record.contact_id == 14
      assert record.contact_sub_id == nil
      assert record.user_id == 1
      assert record.project_id == nil
      assert record.language_id == 1
      assert record.bank_account_id == 1
      assert record.currency_id == 1
      assert record.payment_type_id == 1

      assert record.header ==
               "Thank you very much for your inquiry. We would be pleased to make you the following offer:"

      assert record.footer ==
               "We hope that our offer meets your expectations and will be happy to answer your questions."

      assert Decimal.equal?(record.total_gross, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_net, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_taxes, Decimal.new("1.3706"))
      assert Decimal.equal?(record.total, Decimal.new("19.15"))
      assert record.total_rounding_difference == -0.02
      assert record.mwst_type == :including
      assert record.mwst_is_net? == true
      assert record.show_position_taxes? == false
      assert record.is_valid_from == ~D[2019-06-24]
      assert record.is_valid_to == ~D[2019-07-24]
      assert record.contact_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.kb_item_status == :draft
      assert record.api_reference == nil
      assert record.viewed_by_client_at == nil
      assert record.updated_at == ~N[2019-04-08 13:17:32]
      assert record.template_slug == "581a8010821e01426b8b456b"
      assert record.network_link == ""
      assert Decimal.equal?(hd(record.taxs).percentage, Decimal.new("7.7"))
      assert Decimal.equal?(hd(record.taxs).value, Decimal.new("1.3706"))
    end
  end

  describe "fetching a single invoice" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1"} = conn ->
          json(conn, %{
            "id" => 4,
            "document_nr" => "RE-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "project_id" => nil,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "payment_type_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total_received_payments" => "0.000000",
            "total_credit_vouchers" => "0.000000",
            "total_remaining_payments" => "19.150000",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "show_position_taxes" => false,
            "is_valid_from" => "2019-06-24",
            "is_valid_to" => "2019-07-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 7,
            "reference" => nil,
            "api_reference" => nil,
            "viewed_by_client_at" => nil,
            "updated_at" => "2019-04-08 13:17:32",
            "esr_id" => 1,
            "qr_invoice_id" => 1,
            "template_slug" => "581a8010821e01426b8b456b",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ],
            "network_link" => "",
            "positions" => [
              %{
                "id" => 1,
                "amount" => "5.000000",
                "unit_id" => 1,
                "account_id" => 1,
                "unit_name" => "kg",
                "tax_id" => 4,
                "tax_value" => "7.70",
                "text" => "Apples",
                "unit_price" => "3.560000",
                "discount_in_percent" => "0.000000",
                "position_total" => "17.800000",
                "pos" => 1,
                "internal_pos" => 1,
                "is_optional" => false,
                "type" => "KbPositionCustom",
                "parent_id" => nil
              }
            ]
          })

        %{method: "GET", request_path: "/2.0/kb_invoice/99"} = conn ->
          send_resp(conn, 404, "Invoice does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      {:ok, record} = BexioApiClient.SalesOrderManagement.fetch_invoice(client, 1)

      assert record.id == 4
      assert record.document_nr == "RE-00001"
      assert record.title == nil
      assert record.contact_id == 14
      assert record.contact_sub_id == nil
      assert record.user_id == 1
      assert record.project_id == nil
      assert record.language_id == 1
      assert record.bank_account_id == 1
      assert record.currency_id == 1
      assert record.payment_type_id == 1

      assert record.header ==
               "Thank you very much for your inquiry. We would be pleased to make you the following offer:"

      assert record.footer ==
               "We hope that our offer meets your expectations and will be happy to answer your questions."

      assert Decimal.equal?(record.total_gross, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_net, Decimal.new("17.8"))
      assert Decimal.equal?(record.total_taxes, Decimal.new("1.3706"))
      assert Decimal.equal?(record.total, Decimal.new("19.15"))
      assert record.total_rounding_difference == -0.02
      assert record.mwst_type == :including
      assert record.mwst_is_net? == true
      assert record.show_position_taxes? == false
      assert record.is_valid_from == ~D[2019-06-24]
      assert record.is_valid_to == ~D[2019-07-24]
      assert record.contact_address == "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden"
      assert record.kb_item_status == :draft
      assert record.api_reference == nil
      assert record.viewed_by_client_at == nil
      assert record.updated_at == ~N[2019-04-08 13:17:32]
      assert record.template_slug == "581a8010821e01426b8b456b"
      assert record.network_link == ""
      assert Decimal.equal?(hd(record.taxs).percentage, Decimal.new("7.7"))
      assert Decimal.equal?(hd(record.taxs).value, Decimal.new("1.3706"))
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Invoice does not exist"} =
               BexioApiClient.SalesOrderManagement.fetch_invoice(client, 99)
    end
  end

  describe "creating an invoice" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/kb_invoice"} = conn ->
          {:ok, body, _} = read_body(conn)
          json_body = Jason.decode!(body)

          assert json_body["contact_id"] == 14
          assert json_body["pr_project_id"] == 3
          assert json_body["mwst_is_net"] == true
          assert json_body["show_position_taxes"] == false
          assert json_body["is_valid_from"] == "2019-06-24"
          assert json_body["mwst_type"] == 0
          assert Enum.at(json_body["positions"], 0)["type"] == "KbPositionCustom"
          assert Enum.at(json_body["positions"], 1)["type"] == "KbPositionArticle"
          assert Enum.at(json_body["positions"], 2)["type"] == "KbPositionText"
          assert Enum.at(json_body["positions"], 3)["type"] == "KbPositionPagebreak"
          assert Enum.at(json_body["positions"], 4)["type"] == "KbPositionSubtotal"
          assert Enum.at(json_body["positions"], 5)["type"] == "KbPositionDiscount"

          json(conn, %{
            "id" => 4,
            "document_nr" => "RE-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "project_id" => nil,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "payment_type_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total_received_payments" => "0.000000",
            "total_credit_vouchers" => "0.000000",
            "total_remaining_payments" => "19.150000",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "show_position_taxes" => false,
            "is_valid_from" => "2019-06-24",
            "is_valid_to" => "2019-07-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 7,
            "reference" => nil,
            "api_reference" => nil,
            "viewed_by_client_at" => nil,
            "updated_at" => "2019-04-08 13:17:32",
            "esr_id" => 1,
            "qr_invoice_id" => 1,
            "template_slug" => "581a8010821e01426b8b456b",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ],
            "network_link" => "",
            "positions" => [
              %{
                "id" => 1,
                "amount" => "5.000000",
                "unit_id" => 1,
                "account_id" => 1,
                "unit_name" => "kg",
                "tax_id" => 4,
                "tax_value" => "7.70",
                "text" => "Apples",
                "unit_price" => "3.560000",
                "discount_in_percent" => "0.000000",
                "position_total" => "17.800000",
                "pos" => 1,
                "internal_pos" => 1,
                "is_optional" => false,
                "type" => "KbPositionCustom",
                "parent_id" => nil
              }
            ]
          })
      end)

      :ok
    end

    test "creates a new record" do
      client = BexioApiClient.new("123")

      {:ok, _record} =
        BexioApiClient.SalesOrderManagement.create_invoice(
          client,
          Invoice.new(%{
            document_nr: "RE-00004",
            contact_id: 14,
            is_valid_from: ~D[2019-06-24],
            is_valid_until: ~D[2019-07-24],
            project_id: 3,
            mwst_type: :including,
            user_id: 1,
            language_id: 1,
            bank_account_id: 1,
            currency_id: 1,
            payment_type_id: 1,
            header: "Header",
            footer: "Footer",
            mwst_is_net?: true,
            show_position_taxes?: false,
            contact_address: "",
            delivery_address_type: 0,
            delivery_address: "",
            show_total?: true,
            positions: [
              PositionDefault.new(),
              PositionItem.new(),
              PositionText.new(),
              PositionPagebreak.new(),
              PositionSubtotal.new(),
              PositionDiscount.new()
            ]
          })
        )
    end
  end

  describe "editing an invoice" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/kb_invoice/4"} = conn ->
          {:ok, body, _} = read_body(conn)
          json_body = Jason.decode!(body)

          assert json_body["contact_id"] == 14
          assert json_body["pr_project_id"] == 3
          assert json_body["mwst_is_net"] == true
          assert json_body["show_position_taxes"] == false
          assert json_body["is_valid_from"] == "2019-06-24"
          assert json_body["mwst_type"] == 0

          json(conn, %{
            "id" => 4,
            "document_nr" => "RE-00001",
            "title" => nil,
            "contact_id" => 14,
            "contact_sub_id" => nil,
            "user_id" => 1,
            "project_id" => nil,
            "logopaper_id" => 1,
            "language_id" => 1,
            "bank_account_id" => 1,
            "currency_id" => 1,
            "payment_type_id" => 1,
            "header" =>
              "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
            "footer" =>
              "We hope that our offer meets your expectations and will be happy to answer your questions.",
            "total_gross" => "17.800000",
            "total_net" => "17.800000",
            "total_taxes" => "1.3706",
            "total_received_payments" => "0.000000",
            "total_credit_vouchers" => "0.000000",
            "total_remaining_payments" => "19.150000",
            "total" => "19.150000",
            "total_rounding_difference" => -0.02,
            "mwst_type" => 0,
            "mwst_is_net" => true,
            "show_position_taxes" => false,
            "is_valid_from" => "2019-06-24",
            "is_valid_to" => "2019-07-24",
            "contact_address" => "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
            "kb_item_status_id" => 7,
            "reference" => nil,
            "api_reference" => nil,
            "viewed_by_client_at" => nil,
            "updated_at" => "2019-04-08 13:17:32",
            "esr_id" => 1,
            "qr_invoice_id" => 1,
            "template_slug" => "581a8010821e01426b8b456b",
            "taxs" => [
              %{
                "percentage" => "7.70",
                "value" => "1.3706"
              }
            ],
            "network_link" => "",
            "positions" => [
              %{
                "id" => 1,
                "amount" => "5.000000",
                "unit_id" => 1,
                "account_id" => 1,
                "unit_name" => "kg",
                "tax_id" => 4,
                "tax_value" => "7.70",
                "text" => "Apples",
                "unit_price" => "3.560000",
                "discount_in_percent" => "0.000000",
                "position_total" => "17.800000",
                "pos" => 1,
                "internal_pos" => 1,
                "is_optional" => false,
                "type" => "KbPositionCustom",
                "parent_id" => nil
              }
            ]
          })
      end)

      :ok
    end

    test "edits a new record" do
      client = BexioApiClient.new("123")

      {:ok, _record} =
        BexioApiClient.SalesOrderManagement.edit_invoice(
          client,
          Invoice.new(%{
            id: 4,
            document_nr: "RE-00004",
            contact_id: 14,
            is_valid_from: ~D[2019-06-24],
            is_valid_until: ~D[2019-07-24],
            project_id: 3,
            mwst_type: :including,
            user_id: 1,
            language_id: 1,
            bank_account_id: 1,
            currency_id: 1,
            payment_type_id: 1,
            header: "Header",
            footer: "Footer",
            mwst_is_net?: true,
            show_position_taxes?: false,
            contact_address: "",
            delivery_address_type: 0,
            delivery_address: "",
            show_total?: true,
            positions: [
              PositionDefault.new(),
              PositionItem.new(),
              PositionText.new(),
              PositionPagebreak.new(),
              PositionSubtotal.new(),
              PositionDiscount.new()
            ]
          })
        )
    end
  end

  describe "deleting an invoice" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/kb_invoice/4"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the record" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.delete_invoice(client, 4)
      assert result == true
    end
  end

  describe "issueing an invoice" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/kb_invoice/4/issue"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.issue_invoice(client, 4)
      assert result == true
    end
  end

  describe "revert issueing an invoice" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/kb_invoice/4/revert_issue"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.revert_issue_invoice(client, 4)
      assert result == true
    end
  end

  describe "showing invoice pdf" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/4/pdf"} = conn ->
          json(conn, %{
            "name" => "document-00005.pdf",
            "size" => 9768,
            "mime" => "application/pdf",
            "content" => "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
          })
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.SalesOrderManagement.invoice_pdf(client, 4)
      assert result.name == "document-00005.pdf"
      assert result.size == 9768
      assert result.mime == "application/pdf"
      assert result.content == "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
    end
  end

  describe "fetching a list of document settings" do
    setup do
      json = Jason.decode! """
      [
        {
          "id": 1,
          "text": "Quote",
          "kb_item_class": "KbOffer",
          "enumeration_format": "AN-%nummer%",
          "use_automatic_enumeration": true,
          "use_yearly_enumeration": false,
          "next_nr": 1,
          "nr_min_length": 5,
          "default_time_period_in_days": 14,
          "default_logopaper_id": 1,
          "default_language_id": 1,
          "default_client_bank_account_new_id": 1,
          "default_currency_id": 1,
          "default_mwst_type": 0,
          "default_mwst_is_net": true,
          "default_nb_decimals_amount": 2,
          "default_nb_decimals_price": 2,
          "default_show_position_taxes": false,
          "default_title": "Angebot",
          "default_show_esr_on_same_page": false,
          "default_payment_type_id": 1,
          "kb_terms_of_payment_template_id": 1,
          "default_show_total": true
        }
      ]
      """

      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_item_setting"} = conn ->
          json(conn, json)
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.SalesOrderManagement.fetch_document_settings(client)

      assert result.id == 1
      assert result.text == "Quote"
      assert result.kb_item_class == :KbOffer

      # TODO add remaining test comparison
    end
  end

  describe "fetching a list of comments" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/comment"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "text" => "Comment",
              "user_id" => 1,
              "user_email" => nil,
              "user_name" => "Peter Smith",
              "date" => "2019-07-18 15:41:53",
              "is_public" => false,
              "image" => "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=",
              "image_path" =>
                "https://my.bexio.com/img/profile_picture/j2cbWl-yp3zT9oOh9jHTAA/Ds8buEV0HXZsvuBm3df8SQ.png?type=thumb"
            }
          ])
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, [position]} =
               BexioApiClient.SalesOrderManagement.fetch_comments(client, :invoice, 1)

      assert position.id == 1
      assert position.text == "Comment"
      assert position.user_id == 1
      assert position.user_email == nil
      assert position.user_name == "Peter Smith"
      assert position.date == ~N[2019-07-18 15:41:53]
      assert position.public? == false
      assert position.image == "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="

      assert position.image_path ==
               "https://my.bexio.com/img/profile_picture/j2cbWl-yp3zT9oOh9jHTAA/Ds8buEV0HXZsvuBm3df8SQ.png?type=thumb"
    end
  end

  describe "fetching a single comment" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/comment/2"} = conn ->
          json(conn, %{
            "id" => 1,
            "text" => "Comment",
            "user_id" => 1,
            "user_email" => nil,
            "user_name" => "Peter Smith",
            "date" => "2019-07-18 15:41:53",
            "is_public" => false,
            "image" => "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=",
            "image_path" =>
              "https://my.bexio.com/img/profile_picture/j2cbWl-yp3zT9oOh9jHTAA/Ds8buEV0HXZsvuBm3df8SQ.png?type=thumb"
          })

        %{method: "GET", request_path: "/2.0/kb_invoice/1/comment/3"} = conn ->
          send_resp(conn, 404, "Invoice Comment does not exist")
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, position} =
               BexioApiClient.SalesOrderManagement.fetch_comment(client, :invoice, 1, 2)

      assert position.id == 1
      assert position.text == "Comment"
      assert position.user_id == 1
      assert position.user_email == nil
      assert position.user_name == "Peter Smith"
      assert position.date == ~N[2019-07-18 15:41:53]
      assert position.public? == false
      assert position.image == "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="

      assert position.image_path ==
               "https://my.bexio.com/img/profile_picture/j2cbWl-yp3zT9oOh9jHTAA/Ds8buEV0HXZsvuBm3df8SQ.png?type=thumb"
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Invoice Comment does not exist"} =
               BexioApiClient.SalesOrderManagement.fetch_comment(client, :invoice, 1, 3)
    end
  end

  describe "creates a comment" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/kb_invoice/1/comment"} = conn ->
          json(conn, %{
            "id" => 1,
            "text" => "Sample comment",
            "user_id" => 1,
            "user_email" => nil,
            "user_name" => "Peter Smith",
            "date" => "2019-07-18 15:41:53",
            "is_public" => false,
            "image" => "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=",
            "image_path" =>
              "https://my.bexio.com/img/profile_picture/j2cbWl-yp3zT9oOh9jHTAA/Ds8buEV0HXZsvuBm3df8SQ.png?type=thumb"
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, position} =
               BexioApiClient.SalesOrderManagement.create_comment(client, :invoice, 1, %{
                 text: "Sample comment",
                 user_id: 1,
                 user_email: nil,
                 user_name: "Peter Smith",
                 public?: false
               })

      assert position.id == 1
      assert position.text == "Sample comment"
      assert position.user_id == 1
      assert position.user_email == nil
      assert position.user_name == "Peter Smith"
      assert position.date == ~N[2019-07-18 15:41:53]
      assert position.public? == false
      assert position.image == "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="

      assert position.image_path ==
               "https://my.bexio.com/img/profile_picture/j2cbWl-yp3zT9oOh9jHTAA/Ds8buEV0HXZsvuBm3df8SQ.png?type=thumb"
    end
  end

  describe "fetching a list of subtotal positions" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_subtotal"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "text" => "Subtotal",
              "value" => "17.800000",
              "internal_pos" => 1,
              "is_optional" => false,
              "type" => "KbPositionSubtotal",
              "parent_id" => nil
            }
          ])
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, [position]} =
               BexioApiClient.SalesOrderManagement.fetch_subtotal_positions(client, :invoice, 1)

      assert position.id == 1
      assert position.text == "Subtotal"
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.parent_id == nil
      assert Decimal.equal?(position.value, Decimal.new("17.8"))
    end
  end

  describe "fetching a single subtotal position" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_subtotal/2"} = conn ->
          json(conn, %{
            "id" => 1,
            "text" => "Subtotal",
            "value" => "17.800000",
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionSubtotal",
            "parent_id" => nil
          })

        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_subtotal/3"} = conn ->
          send_resp(conn, 404, "Subtotal Position does not exist")
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, position} =
               BexioApiClient.SalesOrderManagement.fetch_subtotal_position(client, :invoice, 1, 2)

      assert position.id == 1
      assert position.text == "Subtotal"
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.parent_id == nil
      assert Decimal.equal?(position.value, Decimal.new("17.8"))
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Subtotal Position does not exist"} =
               BexioApiClient.SalesOrderManagement.fetch_subtotal_position(client, :invoice, 1, 3)
    end
  end

  describe "creating a subtotal position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_subtotal"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          assert body == "{\"text\":\"text\"}"

          json(conn, %{
            "id" => 1,
            "text" => "Subtotal",
            "value" => "17.800000",
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionSubtotal",
            "parent_id" => nil
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.create_subtotal_position(
                 client,
                 :invoice,
                 1,
                 "text"
               )
    end
  end

  describe "editing a subtotal position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_subtotal/2"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          assert body == "{\"text\":\"text\"}"

          json(conn, %{
            "id" => 1,
            "text" => "Subtotal",
            "value" => "17.800000",
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionSubtotal",
            "parent_id" => nil
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.edit_subtotal_position(
                 client,
                 :invoice,
                 1,
                 2,
                 "text"
               )
    end
  end

  describe "deleting a subtotal position" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/kb_invoice/1/kb_position_subtotal/2"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} =
        BexioApiClient.SalesOrderManagement.delete_subtotal_position(client, :invoice, 1, 2)

      assert result == true
    end
  end

  describe "fetching a list of text positions" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_text"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "text" => "Text Sample",
              "internal_pos" => 1,
              "show_pos_nr" => true,
              "pos" => nil,
              "is_optional" => false,
              "type" => "KbPositionText",
              "parent_id" => nil
            }
          ])
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, [position]} =
               BexioApiClient.SalesOrderManagement.fetch_text_positions(client, :invoice, 1)

      assert position.id == 1
      assert position.text == "Text Sample"
      assert position.show_pos_nr? == true
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.parent_id == nil
    end
  end

  describe "fetching a single text position" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_text/2"} = conn ->
          json(conn, %{
            "id" => 1,
            "text" => "Text Sample",
            "internal_pos" => 1,
            "show_pos_nr" => true,
            "pos" => nil,
            "is_optional" => false,
            "type" => "KbPositionText",
            "parent_id" => nil
          })

        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_text/3"} = conn ->
          send_resp(conn, 404, "Text Position does not exist")
      end)

      :ok
    end

    test "shows valid positions" do
      client = BexioApiClient.new("123")

      assert {:ok, position} =
               BexioApiClient.SalesOrderManagement.fetch_text_position(client, :invoice, 1, 2)

      assert position.id == 1
      assert position.text == "Text Sample"
      assert position.show_pos_nr? == true
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.parent_id == nil
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Text Position does not exist"} =
               BexioApiClient.SalesOrderManagement.fetch_text_position(client, :invoice, 1, 3)
    end
  end

  describe "creating a text position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_text"
        } = conn ->
          json(conn, %{
            "id" => 1,
            "text" => "Text Sample",
            "internal_pos" => 1,
            "show_pos_nr" => true,
            "pos" => nil,
            "is_optional" => false,
            "type" => "KbPositionText",
            "parent_id" => nil
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.create_text_position(
                 client,
                 :invoice,
                 1,
                 "Container",
                 true
               )
    end
  end

  describe "editing a text position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_text/2"
        } = conn ->
          json(conn, %{
            "id" => 1,
            "text" => "Text Sample",
            "internal_pos" => 1,
            "show_pos_nr" => true,
            "pos" => nil,
            "is_optional" => false,
            "type" => "KbPositionText",
            "parent_id" => nil
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.edit_text_position(
                 client,
                 :invoice,
                 1,
                 2,
                 "Container",
                 true
               )
    end
  end

  describe "deleting a text position" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/kb_invoice/1/kb_position_text/2"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} =
        BexioApiClient.SalesOrderManagement.delete_text_position(client, :invoice, 1, 2)

      assert result == true
    end
  end

  describe "fetching a list of default positions" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_custom"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "amount" => "5.000000",
              "unit_id" => 1,
              "account_id" => 1,
              "unit_name" => "kg",
              "tax_id" => 4,
              "tax_value" => "7.70",
              "text" => "Apples",
              "unit_price" => "3.560000",
              "discount_in_percent" => "0.000000",
              "position_total" => "17.800000",
              "pos" => 1,
              "internal_pos" => 1,
              "is_optional" => false,
              "type" => "KbPositionCustom",
              "parent_id" => nil
            }
          ])
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, [position]} =
               BexioApiClient.SalesOrderManagement.fetch_default_positions(client, :invoice, 1)

      assert position.id == 1
      assert Decimal.equal?(position.amount, Decimal.from_float(5.0))
      assert position.unit_id == 1
      assert position.account_id == 1
      assert position.unit_name == "kg"
      assert position.tax_id == 4
      assert Decimal.equal?(position.tax_value, Decimal.from_float(7.7))
      assert position.text == "Apples"
      assert Decimal.equal?(position.unit_price, Decimal.from_float(3.56))
      assert Decimal.equal?(position.position_total, Decimal.from_float(17.8))
      assert position.pos == 1
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.parent_id == nil
    end
  end

  describe "fetching a single default position" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_custom/2"} = conn ->
          json(conn, %{
            "id" => 1,
            "amount" => "5.000000",
            "unit_id" => 1,
            "account_id" => 1,
            "unit_name" => "kg",
            "tax_id" => 4,
            "tax_value" => "7.70",
            "text" => "Apples",
            "unit_price" => "3.560000",
            "discount_in_percent" => "0.000000",
            "position_total" => "17.800000",
            "pos" => 1,
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionCustom",
            "parent_id" => nil
          })

        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_custom/3"} = conn ->
          send_resp(conn, 404, "Default Position does not exist")
      end)

      :ok
    end

    test "shows valid positions" do
      client = BexioApiClient.new("123")

      assert {:ok, position} =
               BexioApiClient.SalesOrderManagement.fetch_default_position(client, :invoice, 1, 2)

      assert position.id == 1
      assert Decimal.equal?(position.amount, Decimal.from_float(5.0))
      assert position.unit_id == 1
      assert position.account_id == 1
      assert position.unit_name == "kg"
      assert position.tax_id == 4
      assert Decimal.equal?(position.tax_value, Decimal.from_float(7.7))
      assert position.text == "Apples"
      assert Decimal.equal?(position.unit_price, Decimal.from_float(3.56))
      assert Decimal.equal?(position.position_total, Decimal.from_float(17.8))
      assert position.pos == 1
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.parent_id == nil
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Default Position does not exist"} =
               BexioApiClient.SalesOrderManagement.fetch_default_position(client, :invoice, 1, 3)
    end
  end

  describe "creating a default position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_custom"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          json_body = Jason.decode!(body)

          assert json_body["amount"] != nil
          assert json_body["unit_id"] != nil
          assert json_body["account_id"] != nil
          assert json_body["tax_id"] != nil
          assert json_body["text"] != nil
          assert json_body["unit_price"] != nil
          assert json_body["discount_in_percent"] != nil

          json(conn, %{
            "id" => 1,
            "amount" => "5.000000",
            "unit_id" => 1,
            "account_id" => 1,
            "unit_name" => "kg",
            "tax_id" => 4,
            "tax_value" => "7.70",
            "text" => "Apples",
            "unit_price" => "3.560000",
            "discount_in_percent" => "0.000000",
            "position_total" => "17.800000",
            "pos" => 1,
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionCustom",
            "parent_id" => nil
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.create_default_position(
                 client,
                 :invoice,
                 1,
                 PositionDefault.new(%{
                   id: 2,
                   tax_id: 4,
                   text: "Apples",
                   unit_id: 1,
                   account_id: 1
                 })
               )
    end
  end

  describe "editing a default position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_custom/2"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          json_body = Jason.decode!(body)

          assert json_body["amount"] != nil
          assert json_body["unit_id"] != nil
          assert json_body["account_id"] != nil
          assert json_body["tax_id"] != nil
          assert json_body["text"] != nil
          assert json_body["unit_price"] != nil
          assert json_body["discount_in_percent"] != nil

          json(conn, %{
            "id" => 1,
            "amount" => "5.000000",
            "unit_id" => 1,
            "account_id" => 1,
            "unit_name" => "kg",
            "tax_id" => 4,
            "tax_value" => "7.70",
            "text" => "Apples",
            "unit_price" => "3.560000",
            "discount_in_percent" => "0.000000",
            "position_total" => "17.800000",
            "pos" => 1,
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionCustom",
            "parent_id" => nil
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.edit_default_position(
                 client,
                 :invoice,
                 1,
                 PositionDefault.new(%{
                   id: 2,
                   tax_id: 4,
                   text: "Apples",
                   unit_id: 1,
                   account_id: 1
                 })
               )
    end
  end

  describe "deleting a default position" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/kb_invoice/1/kb_position_custom/2"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} =
        BexioApiClient.SalesOrderManagement.delete_default_position(client, :invoice, 1, 2)

      assert result == true
    end
  end

  describe "fetching a list of item positions" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_article"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "amount" => "5.000000",
              "unit_id" => 1,
              "account_id" => 1,
              "unit_name" => "kg",
              "tax_id" => 4,
              "tax_value" => "7.70",
              "text" => "Apples",
              "unit_price" => "3.560000",
              "discount_in_percent" => "0.000000",
              "position_total" => "17.800000",
              "pos" => 1,
              "internal_pos" => 1,
              "is_optional" => false,
              "article_id" => 3,
              "type" => "KbPositionArticle",
              "parent_id" => nil
            }
          ])
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, [position]} =
               BexioApiClient.SalesOrderManagement.fetch_item_positions(client, :invoice, 1)

      assert position.id == 1
      assert Decimal.equal?(position.amount, Decimal.from_float(5.0))
      assert position.unit_id == 1
      assert position.account_id == 1
      assert position.unit_name == "kg"
      assert position.tax_id == 4
      assert Decimal.equal?(position.tax_value, Decimal.from_float(7.7))
      assert position.text == "Apples"
      assert Decimal.equal?(position.unit_price, Decimal.from_float(3.56))
      assert Decimal.equal?(position.position_total, Decimal.from_float(17.8))
      assert position.pos == 1
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.article_id == 3
      assert position.parent_id == nil
    end
  end

  describe "fetching a single item position" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_article/2"} = conn ->
          json(conn, %{
            "id" => 1,
            "amount" => "5.000000",
            "unit_id" => 1,
            "account_id" => 1,
            "unit_name" => "kg",
            "tax_id" => 4,
            "tax_value" => "7.70",
            "text" => "Apples",
            "unit_price" => "3.560000",
            "discount_in_percent" => "0.000000",
            "position_total" => "17.800000",
            "pos" => 1,
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionArticle",
            "article_id" => 3,
            "parent_id" => nil
          })

        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_article/3"} = conn ->
          send_resp(conn, 404, "Item Position does not exist")
      end)

      :ok
    end

    test "shows valid positions" do
      client = BexioApiClient.new("123")

      assert {:ok, position} =
               BexioApiClient.SalesOrderManagement.fetch_item_position(client, :invoice, 1, 2)

      assert position.id == 1
      assert Decimal.equal?(position.amount, Decimal.from_float(5.0))
      assert position.unit_id == 1
      assert position.account_id == 1
      assert position.unit_name == "kg"
      assert position.tax_id == 4
      assert Decimal.equal?(position.tax_value, Decimal.from_float(7.7))
      assert position.text == "Apples"
      assert Decimal.equal?(position.unit_price, Decimal.from_float(3.56))
      assert Decimal.equal?(position.position_total, Decimal.from_float(17.8))
      assert position.pos == 1
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.article_id == 3
      assert position.parent_id == nil
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Item Position does not exist"} =
               BexioApiClient.SalesOrderManagement.fetch_item_position(client, :invoice, 1, 3)
    end
  end

  describe "creating an item position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_article"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          json_body = Jason.decode!(body)

          assert json_body["amount"] != nil
          assert json_body["article_id"] != nil
          assert json_body["unit_id"] != nil
          assert json_body["account_id"] != nil
          assert json_body["tax_id"] != nil
          assert json_body["text"] != nil
          assert json_body["unit_price"] != nil
          assert json_body["discount_in_percent"] != nil

          json(conn, %{
            "id" => 1,
            "amount" => "5.000000",
            "unit_id" => 1,
            "account_id" => 1,
            "unit_name" => "kg",
            "tax_id" => 4,
            "tax_value" => "7.70",
            "text" => "Apples",
            "unit_price" => "3.560000",
            "discount_in_percent" => "0.000000",
            "position_total" => "17.800000",
            "pos" => 1,
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionArticle",
            "article_id" => 3,
            "parent_id" => nil
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.create_item_position(
                 client,
                 :invoice,
                 1,
                 PositionItem.new(%{
                   id: 2,
                   tax_id: 4,
                   article_id: 1,
                   text: "Apples",
                   unit_id: 1,
                   account_id: 1
                 })
               )
    end
  end

  describe "editing an item position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_article/2"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          json_body = Jason.decode!(body)

          assert json_body["amount"] != nil
          assert json_body["article_id"] != nil
          assert json_body["unit_id"] != nil
          assert json_body["account_id"] != nil
          assert json_body["tax_id"] != nil
          assert json_body["text"] != nil
          assert json_body["unit_price"] != nil
          assert json_body["discount_in_percent"] != nil

          json(conn, %{
            "id" => 1,
            "amount" => "5.000000",
            "unit_id" => 1,
            "account_id" => 1,
            "unit_name" => "kg",
            "tax_id" => 4,
            "tax_value" => "7.70",
            "text" => "Apples",
            "unit_price" => "3.560000",
            "discount_in_percent" => "0.000000",
            "position_total" => "17.800000",
            "pos" => 1,
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionArticle",
            "article_id" => 3,
            "parent_id" => nil
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.edit_item_position(
                 client,
                 :invoice,
                 1,
                 PositionItem.new(%{
                   id: 2,
                   tax_id: 4,
                   article_id: 1,
                   text: "Apples",
                   unit_id: 1,
                   account_id: 1
                 })
               )
    end
  end

  describe "deleting an item position" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/kb_invoice/1/kb_position_article/2"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} =
        BexioApiClient.SalesOrderManagement.delete_item_position(client, :invoice, 1, 2)

      assert result == true
    end
  end

  describe "fetching a list of discount positions" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_discount"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "text" => "Partner discount",
              "is_percentual" => true,
              "value" => "10.000000",
              "discount_total" => "1.780000",
              "type" => "KbPositionDiscount"
            }
          ])
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, [position]} =
               BexioApiClient.SalesOrderManagement.fetch_discount_positions(client, :invoice, 1)

      assert position.id == 1
      assert position.text == "Partner discount"
      assert position.percentual? == true
      assert Decimal.equal?(position.value, Decimal.from_float(10.0))
      assert Decimal.equal?(position.discount_total, Decimal.from_float(1.78))
    end
  end

  describe "fetching a single discount position" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_discount/2"} = conn ->
          json(conn, %{
            "id" => 1,
            "text" => "Partner discount",
            "is_percentual" => true,
            "value" => "10.000000",
            "discount_total" => "1.780000",
            "type" => "KbPositionDiscount"
          })

        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_discount/3"} = conn ->
          send_resp(conn, 404, "Discount Position does not exist")
      end)

      :ok
    end

    test "shows valid positions" do
      client = BexioApiClient.new("123")

      assert {:ok, position} =
               BexioApiClient.SalesOrderManagement.fetch_discount_position(client, :invoice, 1, 2)

      assert position.id == 1
      assert position.text == "Partner discount"
      assert position.percentual? == true
      assert Decimal.equal?(position.value, Decimal.from_float(10.0))
      assert Decimal.equal?(position.discount_total, Decimal.from_float(1.78))
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Discount Position does not exist"} =
               BexioApiClient.SalesOrderManagement.fetch_discount_position(client, :invoice, 1, 3)
    end
  end

  describe "creating a discount position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_discount"
        } = conn ->
          json(conn, %{
            "id" => 1,
            "text" => "Partner discount",
            "is_percentual" => true,
            "value" => "10.000000",
            "discount_total" => "1.780000",
            "type" => "KbPositionDiscount"
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.create_discount_position(
                 client,
                 :invoice,
                 1,
                 PositionDiscount.new(%{
                   text: "Partner discount",
                   value: Decimal.new(10),
                   percentual?: true
                 })
               )
    end
  end

  describe "editing a discount position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_discount/2"
        } = conn ->
          json(conn, %{
            "id" => 1,
            "text" => "Partner discount",
            "is_percentual" => true,
            "value" => "10.000000",
            "discount_total" => "1.780000",
            "type" => "KbPositionDiscount"
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.edit_discount_position(
                 client,
                 :invoice,
                 1,
                 PositionDiscount.new(%{
                   id: 2,
                   text: "Partner discount",
                   value: Decimal.new(10),
                   percentual?: true
                 })
               )
    end
  end

  describe "deleting a discount position" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/kb_invoice/1/kb_position_discount/2"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} =
        BexioApiClient.SalesOrderManagement.delete_discount_position(client, :invoice, 1, 2)

      assert result == true
    end
  end

  describe "fetching a list of pagebreak positions" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_pagebreak"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "internal_pos" => 1,
              "is_optional" => false,
              "type" => "KbPositionPagebreak",
              "parent_id" => nil
            }
          ])
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, [position]} =
               BexioApiClient.SalesOrderManagement.fetch_pagebreak_positions(client, :invoice, 1)

      assert position.id == 1
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.parent_id == nil
    end
  end

  describe "fetching a single pagebreak position" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_pagebreak/2"} = conn ->
          json(conn, %{
            "id" => 1,
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionPagebreak",
            "parent_id" => nil
          })

        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_pagebreak/3"} = conn ->
          send_resp(conn, 404, "Pagebreak Position does not exist")
      end)

      :ok
    end

    test "shows valid positions" do
      client = BexioApiClient.new("123")

      assert {:ok, position} =
               BexioApiClient.SalesOrderManagement.fetch_pagebreak_position(
                 client,
                 :invoice,
                 1,
                 2
               )

      assert position.id == 1
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.parent_id == nil
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Pagebreak Position does not exist"} =
               BexioApiClient.SalesOrderManagement.fetch_pagebreak_position(
                 client,
                 :invoice,
                 1,
                 3
               )
    end
  end

  describe "creating a pagebreak position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_pagebreak"
        } = conn ->
          json(conn, %{
            "id" => 1,
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionPagebreak",
            "parent_id" => nil
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.create_pagebreak_position(
                 client,
                 :invoice,
                 1
               )
    end
  end

  describe "editing a pagebreak position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_pagebreak/2"
        } = conn ->
          json(conn, %{
            "id" => 1,
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionPagebreak",
            "parent_id" => nil
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.edit_pagebreak_position(
                 client,
                 :invoice,
                 1,
                 2,
                 true
               )
    end
  end

  describe "deleting a pagebreak position" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/kb_invoice/1/kb_position_pagebreak/2"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} =
        BexioApiClient.SalesOrderManagement.delete_pagebreak_position(client, :invoice, 1, 2)

      assert result == true
    end
  end

  describe "fetching a list of subposition positions" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_subposition"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "text" => "This is a container to group other position types",
              "pos" => 1,
              "internal_pos" => 1,
              "show_pos_nr" => true,
              "is_optional" => false,
              "total_sum" => "17.800000",
              "show_pos_prices" => true,
              "type" => "KbPositionSubposition",
              "parent_id" => nil
            }
          ])
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, [position]} =
               BexioApiClient.SalesOrderManagement.fetch_subposition_positions(
                 client,
                 :invoice,
                 1
               )

      assert position.id == 1
      assert position.text == "This is a container to group other position types"
      assert position.pos == 1
      assert position.internal_pos == 1
      assert position.show_pos_nr? == true
      assert position.optional? == false
      assert Decimal.equal?(position.total_sum, Decimal.from_float(17.8))
      assert position.parent_id == nil
    end
  end

  describe "fetching a single subposition position" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_subposition/2"} = conn ->
          json(conn, %{
            "id" => 1,
            "text" => "This is a container to group other position types",
            "pos" => 1,
            "internal_pos" => 1,
            "show_pos_nr" => true,
            "is_optional" => false,
            "total_sum" => "17.800000",
            "show_pos_prices" => true,
            "type" => "KbPositionSubposition",
            "parent_id" => nil
          })

        %{method: "GET", request_path: "/2.0/kb_invoice/1/kb_position_subposition/3"} = conn ->
          send_resp(conn, 404, "Subposition does not exist")
      end)

      :ok
    end

    test "shows valid positions" do
      client = BexioApiClient.new("123")

      assert {:ok, position} =
               BexioApiClient.SalesOrderManagement.fetch_subposition_position(
                 client,
                 :invoice,
                 1,
                 2
               )

      assert position.id == 1
      assert position.text == "This is a container to group other position types"
      assert position.pos == 1
      assert position.internal_pos == 1
      assert position.show_pos_nr? == true
      assert position.optional? == false
      assert Decimal.equal?(position.total_sum, Decimal.from_float(17.8))
      assert position.parent_id == nil
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Subposition does not exist"} =
               BexioApiClient.SalesOrderManagement.fetch_subposition_position(
                 client,
                 :invoice,
                 1,
                 3
               )
    end
  end

  describe "creating a subposition position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_subposition"
        } = conn ->
          json(conn, %{
            "id" => 1,
            "text" => "This is a container to group other position types",
            "pos" => 1,
            "internal_pos" => 1,
            "show_pos_nr" => true,
            "is_optional" => false,
            "total_sum" => "17.800000",
            "show_pos_prices" => true,
            "type" => "KbPositionSubposition",
            "parent_id" => nil
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.create_subposition_position(
                 client,
                 :invoice,
                 1,
                 "Container",
                 true
               )
    end
  end

  describe "editing a subposition position" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/kb_invoice/1/kb_position_subposition/2"
        } = conn ->
          json(conn, %{
            "id" => 1,
            "text" => "This is a container to group other position types",
            "pos" => 1,
            "internal_pos" => 1,
            "show_pos_nr" => true,
            "is_optional" => false,
            "total_sum" => "17.800000",
            "show_pos_prices" => true,
            "type" => "KbPositionSubposition",
            "parent_id" => nil
          })
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123")

      assert {:ok, _position} =
               BexioApiClient.SalesOrderManagement.edit_subposition_position(
                 client,
                 :invoice,
                 1,
                 2,
                 "Container",
                 true
               )
    end
  end

  describe "deleting a subposition position" do
    setup do
      mock_request(fn
        %{
          method: "DELETE",
          request_path: "/2.0/kb_invoice/1/kb_position_subposition/2"
        } = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123")

      {:ok, result} =
        BexioApiClient.SalesOrderManagement.delete_subposition_position(client, :invoice, 1, 2)

      assert result == true
    end
  end
end
