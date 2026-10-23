defmodule BexioApiClient.Timesheets do
  @moduledoc """
  Bexio API for the timesheets part of the API
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria

  alias BexioApiClient.Timesheets.{
    Timesheet,
    TimesheetStatus,
    Tracking
  }

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @type api_error_type :: BexioApiClient.Helpers.api_error_type()

  @doc """
  Fetch a list of timesheets.
  """
  @spec fetch_timesheets(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Timesheet.t()]} | api_error_type()
  def fetch_timesheets(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/timesheet", params: opts_to_query(opts))
      end,
      &map_from_timesheets/2
    )
  end

  @doc """
  Search timesheets via query.
  The following search fields are supported:

  * id
  * client_service_id
  * contact_id
  * user_id
  * pr_project_id
  * status_id
  """
  @spec search_timesheets(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Timesheet.t()]} | api_error_type()
  def search_timesheets(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/timesheet/search",
          json: criteria,
          params: opts_to_query(opts)
        )
      end,
      &map_from_timesheets/2
    )
  end

  @doc """
  Fetch a single timesheet.
  """
  @spec fetch_timesheet(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, Timesheet.t()} | api_error_type()
  def fetch_timesheet(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/timesheet/#{id}"
        )
      end,
      &map_from_timesheet/2
    )
  end

  @doc """
  Create a timesheet.
  """
  @spec create_timesheet(
          req :: Req.Request.t(),
          timesheet :: Timesheet.t()
        ) :: {:ok, Timesheet.t()} | api_error_type()
  def create_timesheet(req, timesheet) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/timesheet", json: remap_timesheet(timesheet))
      end,
      &map_from_timesheet/2
    )
  end

  @doc """
  Edit a timesheet.
  """
  @spec edit_timesheet(
          req :: Req.Request.t(),
          timesheet :: Timesheet.t()
        ) :: {:ok, Timesheet.t()} | api_error_type()
  def edit_timesheet(req, timesheet) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/timesheet/#{timesheet.id}", json: remap_timesheet(timesheet))
      end,
      &map_from_timesheet/2
    )
  end

  @doc """
  Delete a timesheet.
  """
  @spec delete_timesheet(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_timesheet(req, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/timesheet/#{id}")
      end,
      &success_response/2
    )
  end

  @doc """
  Fetch a list of timesheet statuses.
  """
  @spec fetch_timesheet_statuses(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [TimesheetStatus.t()]} | api_error_type()
  def fetch_timesheet_statuses(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/timesheet_status", params: opts_to_query(opts))
      end,
      &map_from_timesheet_statuses/2
    )
  end

  defp map_from_timesheets(timesheets, _env), do: Enum.map(timesheets, &map_from_timesheet/1)

  defp map_from_timesheet(
         %{
           "id" => id,
           "user_id" => user_id,
           "status_id" => status_id,
           "client_service_id" => client_service_id,
           "text" => text,
           "allowable_bill" => allowable_bill?,
           "charge" => charge,
           "contact_id" => contact_id,
           "sub_contact_id" => sub_contact_id,
           "pr_project_id" => pr_project_id,
           "pr_package_id" => pr_package_id,
           "pr_milestone_id" => pr_milestone_id,
           "estimated_time" => estimated_time,
           "date" => date,
           "duration" => duration,
           "running" => running?,
           "tracking" => tracking
         } = timesheet,
         _env \\ nil
       ) do
    %Timesheet{
      id: id,
      user_id: user_id,
      status_id: status_id,
      client_service_id: client_service_id,
      text: text,
      allowable_bill?: allowable_bill?,
      charge: charge,
      contact_id: contact_id,
      sub_contact_id: sub_contact_id,
      pr_project_id: pr_project_id,
      pr_package_id: pr_package_id,
      pr_milestone_id: pr_milestone_id,
      travel_time: Map.get(timesheet, "travel_time"),
      travel_charge: Map.get(timesheet, "travel_charge"),
      travel_distance: Map.get(timesheet, "travel_distance"),
      estimated_time: estimated_time,
      date: to_date(date),
      duration: duration,
      running?: running?,
      tracking: map_from_tracking(tracking)
    }
  end

  defp map_from_tracking(nil), do: nil

  defp map_from_tracking(%{"type" => "duration"} = tracking),
    do: %Tracking{
      type: :duration,
      date: to_date(Map.get(tracking, "date")),
      duration: Map.get(tracking, "duration")
    }

  defp map_from_tracking(%{"type" => "range"} = tracking),
    do: %Tracking{type: :range, date: to_date(Map.get(tracking, "date"))}

  defp remap_timesheet(timesheet) do
    timesheet
    |> Map.take([
      :user_id,
      :status_id,
      :client_service_id,
      :text,
      :allowable_bill?,
      :charge,
      :contact_id,
      :sub_contact_id,
      :pr_project_id,
      :pr_package_id,
      :pr_milestone_id,
      :estimated_time
    ])
    |> Map.put(:tracking, remap_tracking(timesheet.tracking))
  end

  defp remap_tracking(%Tracking{type: type, date: date, duration: duration}) do
    %{
      type: Atom.to_string(type),
      date: to_iso8601(date),
      duration: duration
    }
  end

  defp map_from_timesheet_statuses(timesheet_statuses, _env),
    do: Enum.map(timesheet_statuses, &map_from_timesheet_status/1)

  defp map_from_timesheet_status(
         %{
           "id" => id,
           "name" => name
         },
         _env \\ nil
       ) do
    %TimesheetStatus{
      id: id,
      name: name
    }
  end
end
