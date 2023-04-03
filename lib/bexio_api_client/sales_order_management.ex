defmodule BexioApiClient.SalesOrderManagement do
  @moduledoc """
  Bexio API for the ales order management part of the API.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SalesOrderManagement.PositionSubtotal
  alias BexioApiClient.Contacts.Contact

  @doc """
  This action fetches a list of all subtotal positions for a document.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:document_type` - the document type that has the subtotal positions
    * `:document_id` - the id of the document with the subtotal positions
    * `:limit` - limit the number of results (default: 500, max: 2000)
    * `:offset` - Skip over a number of elements by specifying an offset value for the query

  """
  @spec fetch_subtotal_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          limit :: pos_integer() | nil,
          offset :: non_neg_integer() | nil
        ) :: {:ok, [BexioApiClient.SalesOrderManagement.PositionSubtotal.t()]} | {:error, any()}
  def fetch_subtotal_positions(
        client,
        document_type,
        document_id,
        limit \\ nil,
        offset \\ nil
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_subtotal",
          query: [limit: limit, offset: offset]
        )
      end,
      &map_from_subtotal_positions/1
    )
  end

  @doc """
  This action fetches a single subtotal position for a document.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:document_type` - the document type that has the subtotal positions
    * `:document_id` - the id of the document with the subtotal positions
    * `:position_id` - the id of the position
  """
  @spec fetch_subtotal_position(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, [BexioApiClient.Contacts.Contact.t()]} | {:error, any()}
  def fetch_subtotal_position(
        client,
        document_type,
        document_id,
        position_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_subtotal/#{position_id}")
      end,
      &map_from_subtotal_position/1
    )
  end

  defp map_from_subtotal_positions(subtotal_positions), do: Enum.map(subtotal_positions, &map_from_subtotal_position/1)

  defp map_from_subtotal_position(%{
         "id" => id,
         "text" => text,
         "value" => value,
         "internal_pos" => internal_pos,
         "is_optional" => optional?,
         "parent_id" => parent_id
       }) do
    %PositionSubtotal{
      id: id,
      text: text,
      value: Decimal.new(value),
      internal_pos: internal_pos,
      optional?: optional?,
      parent_id: parent_id
    }
  end
end
