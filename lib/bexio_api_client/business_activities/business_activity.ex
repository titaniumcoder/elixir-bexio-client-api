defmodule BexioApiClient.BusinessActivities.BusinessActivity do
  @moduledoc """
  Bexio Business Activity (client service) Module.
  """

  @typedoc """
  Bexio Business Activity (client service).

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:name` - name of the business activity
    * `:default_billable?` - whether entries with this activity are billable by default (bexio's `default_is_billable`)
    * `:default_price_per_hour` - default price per hour
    * `:account_id` - references an account object
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          default_billable?: boolean() | nil,
          default_price_per_hour: Decimal.t() | nil,
          account_id: integer() | nil
        }
  @enforce_keys [:name]
  defstruct [:id, :name, :default_billable?, :default_price_per_hour, :account_id]

  @doc """
  Create a new record.
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        name: "",
        default_billable?: false,
        default_price_per_hour: nil,
        account_id: nil
      },
      attrs
    )
  end
end
