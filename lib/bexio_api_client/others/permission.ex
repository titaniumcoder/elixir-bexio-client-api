defmodule BexioApiClient.Others.Permission do
  @moduledoc """
  Bexio Permission Module.
  """

  @typedoc """
  Bexio Permission.
  """
  @type t :: %__MODULE__{
          components: list(String.t()),
          permissions: %{
            optional(:accounting_reports) => %{:activation => :enabled | :disabled},
            optional(:admin) => %{:activation => :enabled | :disabled},
            optional(:analytics) => %{:activation => :enabled | :disabled},
            optional(:article) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:banking) => %{:activation => :enabled | :disabled, :edit => :all | :none},
            optional(:banking_direct) => %{:activation => :enabled | :disabled},
            optional(:banking_sync) => %{:activation => :enabled | :disabled},
            optional(:bill_administration) => %{:activation => :enabled | :disabled},
            optional(:contact) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:dashboard_widget_sales) => %{:activation => :enabled | :disabled},
            optional(:expense) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:fm) => %{:activation => :enabled | :disabled},
            optional(:history) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:kb_account_statement) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:kb_article_order) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:kb_bill) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:kb_credit_voucher) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:kb_delivery) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:kb_offer) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:kb_order) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:kb_invoice) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:kb_wizard_recurring_invoices) => %{:activation => :enabled | :disabled},
            optional(:kb_wizard_reminder) => %{:activation => :enabled | :disabled},
            optional(:mailchimp) => %{:activation => :enabled | :disabled},
            optional(:mailxpert) => %{:activation => :enabled | :disabled},
            optional(:monitoring) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:pingen) => %{:activation => :enabled | :disabled},
            optional(:project) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:project_show_conditions) => %{:activation => :enabled | :disabled},
            optional(:stockmanagement) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:stockmanagement_changes) => %{:activation => :enabled | :disabled},
            optional(:todo) => %{
              :activation => :enabled | :disabled,
              :edit => :all | :own | :none,
              :view => :all | :own
            },
            optional(:user_administration) => %{:activation => :enabled | :disabled}
          }
        }
  @enforce_keys [:components, :permissions]
  defstruct [:components, :permissions]
end
