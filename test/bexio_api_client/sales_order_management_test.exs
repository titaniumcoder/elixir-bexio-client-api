defmodule BexioApiClient.SalesOrderManagementTest do
  use ExUnit.Case, async: true
  doctest BexioApiClient.Contacts

  alias BexioApiClient.SearchCriteria

  import Tesla.Mock

  describe "fetches a list of subtotal positions" do
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

    test "fetches valid position" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [position]} =BexioApiClient.SalesOrderManagement.fetch_subtotal_positions(client, :invoice, 1)

      assert position.id == 1
      assert position.text == "Subtotal"
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.parent_id == nil
      assert Decimal.equal?(position.value, Decimal.new("17.8"))
    end
  end

  describe "fetch a single subtotal position" do
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
      assert {:ok, position} = BexioApiClient.SalesOrderManagement.fetch_subtotal_position(client, :invoice, 1, 2)
      assert position.id == 1
      assert position.text == "Subtotal"
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.parent_id == nil
      assert Decimal.equal?(position.value, Decimal.new("17.8"))
    end

    test "fails on unknown position" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:error, :not_found} =  BexioApiClient.SalesOrderManagement.fetch_subtotal_position(client, :invoice, 1, 3)
    end
  end

  describe "fetches a list of text positions" do
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

    test "fetches valid position" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [position]} =BexioApiClient.SalesOrderManagement.fetch_text_positions(client, :invoice, 1)

      assert position.id == 1
      assert position.text == "Text Sample"
      assert position.show_pos_nr == true
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.parent_id == nil
    end
  end

  describe "fetch a single text position" do
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
      assert {:ok, position} = BexioApiClient.SalesOrderManagement.fetch_text_position(client, :invoice, 1, 2)

      assert position.id == 1
      assert position.text == "Text Sample"
      assert position.show_pos_nr == true
      assert position.internal_pos == 1
      assert position.optional? == false
      assert position.parent_id == nil
    end

    test "fails on unknown position" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:error, :not_found} =  BexioApiClient.SalesOrderManagement.fetch_text_position(client, :invoice, 1, 3)
    end
  end

  describe "fetches a list of default positions" do
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

    test "fetches valid position" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [position]} =BexioApiClient.SalesOrderManagement.fetch_default_positions(client, :invoice, 1)

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

  describe "fetch a single default position" do
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
      assert {:ok, position} = BexioApiClient.SalesOrderManagement.fetch_default_position(client, :invoice, 1, 2)

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

    test "fails on unknown position" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:error, :not_found} =  BexioApiClient.SalesOrderManagement.fetch_default_position(client, :invoice, 1, 3)
    end
  end
  describe "fetches a list of item positions" do
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

    test "fetches valid position" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [position]} =BexioApiClient.SalesOrderManagement.fetch_item_positions(client, :invoice, 1)

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

  describe "fetch a single item position" do
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
      assert {:ok, position} = BexioApiClient.SalesOrderManagement.fetch_item_position(client, :invoice, 1, 2)

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

    test "fails on unknown position" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:error, :not_found} =  BexioApiClient.SalesOrderManagement.fetch_item_position(client, :invoice, 1, 3)
    end
  end
end
