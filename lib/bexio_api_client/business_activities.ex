defmodule BexioApiClient.BusinessActivities do
  @moduledoc """
  Bexio API for the business activities, communication types and client services
  part of the API.

  The business activities (client service) endpoints implement the operations the
  bexio docs group under "Business Activities" (`/2.0/client_service`, operationIds
  `v2ListBusinessActivities`, `v2CreateBusinessActivity`, `v2SearchBusinessActivities`).
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria

  alias BexioApiClient.BusinessActivities.{
    BusinessActivity,
    CommunicationType
  }

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @type api_error_type :: BexioApiClient.Helpers.api_error_type()

  @doc """
  Fetch a list of business activities (client services).
  """
  @spec fetch_business_activities(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [BusinessActivity.t()]} | api_error_type()
  def fetch_business_activities(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/client_service", params: opts_to_query(opts))
      end,
      &map_from_business_activities/2
    )
  end

  @doc """
  Search business activities (client services) via query.

  Following fields are supported:

  * `name`
  """
  @spec search_business_activities(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [BusinessActivity.t()]} | api_error_type()
  def search_business_activities(req, criteria, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.post(req,
          url: "/2.0/client_service/search",
          json: criteria,
          params: opts_to_query(opts)
        )
      end,
      &map_from_business_activities/2
    )
  end

  @doc """
  Create a business activity (client service).
  """
  @spec create_business_activity(
          req :: Req.Request.t(),
          business_activity :: BusinessActivity.t()
        ) ::
          {:ok, BusinessActivity.t()} | api_error_type()
  def create_business_activity(req, business_activity) do
    bexio_body_handling(
      fn ->
        Req.post(req,
          url: "/2.0/client_service",
          json: remap_business_activity(business_activity)
        )
      end,
      &map_from_business_activity/2
    )
  end

  @doc """
  Fetch a list of communication types.
  """
  @spec fetch_communication_types(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [CommunicationType.t()]} | api_error_type()
  def fetch_communication_types(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/communication_kind", params: opts_to_query(opts))
      end,
      &map_from_communication_types/2
    )
  end

  @doc """
  Search communication types via query.

  Following fields are supported:

  * `name`
  """
  @spec search_communication_types(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [CommunicationType.t()]} | api_error_type()
  def search_communication_types(req, criteria, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.post(req,
          url: "/2.0/communication_kind/search",
          json: criteria,
          params: opts_to_query(opts)
        )
      end,
      &map_from_communication_types/2
    )
  end

  defp remap_business_activity(%BusinessActivity{} = business_activity) do
    business_activity
    |> Map.take([:name, :default_price_per_hour, :account_id])
    |> Map.put(:default_is_billable, business_activity.default_billable?)
    |> Map.update(:default_price_per_hour, nil, fn
      nil -> nil
      %Decimal{} = price -> Decimal.to_string(price, :normal)
    end)
  end

  defp map_from_business_activities(business_activities, _env),
    do: Enum.map(business_activities, &map_from_business_activity/1)

  defp map_from_business_activity(
         %{"id" => id, "name" => name} = business_activity,
         _env \\ nil
       ) do
    %BusinessActivity{
      id: id,
      name: name,
      default_billable?: Map.get(business_activity, "default_is_billable"),
      default_price_per_hour:
        to_decimal_or_nil(Map.get(business_activity, "default_price_per_hour")),
      account_id: Map.get(business_activity, "account_id")
    }
  end

  defp map_from_communication_types(communication_types, _env),
    do: Enum.map(communication_types, &map_from_communication_type/1)

  defp map_from_communication_type(
         %{"id" => id, "name" => name},
         _env \\ nil
       ) do
    %CommunicationType{
      id: id,
      name: name
    }
  end

  defp to_decimal_or_nil(nil), do: nil
  defp to_decimal_or_nil(value) when is_float(value), do: Decimal.from_float(value)
  defp to_decimal_or_nil(value), do: to_decimal(value)
end
