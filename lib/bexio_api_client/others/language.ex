defmodule BexioApiClient.Others.Language do
  @moduledoc """
  Bexio Language Module.
  """

  @typedoc """
  Bexio Language.
  """
  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          decimal_point: String.t(),
          thousands_separator: String.t(),
          date_format: String.t(),
          date_format_id: :dmy | :mdy,
          iso_639_1: String.t()
        }
  @enforce_keys [:id, :name, :decimal_point, :thousands_separator, :date_format, :date_format_id, :iso_639_1]
  defstruct [:id, :name, :decimal_point, :thousands_separator, :date_format, :date_format_id, :iso_639_1]
end
