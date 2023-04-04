defmodule BexioApiClient.Global.Paging do
  @moduledoc """
  Paging part of the response
  """

  @type t :: %__MODULE__{
          page: non_neg_integer(),
          page_size: non_neg_integer(),
          page_count: non_neg_integer(),
          item_count: non_neg_integer()
        }
  @enforce_keys [
    :page,
    :page_size,
    :page_count,
    :item_count
  ]
  defstruct [
    :page,
    :page_size,
    :page_count,
    :item_count
  ]
end
