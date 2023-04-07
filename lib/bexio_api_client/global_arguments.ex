defmodule BexioApiClient.GlobalArguments do
  @moduledoc """
  Typespec and helpers for global usable arguments
  """

  @type offset_arg :: {:limit, pos_integer()} | {:offset, non_neg_integer} | {:order_by, atom()}
  @type paging_arg :: {:limit, pos_integer()} | {:page, non_neg_integer} | {:order_by, atom()}

  @spec opts_to_query([offset_arg()]) :: [limit: pos_integer(), offset: non_neg_integer(), order_by: :atom]
  def opts_to_query(opts) do
    limit = Keyword.get(opts, :limit)
    offset = Keyword.get(opts, :offset)
    order_by = Keyword.get(opts, :order_by)

    [limit: limit, offset: offset, order_by: order_by]
  end


end
