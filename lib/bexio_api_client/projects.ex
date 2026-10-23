defmodule BexioApiClient.Projects do
  @moduledoc """
  Bexio API for the projects part of the API.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria

  alias BexioApiClient.Projects.Project
  alias BexioApiClient.Projects.ProjectState
  alias BexioApiClient.Projects.ProjectType

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @type api_error_type :: BexioApiClient.Helpers.api_error_type()

  @doc """
  Fetch a list of projects.
  """
  @spec fetch_projects(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Project.t()]} | api_error_type()
  def fetch_projects(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/pr_project", params: opts_to_query(opts))
      end,
      &map_from_projects/2
    )
  end

  @doc """
  Search projects via query.
  The following search fields are supported:

  * name
  * contact_id
  * pr_state_id
  """
  @spec search_projects(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Project.t()]} | api_error_type()
  def search_projects(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/pr_project/search",
          json: criteria,
          params: opts_to_query(opts)
        )
      end,
      &map_from_projects/2
    )
  end

  @doc """
  Fetch a single project.
  """
  @spec fetch_project(
          req :: Req.Request.t(),
          project_id :: non_neg_integer()
        ) :: {:ok, Project.t()} | api_error_type()
  def fetch_project(req, project_id) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/pr_project/#{project_id}"
        )
      end,
      &map_from_project/2
    )
  end

  @doc """
  Create a project.
  """
  @spec create_project(
          req :: Req.Request.t(),
          project :: Project.t()
        ) :: {:ok, Project.t()} | api_error_type()
  def create_project(req, project) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/pr_project", json: remap_project(project))
      end,
      &map_from_project/2
    )
  end

  @doc """
  Edit a project.
  """
  @spec edit_project(
          req :: Req.Request.t(),
          project :: Project.t()
        ) :: {:ok, Project.t()} | api_error_type()
  def edit_project(req, project) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/pr_project/#{project.id}", json: remap_project(project))
      end,
      &map_from_project/2
    )
  end

  @doc """
  Delete a project.
  """
  @spec delete_project(
          req :: Req.Request.t(),
          project_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_project(req, project_id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/pr_project/#{project_id}")
      end,
      &success_response/2
    )
  end

  @doc """
  Archive a project.
  """
  @spec archive_project(
          req :: Req.Request.t(),
          project_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def archive_project(req, project_id) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/pr_project/#{project_id}/archive")
      end,
      &success_response/2
    )
  end

  @doc """
  Unarchive (reactivate) an archived project.
  """
  @spec reactivate_project(
          req :: Req.Request.t(),
          project_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def reactivate_project(req, project_id) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/pr_project/#{project_id}/reactivate")
      end,
      &success_response/2
    )
  end

  @doc """
  Fetch a list of project statuses.
  """
  @spec fetch_project_states(req :: Req.Request.t()) ::
          {:ok, [ProjectState.t()]} | api_error_type()
  def fetch_project_states(req) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/pr_project_state")
      end,
      &map_from_project_states/2
    )
  end

  @doc """
  Fetch a list of project types.
  """
  @spec fetch_project_types(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [ProjectType.t()]} | api_error_type()
  def fetch_project_types(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/pr_project_type", params: opts_to_query(opts))
      end,
      &map_from_project_types/2
    )
  end

  defp map_from_projects(projects, _env), do: Enum.map(projects, &map_from_project/1)

  defp map_from_project(
         %{
           "id" => id,
           "uuid" => uuid,
           "nr" => nr,
           "name" => name,
           "start_date" => start_date,
           "end_date" => end_date,
           "comment" => comment,
           "pr_state_id" => pr_state_id,
           "pr_project_type_id" => pr_project_type_id,
           "contact_id" => contact_id,
           "contact_sub_id" => contact_sub_id,
           "pr_invoice_type_id" => pr_invoice_type,
           "pr_invoice_type_amount" => pr_invoice_type_amount,
           "pr_budget_type_id" => pr_budget_type,
           "pr_budget_type_amount" => pr_budget_type_amount,
           "user_id" => user_id
         },
         _env \\ nil
       ) do
    %Project{
      id: id,
      uuid: uuid,
      nr: nr,
      name: name,
      start_date: to_datetime(start_date),
      end_date: to_datetime(end_date),
      comment: comment,
      pr_state_id: pr_state_id,
      pr_project_type_id: pr_project_type_id,
      contact_id: contact_id,
      contact_sub_id: contact_sub_id,
      pr_invoice_type: invoice_type(pr_invoice_type),
      pr_invoice_type_amount: to_decimal(pr_invoice_type_amount),
      pr_budget_type: budget_type(pr_budget_type),
      pr_budget_type_amount: to_decimal(pr_budget_type_amount),
      user_id: user_id
    }
  end

  defp remap_project(%Project{
         document_nr: document_nr,
         name: name,
         start_date: start_date,
         end_date: end_date,
         comment: comment,
         pr_state_id: pr_state_id,
         pr_project_type_id: pr_project_type_id,
         contact_id: contact_id,
         contact_sub_id: contact_sub_id,
         pr_invoice_type: pr_invoice_type,
         pr_invoice_type_amount: pr_invoice_type_amount,
         pr_budget_type: pr_budget_type,
         pr_budget_type_amount: pr_budget_type_amount,
         user_id: user_id
       }) do
    %{
      document_nr: document_nr,
      name: name,
      start_date: to_naive_string(start_date),
      end_date: to_naive_string(end_date),
      comment: comment,
      pr_state_id: pr_state_id,
      pr_project_type_id: pr_project_type_id,
      contact_id: contact_id,
      contact_sub_id: contact_sub_id,
      pr_invoice_type_id: invoice_type_id(pr_invoice_type),
      pr_invoice_type_amount: to_string(pr_invoice_type_amount),
      pr_budget_type_id: budget_type_id(pr_budget_type),
      pr_budget_type_amount: to_string(pr_budget_type_amount),
      user_id: user_id
    }
    |> remove_document_no_if_nil()
  end

  defp map_from_project_states(states, _env), do: Enum.map(states, &map_from_project_state/1)

  defp map_from_project_state(%{"id" => id, "name" => name}, _env \\ nil) do
    %ProjectState{
      id: id,
      name: name
    }
  end

  defp map_from_project_types(types, _env), do: Enum.map(types, &map_from_project_type/1)

  defp map_from_project_type(%{"id" => id, "name" => name}, _env \\ nil) do
    %ProjectType{
      id: id,
      name: name
    }
  end

  defp invoice_type(1), do: :hourly_rate_client_services
  defp invoice_type(2), do: :hourly_rate_employee
  defp invoice_type(3), do: :hourly_rate_project
  defp invoice_type(4), do: :fix_price_project
  defp invoice_type(nil), do: nil
  defp invoice_type(other), do: other

  defp invoice_type_id(:hourly_rate_client_services), do: 1
  defp invoice_type_id(:hourly_rate_employee), do: 2
  defp invoice_type_id(:hourly_rate_project), do: 3
  defp invoice_type_id(:fix_price_project), do: 4
  defp invoice_type_id(nil), do: nil
  defp invoice_type_id(other) when is_integer(other), do: other

  defp budget_type(1), do: :total_budget_costs
  defp budget_type(2), do: :total_budget_hours
  defp budget_type(3), do: :budget_per_client_service
  defp budget_type(4), do: :budget_per_employee
  defp budget_type(nil), do: nil
  defp budget_type(other), do: other

  defp budget_type_id(:total_budget_costs), do: 1
  defp budget_type_id(:total_budget_hours), do: 2
  defp budget_type_id(:budget_per_client_service), do: 3
  defp budget_type_id(:budget_per_employee), do: 4
  defp budget_type_id(nil), do: nil
  defp budget_type_id(other) when is_integer(other), do: other
end
