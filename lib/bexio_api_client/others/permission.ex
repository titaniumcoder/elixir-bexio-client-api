defmodule BexioApiClient.Others.Permission do
  @moduledoc """
  Bexio Permission Module.
  """

  @typedoc """
  Bexio Permission.
  """
  @type t :: %__MODULE__{
          components: list(String.t()),
          # keys are atoms for the documented components (accounting_reports, admin,
          # analytics, article, ...); unknown components are kept as string keys.
          # values are `:enabled | :disabled` for `:activation` and the documented
          # `:all | :own | :none` scopes, unknown scopes are kept as strings.
          permissions: %{
            optional(atom() | String.t()) => %{
              optional(atom() | String.t()) => atom() | String.t()
            }
          }
        }
  @enforce_keys [:components, :permissions]
  defstruct [:components, :permissions]
end
