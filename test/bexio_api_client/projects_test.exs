defmodule BexioApiClient.ProjectsTest do
  use TestHelper

  use ExUnit.Case, async: true

  alias BexioApiClient.Projects.Project
  alias BexioApiClient.Projects.ProjectState
  alias BexioApiClient.Projects.ProjectType
  alias BexioApiClient.Projects.{Milestone, WorkPackage}

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

  describe "fetching a list of milestones" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/projects/1/milestones"} = conn ->
          json(conn, [
            %{
              "id" => 4,
              "name" => "project documentation",
              "end_date" => "2018-05-18",
              "comment" => "Finish project documentation.",
              "pr_parent_milestone_id" => 3
            },
            %{
              "id" => 5,
              "name" => "project setup",
              "end_date" => nil,
              "comment" => nil,
              "pr_parent_milestone_id" => nil
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} = BexioApiClient.Projects.fetch_milestones(client, 1)

      assert result1.id == 4
      assert result1.name == "project documentation"
      assert result1.end_date == ~D[2018-05-18]
      assert result1.comment == "Finish project documentation."
      assert result1.pr_parent_milestone_id == 3

      assert result2.id == 5
      assert result2.name == "project setup"
      assert result2.end_date == nil
      assert result2.comment == nil
      assert result2.pr_parent_milestone_id == nil
    end

    test "passes paging options" do
      client = BexioApiClient.new("123")

      mock_request(fn
        %{method: "GET", request_path: "/3.0/projects/1/milestones"} = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["limit"] == "5"
          assert conn.query_params["offset"] == "10"

          json(conn, [])
      end)

      assert {:ok, []} =
               BexioApiClient.Projects.fetch_milestones(client, 1, limit: 5, offset: 10)
    end
  end

  describe "creating a milestone" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/3.0/projects/1/milestones"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["name"] == "project documentation"
          assert body_json["end_date"] == "2018-05-18"
          assert body_json["comment"] == "Finish project documentation."
          assert body_json["pr_parent_milestone_id"] == 3

          json(conn, %{
            "id" => 4,
            "name" => "project documentation",
            "end_date" => "2018-05-18",
            "comment" => "Finish project documentation.",
            "pr_parent_milestone_id" => 3
          })
      end)

      :ok
    end

    test "creates the milestone" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Projects.create_milestone(
                 client,
                 1,
                 Milestone.new(%{
                   name: "project documentation",
                   end_date: ~D[2018-05-18],
                   comment: "Finish project documentation.",
                   pr_parent_milestone_id: 3
                 })
               )

      assert result.id == 4
      assert result.name == "project documentation"
      assert result.end_date == ~D[2018-05-18]
      assert result.comment == "Finish project documentation."
      assert result.pr_parent_milestone_id == 3
    end
  end

  describe "fetching a single milestone" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/projects/1/milestones/4"} = conn ->
          json(conn, %{
            "id" => 4,
            "name" => "project documentation",
            "end_date" => "2018-05-18",
            "comment" => "Finish project documentation.",
            "pr_parent_milestone_id" => 3
          })

        %{method: "GET", request_path: "/3.0/projects/1/milestones/99"} = conn ->
          send_resp(conn, 404, "Milestone does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Projects.fetch_milestone(client, 1, 4)

      assert result.id == 4
      assert result.name == "project documentation"
      assert result.end_date == ~D[2018-05-18]
      assert result.comment == "Finish project documentation."
      assert result.pr_parent_milestone_id == 3
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Milestone does not exist"} =
               BexioApiClient.Projects.fetch_milestone(client, 1, 99)
    end
  end

  describe "editing a milestone" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/3.0/projects/1/milestones/4"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["name"] == "project documentation edited"

          json(conn, %{
            "id" => 4,
            "name" => "project documentation edited",
            "end_date" => "2018-05-18",
            "comment" => "Finish project documentation.",
            "pr_parent_milestone_id" => 3
          })
      end)

      :ok
    end

    test "edits the milestone" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Projects.edit_milestone(client, 1, %Milestone{
                 id: 4,
                 name: "project documentation edited",
                 end_date: ~D[2018-05-18],
                 comment: "Finish project documentation.",
                 pr_parent_milestone_id: 3
               })

      assert result.id == 4
      assert result.name == "project documentation edited"
      assert result.end_date == ~D[2018-05-18]
      assert result.comment == "Finish project documentation."
      assert result.pr_parent_milestone_id == 3
    end
  end

  describe "deleting a milestone" do
    setup do
      mock_request(fn
        %{
          method: "DELETE",
          request_path: "/3.0/projects/1/milestones/4"
        } = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "success" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Projects.delete_milestone(client, 1, 4)

      assert result == true
    end
  end

  describe "fetching a list of work packages" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/projects/1/packages"} = conn ->
          json(conn, [
            %{
              "id" => 4,
              "name" => "Documentation",
              "spent_time_in_hours" => 0.5,
              "estimated_time_in_hours" => 1.75,
              "comment" => "Crete project documentation",
              "pr_milestone_id" => 3
            },
            %{
              "id" => 5,
              "name" => "Implementation",
              "spent_time_in_hours" => nil,
              "estimated_time_in_hours" => nil,
              "comment" => nil,
              "pr_milestone_id" => nil
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} = BexioApiClient.Projects.fetch_work_packages(client, 1)

      assert result1.id == 4
      assert result1.name == "Documentation"
      assert result1.spent_time_in_hours == Decimal.new("0.5")
      assert result1.estimated_time_in_hours == Decimal.new("1.75")
      assert result1.comment == "Crete project documentation"
      assert result1.pr_milestone_id == 3

      assert result2.id == 5
      assert result2.name == "Implementation"
      assert result2.spent_time_in_hours == nil
      assert result2.estimated_time_in_hours == nil
      assert result2.comment == nil
      assert result2.pr_milestone_id == nil
    end

    test "passes paging options" do
      client = BexioApiClient.new("123")

      mock_request(fn
        %{method: "GET", request_path: "/3.0/projects/1/packages"} = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["limit"] == "5"
          assert conn.query_params["offset"] == "10"

          json(conn, [])
      end)

      assert {:ok, []} =
               BexioApiClient.Projects.fetch_work_packages(client, 1, limit: 5, offset: 10)
    end
  end

  describe "creating a work package" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/3.0/projects/1/packages"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["name"] == "Documentation"
          assert body_json["spent_time_in_hours"] == "0.5"
          assert body_json["estimated_time_in_hours"] == "1.75"
          assert body_json["comment"] == "Crete project documentation"
          assert body_json["pr_milestone_id"] == 3

          json(conn, %{
            "id" => 4,
            "name" => "Documentation",
            "spent_time_in_hours" => 0.5,
            "estimated_time_in_hours" => 1.75,
            "comment" => "Crete project documentation",
            "pr_milestone_id" => 3
          })
      end)

      :ok
    end

    test "creates the work package" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Projects.create_work_package(
                 client,
                 1,
                 WorkPackage.new(%{
                   name: "Documentation",
                   spent_time_in_hours: Decimal.new("0.5"),
                   estimated_time_in_hours: Decimal.new("1.75"),
                   comment: "Crete project documentation",
                   pr_milestone_id: 3
                 })
               )

      assert result.id == 4
      assert result.name == "Documentation"
      assert result.spent_time_in_hours == Decimal.new("0.5")
      assert result.estimated_time_in_hours == Decimal.new("1.75")
      assert result.comment == "Crete project documentation"
      assert result.pr_milestone_id == 3
    end
  end

  describe "fetching a single work package" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/3.0/projects/1/packages/4"} = conn ->
          json(conn, %{
            "id" => 4,
            "name" => "Documentation",
            "spent_time_in_hours" => 0.5,
            "estimated_time_in_hours" => 1.75,
            "comment" => "Crete project documentation",
            "pr_milestone_id" => 3
          })

        %{method: "GET", request_path: "/3.0/projects/1/packages/99"} = conn ->
          send_resp(conn, 404, "Work package does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Projects.fetch_work_package(client, 1, 4)

      assert result.id == 4
      assert result.name == "Documentation"
      assert result.spent_time_in_hours == Decimal.new("0.5")
      assert result.estimated_time_in_hours == Decimal.new("1.75")
      assert result.comment == "Crete project documentation"
      assert result.pr_milestone_id == 3
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Work package does not exist"} =
               BexioApiClient.Projects.fetch_work_package(client, 1, 99)
    end
  end

  describe "editing a work package" do
    setup do
      mock_request(fn
        %{
          method: "PATCH",
          request_path: "/3.0/projects/1/packages/4"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["name"] == "Documentation edited"

          json(conn, %{
            "id" => 4,
            "name" => "Documentation edited",
            "spent_time_in_hours" => 0.5,
            "estimated_time_in_hours" => 1.75,
            "comment" => "Crete project documentation",
            "pr_milestone_id" => 3
          })
      end)

      :ok
    end

    test "edits the work package" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Projects.edit_work_package(client, 1, %WorkPackage{
                 id: 4,
                 name: "Documentation edited",
                 spent_time_in_hours: Decimal.new("0.5"),
                 estimated_time_in_hours: Decimal.new("1.75"),
                 comment: "Crete project documentation",
                 pr_milestone_id: 3
               })

      assert result.id == 4
      assert result.name == "Documentation edited"
      assert result.spent_time_in_hours == Decimal.new("0.5")
      assert result.estimated_time_in_hours == Decimal.new("1.75")
      assert result.comment == "Crete project documentation"
      assert result.pr_milestone_id == 3
    end
  end

  describe "deleting a work package" do
    setup do
      mock_request(fn
        %{
          method: "DELETE",
          request_path: "/3.0/projects/1/packages/4"
        } = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "success" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Projects.delete_work_package(client, 1, 4)

      assert result == true
    end
  end
end
