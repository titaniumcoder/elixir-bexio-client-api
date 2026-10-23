defmodule BexioApiClient.ProjectsTest do
  use TestHelper

  use ExUnit.Case, async: true

  alias BexioApiClient.Projects.Project
  alias BexioApiClient.Projects.ProjectState
  alias BexioApiClient.Projects.ProjectType

  defp project_json do
    %{
      "id" => 2,
      "uuid" => "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
      "nr" => "000002",
      "name" => "Villa Kunterbunt",
      "start_date" => "2019-07-12 00:00:00",
      "end_date" => nil,
      "comment" => "",
      "pr_state_id" => 2,
      "pr_project_type_id" => 2,
      "contact_id" => 2,
      "contact_sub_id" => nil,
      "pr_invoice_type_id" => 3,
      "pr_invoice_type_amount" => "230.00",
      "pr_budget_type_id" => 1,
      "pr_budget_type_amount" => "200.00",
      "user_id" => 1
    }
  end

  describe "fetching a list of projects" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/pr_project"
        } = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["order_by"] == "id"

          json(conn, [project_json()])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Projects.fetch_projects(client, order_by: :id)

      assert result.id == 2
      assert result.uuid == "046b6c7f-0b8a-43b9-b35d-6489e6daee91"
      assert result.nr == "000002"
      assert result.name == "Villa Kunterbunt"
      assert result.start_date == ~N[2019-07-12 00:00:00]
      assert result.end_date == nil
      assert result.comment == ""
      assert result.pr_state_id == 2
      assert result.pr_project_type_id == 2
      assert result.contact_id == 2
      assert result.contact_sub_id == nil
      assert result.pr_invoice_type == :hourly_rate_project
      assert Decimal.equal?(result.pr_invoice_type_amount, Decimal.new("230.00"))
      assert result.pr_budget_type == :total_budget_costs
      assert Decimal.equal?(result.pr_budget_type_amount, Decimal.new("200.00"))
      assert result.user_id == 1
    end
  end

  describe "searching projects" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/pr_project/search"
        } = conn ->
          json(conn, [project_json()])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      criteria = [
        BexioApiClient.SearchCriteria.equal(:name, "Villa Kunterbunt")
      ]

      assert {:ok, [result]} = BexioApiClient.Projects.search_projects(client, criteria)

      assert result.id == 2
      assert result.name == "Villa Kunterbunt"
    end
  end

  describe "fetching a single project" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/pr_project/2"} = conn ->
          json(conn, project_json())

        %{method: "GET", request_path: "/2.0/pr_project/3"} = conn ->
          send_resp(conn, 404, "Project does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.Projects.fetch_project(client, 2)

      assert result.id == 2
      assert result.name == "Villa Kunterbunt"
      assert result.start_date == ~N[2019-07-12 00:00:00]
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Project does not exist"} =
               BexioApiClient.Projects.fetch_project(client, 3)
    end
  end

  describe "creating a project" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/pr_project"} = conn ->
          json(conn, project_json())
      end)

      :ok
    end

    test "creates a new record" do
      client = BexioApiClient.new("123")

      project =
        Project.new(%{
          name: "Villa Kunterbunt",
          start_date: ~N[2019-07-12 00:00:00],
          pr_state_id: 2,
          pr_project_type_id: 2,
          contact_id: 2,
          pr_invoice_type_id: 3,
          pr_invoice_type_amount: Decimal.new("230.00"),
          pr_budget_type_id: 1,
          pr_budget_type_amount: Decimal.new("200.00"),
          user_id: 1
        })

      {:ok, result} = BexioApiClient.Projects.create_project(client, project)

      assert result.id == 2
      assert result.name == "Villa Kunterbunt"
    end
  end

  describe "editing a project" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/pr_project/2"} = conn ->
          json(conn, project_json())
      end)

      :ok
    end

    test "edits the record" do
      client = BexioApiClient.new("123")

      project =
        Project.new(%{
          id: 2,
          name: "Villa Kunterbunt",
          pr_state_id: 2,
          pr_project_type_id: 2,
          contact_id: 2,
          user_id: 1
        })

      {:ok, result} = BexioApiClient.Projects.edit_project(client, project)

      assert result.id == 2
      assert result.name == "Villa Kunterbunt"
    end
  end

  describe "deleting a project" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/pr_project/2"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the record" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.Projects.delete_project(client, 2)
      assert result == true
    end
  end

  describe "archiving a project" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/pr_project/2/archive"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "archives the record" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.Projects.archive_project(client, 2)
      assert result == true
    end
  end

  describe "reactivating a project" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/pr_project/2/reactivate"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "reactivates the record" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.Projects.reactivate_project(client, 2)
      assert result == true
    end
  end

  describe "fetching a list of project states" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/pr_project_state"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "Active"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [%ProjectState{id: 1, name: "Active"}]} =
               BexioApiClient.Projects.fetch_project_states(client)
    end
  end

  describe "fetching a list of project types" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/pr_project_type"} = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["order_by"] == "name"

          json(conn, [
            %{
              "id" => 1,
              "name" => "Internal Project"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [%ProjectType{id: 1, name: "Internal Project"}]} =
               BexioApiClient.Projects.fetch_project_types(client, order_by: :name)
    end
  end
end
