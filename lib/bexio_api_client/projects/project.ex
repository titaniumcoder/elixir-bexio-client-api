defmodule BexioApiClient.Projects.Project do
  @moduledoc """
  Bexio Project Module.
  """

  @typedoc """
  Bexio Project

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:document_nr` - can not be used if "automatic numbering" is activated in the
      frontend settings, required if it is deactivated (only used for create/edit)
    * `:uuid` - the uuid of the project
    * `:nr` - the project number
    * `:name` - the name of the project
    * `:start_date` - the start date of the project
    * `:end_date` - the end date of the project
    * `:comment` - a comment
    * `:pr_state_id` - references a project status object
    * `:pr_project_type_id` - references a project type object
    * `:contact_id` - references a contact object
    * `:contact_sub_id` - references a contact object
    * `:pr_invoice_type` - `:hourly_rate_client_services` (bexio's 1), `:hourly_rate_employee`
      (2), `:hourly_rate_project` (3) or `:fix_price_project` (4)
    * `:pr_invoice_type_amount` - only editable if `:pr_invoice_type` is set and
      only supported for invoice types `:hourly_rate_project` and `:fix_price_project`
    * `:pr_budget_type` - `:total_budget_costs` (bexio's 1), `:total_budget_hours` (2),
      `:budget_per_client_service` (3) or `:budget_per_employee` (4)
    * `:pr_budget_type_amount` - only editable if `:pr_budget_type` is set and
      only supported for budget types `:total_budget_costs` and `:total_budget_hours`
    * `:user_id` - references a user object
  """
  @type t :: %__MODULE__{
          id: integer() | nil,
          document_nr: String.t() | nil,
          uuid: String.t() | nil,
          nr: String.t() | nil,
          name: String.t() | nil,
          start_date: NaiveDateTime.t() | nil,
          end_date: NaiveDateTime.t() | nil,
          comment: String.t() | nil,
          pr_state_id: integer() | nil,
          pr_project_type_id: integer() | nil,
          contact_id: integer() | nil,
          contact_sub_id: integer() | nil,
          pr_invoice_type:
            :hourly_rate_client_services
            | :hourly_rate_employee
            | :hourly_rate_project
            | :fix_price_project
            # undocumented values are kept as integers
            | integer()
            | nil,
          pr_invoice_type_amount: Decimal.t() | nil,
          pr_budget_type:
            :total_budget_costs
            | :total_budget_hours
            | :budget_per_client_service
            | :budget_per_employee
            # undocumented values are kept as integers
            | integer()
            | nil,
          pr_budget_type_amount: Decimal.t() | nil,
          user_id: integer() | nil
        }
  @enforce_keys [
    :id,
    :uuid,
    :nr,
    :name,
    :pr_state_id,
    :pr_project_type_id,
    :contact_id,
    :user_id
  ]
  defstruct [
    :id,
    :document_nr,
    :uuid,
    :nr,
    :name,
    :start_date,
    :end_date,
    :comment,
    :pr_state_id,
    :pr_project_type_id,
    :contact_id,
    :contact_sub_id,
    :pr_invoice_type,
    :pr_invoice_type_amount,
    :pr_budget_type,
    :pr_budget_type_amount,
    :user_id
  ]

  @doc """
  Create a new project
  """
  @spec new(map()) :: __MODULE__.t()
  def new(attrs \\ %{}) do
    Map.merge(
      %__MODULE__{
        id: nil,
        document_nr: nil,
        uuid: nil,
        nr: nil,
        name: nil,
        start_date: nil,
        end_date: nil,
        comment: "",
        pr_state_id: nil,
        pr_project_type_id: nil,
        contact_id: nil,
        contact_sub_id: nil,
        pr_invoice_type: nil,
        pr_invoice_type_amount: nil,
        pr_budget_type: nil,
        pr_budget_type_amount: nil,
        user_id: nil
      },
      attrs
    )
  end
end
