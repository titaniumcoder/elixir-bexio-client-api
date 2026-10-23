defmodule BexioApiClient.Files.FileUsage do
  @moduledoc """
  Bexio File Usage Module.
  """

  @typedoc """
  Bexio File Usage
  """
  @type t :: %__MODULE__{
          id: integer(),
          ref_class:
            :kb_offer
            | :kb_order
            | :kb_invoice
            | :kb_delivery
            | String.t(),
          title: String.t(),
          document_nr: String.t()
        }
  @enforce_keys [:id, :ref_class, :title, :document_nr]
  defstruct [:id, :ref_class, :title, :document_nr]
end
