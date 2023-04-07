defmodule BexioApiClient.GlobalArguments do
  @moduledoc """
  Typespec and helpers for global usable arguments
  """

  @type offset_without_order_by_arg :: {:limit, pos_integer()} | {:offset, non_neg_integer}
  @type offset_arg :: {:order_by, atom()} | offset_without_order_by_arg()
  @type paging_arg ::
          {:limit, pos_integer()}
          | {:page, non_neg_integer}
          | {:order, list(:asc | :desc) | {:sort, list(:atom)}}

  @spec opts_to_query([offset_without_order_by_arg() | offset_arg | paging_arg()]) :: keyword()
  def opts_to_query(opts) do
    [:limit, :offset, :order_by, :order, :sort, :page]
    |> Enum.map(fn name -> {name, Keyword.get(opts, name)} end)
    |> Enum.filter(fn {_, v} -> v != nil end)
  end
end
