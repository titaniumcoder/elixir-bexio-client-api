defmodule BexioApiClient.SalesOrderManagementTest do
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
    Order
  }

  alias BexioApiClient.SearchCriteria

  import Tesla.Mock

  describe "fetching a list of quotes" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_offer"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/kb_offer/search",
          body: _body,
          query: [limit: 100, offset: 50, order_by: :id]
        } ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_offer/1"} ->
          json(%{
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

        %{method: :get, url: "https://api.bexio.com/2.0/kb_offer/99"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:error, :not_found} = BexioApiClient.SalesOrderManagement.fetch_quote(client, 99)
    end
  end

  describe "creating a quote" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/kb_offer", body: body} ->
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

          json(%{
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, record} =
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
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/kb_offer/4", body: body} ->
          json_body = Jason.decode!(body)

          assert json_body["contact_id"] == 14
          assert json_body["pr_project_id"] == 3
          assert json_body["mwst_is_net"] == true
          assert json_body["show_position_taxes"] == false
          assert json_body["is_valid_from"] == "2019-06-24"
          assert json_body["is_valid_until"] == "2019-07-24"
          assert json_body["mwst_type"] == 0

          json(%{
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, record} =
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
      mock(fn
        %{method: :delete, url: "https://api.bexio.com/2.0/kb_offer/4"} ->
          json(%{"success" => true})
      end)

      :ok
    end

    test "deletes the record" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, result} = BexioApiClient.SalesOrderManagement.delete_quote(client, 4)
      assert result == true
    end
  end

  describe "issueing a quote" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/kb_offer/4/issue"} ->
          json(%{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, result} = BexioApiClient.SalesOrderManagement.issue_quote(client, 4)
      assert result == true
    end
  end

  describe "revert issueing a quote" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/kb_offer/4/revertIssue"} ->
          json(%{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, result} = BexioApiClient.SalesOrderManagement.revert_issue_quote(client, 4)
      assert result == true
    end
  end

  describe "accepting a quote" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/kb_offer/4/accept"} ->
          json(%{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, result} = BexioApiClient.SalesOrderManagement.accept_quote(client, 4)
      assert result == true
    end
  end

  describe "declining a quote" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/kb_offer/4/reject"} ->
          json(%{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, result} = BexioApiClient.SalesOrderManagement.decline_quote(client, 4)
      assert result == true
    end
  end

  describe "reissuing a quote" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/kb_offer/4/reissue"} ->
          json(%{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, result} = BexioApiClient.SalesOrderManagement.reissue_quote(client, 4)
      assert result == true
    end
  end

  describe "marking quote as sent" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/kb_offer/4/mark_as_sent"} ->
          json(%{"success" => true})
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, result} = BexioApiClient.SalesOrderManagement.mark_quote_as_sent(client, 4)
      assert result == true
    end
  end

  describe "showing pdf" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_offer/4/pdf"} ->
          json(%{
            "name" => "document-00005.pdf",
            "size" => 9768,
            "mime" => "application/pdf",
            "content" => "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
          })
      end)

      :ok
    end

    test "succeeds" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      {:ok, result} = BexioApiClient.SalesOrderManagement.quote_pdf(client, 4)
      assert result.name == "document-00005.pdf"
      assert result.size == 9768
      assert result.mime == "application/pdf"
      assert result.content == "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
    end
  end

  describe "fetching a list of orders" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_order"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/kb_order/search",
          body: _body,
          query: [limit: 100, offset: 50, order_by: :id]
        } ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_order/4"} ->
          json(%{
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

        %{method: :get, url: "https://api.bexio.com/2.0/kb_order/99"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:error, :not_found} = BexioApiClient.SalesOrderManagement.fetch_order(client, 99)
    end
  end

  describe "fetching a list of comments" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/comment"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/comment/2"} ->
          json(%{
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

        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/comment/3"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found} =
               BexioApiClient.SalesOrderManagement.fetch_comment(client, :invoice, 1, 3)
    end
  end

  describe "creates a comment" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/kb_invoice/1/comment"} ->
          json(%{
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_subtotal"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_subtotal/2"} ->
          json(%{
            "id" => 1,
            "text" => "Subtotal",
            "value" => "17.800000",
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionSubtotal",
            "parent_id" => nil
          })

        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_subtotal/3"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "shows valid position" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found} =
               BexioApiClient.SalesOrderManagement.fetch_subtotal_position(client, :invoice, 1, 3)
    end
  end

  describe "fetching a list of text positions" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_text"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_text/2"} ->
          json(%{
            "id" => 1,
            "text" => "Text Sample",
            "internal_pos" => 1,
            "show_pos_nr" => true,
            "pos" => nil,
            "is_optional" => false,
            "type" => "KbPositionText",
            "parent_id" => nil
          })

        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_text/3"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "shows valid positions" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found} =
               BexioApiClient.SalesOrderManagement.fetch_text_position(client, :invoice, 1, 3)
    end
  end

  describe "fetching a list of default positions" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_custom"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_custom/2"} ->
          json(%{
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

        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_custom/3"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "shows valid positions" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found} =
               BexioApiClient.SalesOrderManagement.fetch_default_position(client, :invoice, 1, 3)
    end
  end

  describe "fetching a list of item positions" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_article"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_article/2"} ->
          json(%{
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

        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_article/3"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "shows valid positions" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found} =
               BexioApiClient.SalesOrderManagement.fetch_item_position(client, :invoice, 1, 3)
    end
  end

  describe "fetching a list of discount positions" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_discount"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_discount/2"} ->
          json(%{
            "id" => 1,
            "text" => "Partner discount",
            "is_percentual" => true,
            "value" => "10.000000",
            "discount_total" => "1.780000",
            "type" => "KbPositionDiscount"
          })

        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_discount/3"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "shows valid positions" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, position} =
               BexioApiClient.SalesOrderManagement.fetch_discount_position(client, :invoice, 1, 2)

      assert position.id == 1
      assert position.text == "Partner discount"
      assert position.percentual? == true
      assert Decimal.equal?(position.value, Decimal.from_float(10.0))
      assert Decimal.equal?(position.discount_total, Decimal.from_float(1.78))
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found} =
               BexioApiClient.SalesOrderManagement.fetch_discount_position(client, :invoice, 1, 3)
    end
  end

  describe "fetching a list of pagebreak positions" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_pagebreak"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_pagebreak/2"} ->
          json(%{
            "id" => 1,
            "internal_pos" => 1,
            "is_optional" => false,
            "type" => "KbPositionPagebreak",
            "parent_id" => nil
          })

        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_pagebreak/3"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "shows valid positions" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found} =
               BexioApiClient.SalesOrderManagement.fetch_pagebreak_position(
                 client,
                 :invoice,
                 1,
                 3
               )
    end
  end

  describe "fetching a list of subposition positions" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_subposition"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_subposition/2"} ->
          json(%{
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

        %{method: :get, url: "https://api.bexio.com/2.0/kb_invoice/1/kb_position_subposition/3"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "shows valid positions" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found} =
               BexioApiClient.SalesOrderManagement.fetch_subposition_position(
                 client,
                 :invoice,
                 1,
                 3
               )
    end
  end
end
