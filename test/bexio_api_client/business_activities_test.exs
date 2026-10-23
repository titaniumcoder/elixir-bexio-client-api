defmodule BexioApiClient.BusinessActivitiesTest do
  use TestHelper

  use ExUnit.Case, async: true

  doctest BexioApiClient.BusinessActivities

  alias BexioApiClient.BusinessActivities
  alias BexioApiClient.SearchCriteria
  alias BexioApiClient.BusinessActivities.BusinessActivity

  describe "fetching a list of business activities" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/client_service"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "Project Management",
              "default_is_billable" => false,
              "default_price_per_hour" => nil,
              "account_id" => nil
            },
            %{
              "id" => 2,
              "name" => "Development",
              "default_is_billable" => true,
              "default_price_per_hour" => 120.5,
              "account_id" => 42
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} = BusinessActivities.fetch_business_activities(client)

      assert result1.id == 1
      assert result1.name == "Project Management"
      assert result1.default_billable? == false
      assert result1.default_price_per_hour == nil
      assert result1.account_id == nil

      assert result2.id == 2
      assert result2.name == "Development"
      assert result2.default_billable? == true
      assert Decimal.equal?(result2.default_price_per_hour, Decimal.from_float(120.5))
      assert result2.account_id == 42
    end
  end

  describe "searching business activities" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/client_service/search"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "Project Management",
              "default_is_billable" => false,
              "default_price_per_hour" => nil,
              "account_id" => nil
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BusinessActivities.search_business_activities(
                 client,
                 [SearchCriteria.like(:name, "Management")]
               )

      assert result.id == 1
      assert result.name == "Project Management"
      assert result.default_billable? == false
      assert result.default_price_per_hour == nil
      assert result.account_id == nil
    end
  end

  describe "creating a business activity" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/client_service"} = conn ->
          json(conn, %{
            "id" => 3,
            "name" => "Consulting",
            "default_is_billable" => true,
            "default_price_per_hour" => "90.00",
            "account_id" => 7
          })
      end)

      :ok
    end

    test "creates a new record" do
      client = BexioApiClient.new("123")

      {:ok, result} =
        BusinessActivities.create_business_activity(
          client,
          BusinessActivity.new(%{
            name: "Consulting",
            default_is_billable: true,
            default_price_per_hour: Decimal.new("90.00"),
            account_id: 7
          })
        )

      assert result.id == 3
      assert result.name == "Consulting"
      assert result.default_billable? == true
      assert Decimal.equal?(result.default_price_per_hour, Decimal.new("90.00"))
      assert result.account_id == 7
    end
  end

  describe "creating a business activity with a validation error" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/client_service"} = conn ->
          send_resp(conn, 422, "Validation error")
      end)

      :ok
    end

    test "fails on validation error" do
      client = BexioApiClient.new("123")

      assert {:error, :could_not_be_saved, "Validation error"} =
               BusinessActivities.create_business_activity(
                 client,
                 BusinessActivity.new(%{name: "Consulting"})
               )
    end
  end

  describe "fetching a list of communication types" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/communication_kind"} = conn ->
          json(conn, [
            %{"id" => 1, "name" => "Mobile Phone"},
            %{"id" => 2, "name" => "E-Mail"}
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} = BusinessActivities.fetch_communication_types(client)

      assert result1.id == 1
      assert result1.name == "Mobile Phone"
      assert result2.id == 2
      assert result2.name == "E-Mail"
    end

    test "fails when access is invalid" do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/communication_kind"} = conn ->
          send_resp(conn, 401, "Invalid access")
      end)

      client = BexioApiClient.new("123")

      assert {:error, :invalid_access, "Invalid access"} =
               BusinessActivities.fetch_communication_types(client)
    end
  end

  describe "searching communication types" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/communication_kind/search"} = conn ->
          json(conn, [%{"id" => 2, "name" => "E-Mail"}])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BusinessActivities.search_communication_types(
                 client,
                 [SearchCriteria.like(:name, "E-Mail")]
               )

      assert result.id == 2
      assert result.name == "E-Mail"
    end
  end
end
