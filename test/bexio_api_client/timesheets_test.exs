defmodule BexioApiClient.TimesheetsTest do
  use TestHelper

  use ExUnit.Case, async: true

  doctest BexioApiClient.Timesheets

  alias BexioApiClient.Timesheets.{Timesheet, TimesheetStatus}
  alias BexioApiClient.SearchCriteria

  defp timesheet_json do
    %{
      "id" => 2,
      "user_id" => 1,
      "status_id" => 4,
      "client_service_id" => 1,
      "text" => "",
      "allowable_bill" => true,
      "charge" => nil,
      "contact_id" => 2,
      "sub_contact_id" => nil,
      "pr_project_id" => nil,
      "pr_package_id" => nil,
      "pr_milestone_id" => nil,
      "travel_time" => nil,
      "travel_charge" => nil,
      "travel_distance" => 0,
      "estimated_time" => "02:30",
      "date" => "2019-05-20",
      "duration" => "01:40",
      "running" => false,
      "tracking" => %{
        "type" => "duration",
        "date" => "2019-05-20",
        "duration" => "01:40"
      }
    }
  end

  describe "fetching a list of timesheets" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/timesheet"
        } = conn ->
          json(conn, [timesheet_json()])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Timesheets.fetch_timesheets(client)

      assert result.id == 2
      assert result.user_id == 1
      assert result.status_id == 4
      assert result.client_service_id == 1
      assert result.text == ""
      assert result.allowable_bill? == true
      assert result.charge == nil
      assert result.contact_id == 2
      assert result.sub_contact_id == nil
      assert result.pr_project_id == nil
      assert result.pr_package_id == nil
      assert result.pr_milestone_id == nil
      assert result.travel_time == nil
      assert result.travel_charge == nil
      assert result.travel_distance == 0
      assert result.estimated_time == "02:30"
      assert result.date == ~D[2019-05-20]
      assert result.duration == "01:40"
      assert result.running? == false
      assert result.tracking.type == :duration
      assert result.tracking.date == ~D[2019-05-20]
      assert result.tracking.duration == "01:40"
    end
  end

  describe "searching timesheets" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/timesheet/search"
        } = conn ->
          json(conn, [timesheet_json()])
      end)

      :ok
    end

    test "searches valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.Timesheets.search_timesheets(client, [
                 SearchCriteria.equal(:pr_project_id, 23)
               ])

      assert result.id == 2
      assert result.date == ~D[2019-05-20]
    end
  end

  describe "show timesheet" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/timesheet/1"} = conn ->
          json(conn, timesheet_json())

        %{method: "GET", request_path: "/2.0/timesheet/2"} = conn ->
          send_resp(conn, 404, "Timesheet does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Timesheets.fetch_timesheet(client, 1)

      assert result.id == 2
      assert result.user_id == 1
      assert result.status_id == 4
      assert result.client_service_id == 1
      assert result.allowable_bill? == true
      assert result.contact_id == 2
      assert result.estimated_time == "02:30"
      assert result.date == ~D[2019-05-20]
      assert result.duration == "01:40"
      assert result.running? == false
      assert result.tracking.type == :duration
      assert result.tracking.duration == "01:40"
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Timesheet does not exist"} =
               BexioApiClient.Timesheets.fetch_timesheet(client, 2)
    end
  end

  describe "creating a timesheet" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/timesheet"} = conn ->
          json(conn, timesheet_json())
      end)

      :ok
    end

    test "creates a new record" do
      client = BexioApiClient.new("123")

      timesheet =
        Timesheet.new(%{
          user_id: 1,
          status_id: 4,
          client_service_id: 1,
          text: "",
          allowable_bill: true,
          contact_id: 2,
          estimated_time: "02:30",
          tracking: %BexioApiClient.Timesheets.Tracking{
            type: :duration,
            date: ~D[2019-05-20],
            duration: "01:40"
          }
        })

      assert {:ok, _record} = BexioApiClient.Timesheets.create_timesheet(client, timesheet)
    end
  end

  describe "editing a timesheet" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/timesheet/2"} = conn ->
          json(conn, timesheet_json())
      end)

      :ok
    end

    test "edits a record" do
      client = BexioApiClient.new("123")

      timesheet =
        Timesheet.new(%{
          id: 2,
          user_id: 1,
          client_service_id: 1,
          allowable_bill: true,
          tracking: %BexioApiClient.Timesheets.Tracking{
            type: :duration,
            date: ~D[2019-05-20],
            duration: "01:40"
          }
        })

      assert {:ok, _record} = BexioApiClient.Timesheets.edit_timesheet(client, timesheet)
    end
  end

  describe "deleting a timesheet" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/timesheet/2"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the record" do
      client = BexioApiClient.new("123")

      {:ok, result} = BexioApiClient.Timesheets.delete_timesheet(client, 2)
      assert result == true
    end
  end

  describe "fetching a list of timesheet statuses" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/timesheet_status"
        } = conn ->
          json(conn, [%{"id" => 2, "name" => "In Progress"}])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Timesheets.fetch_timesheet_statuses(client)

      assert %TimesheetStatus{} = result
      assert result.id == 2
      assert result.name == "In Progress"
    end
  end
end
