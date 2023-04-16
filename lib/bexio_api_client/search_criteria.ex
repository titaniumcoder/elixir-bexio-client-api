defmodule BexioApiClient.SearchCriteria do
  @moduledoc """
  Some older endpoints implement search methods.
  Searching for these endpoint works by sending a POST
  request to the resource (e.g.: POST /contact/search
  or POST /country/search). The search parameters must
  be provided in the body of the POST request.
  """

  @typedoc """
  One search criteria argument

  ## Fields:

    * `:name` - The name of the parameter to look up
    * `:criteria` - the criteria to fulfill
    * `:value` - the value to search for
  """
  @type t :: %__MODULE__{
          field: atom(),
          criteria:
            :equal
            | :=
            | :!=
            | :not_equal
            | :>
            | :greater_than
            | :<
            | :less_than
            | :>=
            | :greater_equal
            | :<=
            | :less_equal
            | :like
            | :not_like
            | :is_null
            | :not_null
            | :in
            | :not_in,
          value: any() | nil
        }
  @enforce_keys [
    :field,
    :criteria,
    :value
  ]
  @derive Jason.Encoder
  defstruct [:field, :criteria, :value]

  defp new(field, criteria, value) do
    %__MODULE__{
      field: field,
      criteria: criteria,
      value: value
    }
  end

  @doc "Creates a = search criteria"
  @spec equal(atom(), any()) :: t()
  def equal(field, value), do: new(field, :=, value)
  @doc "Creates a != search criteria"
  @spec not_equal(atom(), any()) :: t()
  def not_equal(field, value), do: new(field, :!=, value)
  @doc "Creates a > search criteria"
  @spec greater_than(atom(), any()) :: t()
  def greater_than(field, value), do: new(field, :>, value)
  @doc "Creates a < search criteria"
  @spec less_than(atom(), any()) :: t()
  def less_than(field, value), do: new(field, :<, value)
  @doc "Creates a >= search criteria"
  @spec greater_equal(atom(), any()) :: t()
  def greater_equal(field, value), do: new(field, :>=, value)
  @doc "Creates a <= search criteria"
  @spec less_equal(atom(), any()) :: t()
  def less_equal(field, value), do: new(field, :<=, value)
  @doc "Creates a like search criteria"
  @spec like(atom(), any()) :: t()
  def like(field, value), do: new(field, :like, value)
  @doc "Creates a not_like search criteria"
  @spec not_like(atom(), any()) :: t()
  def not_like(field, value), do: new(field, :not_like, value)
  @doc "Creates a in search criteria"
  @spec part_of(atom(), list()) :: t()
  def part_of(field, value), do: new(field, :in, value)
  @doc "Creates a not_in search criteria"
  @spec not_part_of(atom(), list()) :: t()
  def not_part_of(field, value), do: new(field, :not_in, value)
  @doc "Creates a is_null search criteria"
  @spec nil?(atom()) :: t()
  def nil?(field), do: new(field, :is_null, nil)
  @doc "Creates a not_null search criteria"
  @spec not_nil?(atom()) :: t()
  def not_nil?(field), do: new(field, :not_null, nil)
end
