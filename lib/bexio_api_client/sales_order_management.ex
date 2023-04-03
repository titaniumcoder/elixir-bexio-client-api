defmodule BexioApiClient.SalesOrderManagement do
  @moduledoc """
  Bexio API for the ales order management part of the API.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SalesOrderManagement.PositionPagebreak
  alias BexioApiClient.SalesOrderManagement.PositionDiscount
  alias BexioApiClient.SalesOrderManagement.PositionItem
  alias BexioApiClient.SalesOrderManagement.PositionDefault
  alias BexioApiClient.SalesOrderManagement.PositionText
  alias BexioApiClient.SalesOrderManagement.PositionSubtotal

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
        ) :: {:ok, [BexioApiClient.SalesOrderManagement.PositionSubtotal.t()]} | {:error, any()}
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

  ### Text Position

  @doc """
  This action fetches a list of all text positions for a document.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:document_type` - the document type that has the text positions
    * `:document_id` - the id of the document with the text positions
    * `:limit` - limit the number of results (default: 500, max: 2000)
    * `:offset` - Skip over a number of elements by specifying an offset value for the query

  """
  @spec fetch_text_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          limit :: pos_integer() | nil,
          offset :: non_neg_integer() | nil
        ) :: {:ok, [BexioApiClient.SalesOrderManagement.PositionText.t()]} | {:error, any()}
  def fetch_text_positions(
        client,
        document_type,
        document_id,
        limit \\ nil,
        offset \\ nil
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_text",
          query: [limit: limit, offset: offset]
        )
      end,
      &map_from_text_positions/1
    )
  end

  @doc """
  This action fetches a single text position for a document.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:document_type` - the document type that has the subtotal positions
    * `:document_id` - the id of the document with the subtotal positions
    * `:position_id` - the id of the position
  """
  @spec fetch_text_position(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, [BexioApiClient.SalesOrderManagement.PositionText.t()]} | {:error, any()}
  def fetch_text_position(
        client,
        document_type,
        document_id,
        position_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_text/#{position_id}")
      end,
      &map_from_text_position/1
    )
  end

  defp map_from_text_positions(text_positions), do: Enum.map(text_positions, &map_from_text_position/1)

  defp map_from_text_position(%{
         "id" => id,
         "text" => text,
         "show_pos_nr" => show_pos_nr,
         "pos" => pos,
         "internal_pos" => internal_pos,
         "is_optional" => optional?,
         "parent_id" => parent_id
       }) do
    %PositionText{
      id: id,
      text: text,
      show_pos_nr: show_pos_nr,
      pos: pos,
      internal_pos: internal_pos,
      optional?: optional?,
      parent_id: parent_id
    }
  end

  ### Default Position

  @doc """
  This action fetches a list of all default positions for a document.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:document_type` - the document type that has the text positions
    * `:document_id` - the id of the document with the text positions
    * `:limit` - limit the number of results (default: 500, max: 2000)
    * `:offset` - Skip over a number of elements by specifying an offset value for the query

  """
  @spec fetch_default_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          limit :: pos_integer() | nil,
          offset :: non_neg_integer() | nil
        ) :: {:ok, [BexioApiClient.SalesOrderManagement.PositionDefault.t()]} | {:error, any()}
  def fetch_default_positions(
        client,
        document_type,
        document_id,
        limit \\ nil,
        offset \\ nil
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_custom",
          query: [limit: limit, offset: offset]
        )
      end,
      &map_from_default_positions/1
    )
  end

  @doc """
  This action fetches a single default position for a document.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:document_type` - the document type that has the subtotal positions
    * `:document_id` - the id of the document with the subtotal positions
    * `:position_id` - the id of the position
  """
  @spec fetch_default_position(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, [BexioApiClient.SalesOrderManagement.PositionDefault.t()]} | {:error, any()}
  def fetch_default_position(
        client,
        document_type,
        document_id,
        position_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_custom/#{position_id}")
      end,
      &map_from_default_position/1
    )
  end

  defp map_from_default_positions(default_positions), do: Enum.map(default_positions, &map_from_default_position/1)

  defp map_from_default_position(%{
         "id" => id,
         "amount" => amount,
         "unit_id" => unit_id,
         "account_id" => account_id,
         "unit_name" => unit_name,
         "tax_id" => tax_id,
         "tax_value" => tax_value,
         "text" => text,
         "unit_price" => unit_price,
         "discount_in_percent" => discount_in_percent,
         "position_total" => position_total,
         "pos" => pos,
         "internal_pos" => internal_pos,
         "is_optional" => optional?,
         "parent_id" => parent_id
       }) do
    %PositionDefault{
      id: id,
      amount: Decimal.new(amount),
      unit_id: unit_id,
      account_id: account_id,
      unit_name: unit_name,
      tax_id: tax_id,
      tax_value: Decimal.new(tax_value),
      text: text,
      unit_price: Decimal.new(unit_price),
      discount_in_percent: Decimal.new(discount_in_percent),
      position_total: Decimal.new(position_total),
      pos: pos,
      internal_pos: internal_pos,
      optional?: optional?,
      parent_id: parent_id
    }
  end

  ### Item Position

  @doc """
  This action fetches a list of all item positions for a document.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:document_type` - the document type that has the text positions
    * `:document_id` - the id of the document with the text positions
    * `:limit` - limit the number of results (default: 500, max: 2000)
    * `:offset` - Skip over a number of elements by specifying an offset value for the query

  """
  @spec fetch_item_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          limit :: pos_integer() | nil,
          offset :: non_neg_integer() | nil
        ) :: {:ok, [BexioApiClient.SalesOrderManagement.PositionItem.t()]} | {:error, any()}
  def fetch_item_positions(
        client,
        document_type,
        document_id,
        limit \\ nil,
        offset \\ nil
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_article",
          query: [limit: limit, offset: offset]
        )
      end,
      &map_from_item_positions/1
    )
  end

  @doc """
  This action fetches a single item position for a document.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:document_type` - the document type that has the subtotal positions
    * `:document_id` - the id of the document with the subtotal positions
    * `:position_id` - the id of the position
  """
  @spec fetch_item_position(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, [BexioApiClient.SalesOrderManagement.PositionItem.t()]} | {:error, any()}
  def fetch_item_position(
        client,
        document_type,
        document_id,
        position_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_article/#{position_id}")
      end,
      &map_from_item_position/1
    )
  end

  defp map_from_item_positions(item_positions), do: Enum.map(item_positions, &map_from_item_position/1)

  defp map_from_item_position(%{
         "id" => id,
         "amount" => amount,
         "unit_id" => unit_id,
         "account_id" => account_id,
         "unit_name" => unit_name,
         "tax_id" => tax_id,
         "tax_value" => tax_value,
         "text" => text,
         "unit_price" => unit_price,
         "discount_in_percent" => discount_in_percent,
         "position_total" => position_total,
         "pos" => pos,
         "internal_pos" => internal_pos,
         "is_optional" => optional?,
         "article_id" => article_id,
         "parent_id" => parent_id
       }) do
    %PositionItem{
      id: id,
      amount: Decimal.new(amount),
      unit_id: unit_id,
      account_id: account_id,
      unit_name: unit_name,
      tax_id: tax_id,
      tax_value: Decimal.new(tax_value),
      text: text,
      unit_price: Decimal.new(unit_price),
      discount_in_percent: Decimal.new(discount_in_percent),
      position_total: Decimal.new(position_total),
      pos: pos,
      internal_pos: internal_pos,
      optional?: optional?,
      article_id: article_id,
      parent_id: parent_id
    }
  end

  ### Discount Position

  @doc """
  This action fetches a list of all discount positions for a document.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:document_type` - the document type that has the text positions
    * `:document_id` - the id of the document with the text positions
    * `:limit` - limit the number of results (default: 500, max: 2000)
    * `:offset` - Skip over a number of elements by specifying an offset value for the query

  """
  @spec fetch_discount_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          limit :: pos_integer() | nil,
          offset :: non_neg_integer() | nil
        ) :: {:ok, [BexioApiClient.SalesOrderManagement.PositionDiscount.t()]} | {:error, any()}
  def fetch_discount_positions(
        client,
        document_type,
        document_id,
        limit \\ nil,
        offset \\ nil
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_discount",
          query: [limit: limit, offset: offset]
        )
      end,
      &map_from_discount_positions/1
    )
  end

  @doc """
  This action fetches a single discount position for a document.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:document_type` - the document type that has the subtotal positions
    * `:document_id` - the id of the document with the subtotal positions
    * `:position_id` - the id of the position
  """
  @spec fetch_discount_position(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, [BexioApiClient.SalesOrderManagement.PositionDiscount.t()]} | {:error, any()}
  def fetch_discount_position(
        client,
        document_type,
        document_id,
        position_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_discount/#{position_id}")
      end,
      &map_from_discount_position/1
    )
  end

  defp map_from_discount_positions(discount_positions), do: Enum.map(discount_positions, &map_from_discount_position/1)

  defp map_from_discount_position(%{
         "id" => id,
         "text" => text,
         "value" => value,
         "discount_total" => discount_total,
         "is_percentual" => percentual?
       }) do
    %PositionDiscount{
      id: id,
      text: text,
      value: Decimal.new(value),
      discount_total: Decimal.new(discount_total),
      percentual?: percentual?,
    }
  end

  ### Pagebreak Position

  @doc """
  This action fetches a list of all pagebreak positions for a document.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:document_type` - the document type that has the text positions
    * `:document_id` - the id of the document with the text positions
    * `:limit` - limit the number of results (default: 500, max: 2000)
    * `:offset` - Skip over a number of elements by specifying an offset value for the query

  """
  @spec fetch_pagebreak_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          limit :: pos_integer() | nil,
          offset :: non_neg_integer() | nil
        ) :: {:ok, [BexioApiClient.SalesOrderManagement.PositionPagebreak.t()]} | {:error, any()}
  def fetch_pagebreak_positions(
        client,
        document_type,
        document_id,
        limit \\ nil,
        offset \\ nil
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_pagebreak",
          query: [limit: limit, offset: offset]
        )
      end,
      &map_from_pagebreak_positions/1
    )
  end

  @doc """
  This action fetches a single pagebreak position for a document.

  ## Arguments:

    * `:client` - client to execute the HTTP request with
    * `:document_type` - the document type that has the subtotal positions
    * `:document_id` - the id of the document with the subtotal positions
    * `:position_id` - the id of the position
  """
  @spec fetch_pagebreak_position(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, [BexioApiClient.SalesOrderManagement.PositionPagebreak.t()]} | {:error, any()}
  def fetch_pagebreak_position(
        client,
        document_type,
        document_id,
        position_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_pagebreak/#{position_id}")
      end,
      &map_from_pagebreak_position/1
    )
  end

  defp map_from_pagebreak_positions(pagebreak_positions), do: Enum.map(pagebreak_positions, &map_from_pagebreak_position/1)

  defp map_from_pagebreak_position(%{
         "id" => id,
         "internal_pos" => internal_pos,
         "is_optional" => optional?,
         "parent_id" => parent_id
       }) do
    %PositionPagebreak{
      id: id,
      internal_pos: internal_pos,
      optional?: optional?,
      parent_id: parent_id
    }
  end
end
