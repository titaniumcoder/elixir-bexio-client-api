defmodule BexioApiClient.Items do
  @moduledoc """
  Bexio API for the items & products part of the API
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria

  alias BexioApiClient.Items.Item

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @doc """
  Fetch a list of items.
  """
  @spec fetch_items(
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Item.t()]} | {:error, any()}
  def fetch_items(client, opts \\ []) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/article", query: opts_to_query(opts))
      end,
      &map_from_articles/2
    )
  end

  @doc """
  Search items via query.
  The following search fields are supported:

  * intern_name
  * intern_code
  """
  @spec search_items(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Item.t()]} | {:error, any()}
  def search_items(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(
          client,
          "/2.0/article/search",
          criteria,
          query: opts_to_query(opts)
        )
      end,
      &map_from_articles/2
    )
  end

  @doc """
  Fetch single item.
  """
  @spec fetch_item(
          client :: Tesla.Client.t(),
          id :: non_neg_integer()
        ) :: {:ok, Item.t()} | {:error, any()}
  def fetch_item(client, id) do
    bexio_body_handling(
      fn ->
        Tesla.get(
          client,
          "/2.0/article/#{id}"
        )
      end,
      &map_from_article/2
    )
  end

  @doc """
  Create an item.
  """
  @spec create_item(
          client :: Tesla.Client.t(),
          item :: Item.t()
        ) :: {:ok, Item.t()} | {:error, any()}
  def create_item(client, item) do
    bexio_body_handling(
      fn ->
        Tesla.post(client, "/2.0/article", remap_item(item))
      end,
      &map_from_article/2
    )
  end

  @doc """
  Edit an item.
  """
  @spec edit_item(
          client :: Tesla.Client.t(),
          item :: Item.t()
        ) :: {:ok, Item.t()} | {:error, any()}
  def edit_item(client, item) do
    bexio_body_handling(
      fn ->
        Tesla.post(client, "/2.0/article/#{item.id}", remap_edit_item(item))
      end,
      &map_from_article/2
    )
  end

  @doc """
  Delete an order.
  """
  @spec delete_item(
          client :: Tesla.Client.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | {:error, any()}
  def delete_item(client, id) do
    bexio_body_handling(
      fn ->
        Tesla.delete(client, "/2.0/article/#{id}")
      end,
      &success_response/2
    )
  end

  defp map_from_articles(articles, _env), do: Enum.map(articles, &map_from_article/1)

  defp map_from_article(
         %{
           "id" => id,
           "user_id" => user_id,
           "article_type_id" => article_type_id,
           "contact_id" => contact_id,
           "deliverer_code" => deliverer_code,
           "deliverer_name" => deliverer_name,
           "deliverer_description" => deliverer_description,
           "intern_code" => intern_code,
           "intern_name" => intern_name,
           "intern_description" => intern_description,
           "purchase_price" => purchase_price,
           "sale_price" => sale_price,
           "purchase_total" => purchase_total,
           "sale_total" => sale_total,
           "currency_id" => currency_id,
           "tax_income_id" => tax_income_id,
           "tax_id" => tax_id,
           "tax_expense_id" => tax_expense_id,
           "unit_id" => unit_id,
           "is_stock" => stock?,
           "stock_id" => stock_id,
           "stock_place_id" => stock_place_id,
           "stock_nr" => stock_nr,
           "stock_min_nr" => stock_min_nr,
           "stock_reserved_nr" => stock_reserved_nr,
           "stock_available_nr" => stock_available_nr,
           "stock_picked_nr" => stock_picked_nr,
           "stock_disposed_nr" => stock_disposed_nr,
           "stock_ordered_nr" => stock_ordered_nr,
           "width" => width,
           "height" => height,
           "weight" => weight,
           "volume" => volume,
           "remarks" => remarks,
           "delivery_price" => delivery_price,
           "article_group_id" => article_group_id
         },
         _env \\ nil
       ) do
    %Item{
      id: id,
      user_id: user_id,
      article_type: article_type(article_type_id),
      contact_id: contact_id,
      deliverer_code: deliverer_code,
      deliverer_name: deliverer_name,
      deliverer_description: deliverer_description,
      intern_code: intern_code,
      intern_name: intern_name,
      intern_description: intern_description,
      purchase_price: to_decimal(purchase_price),
      sale_price: to_decimal(sale_price),
      purchase_total: to_decimal(purchase_total),
      sale_total: to_decimal(sale_total),
      currency_id: currency_id,
      tax_income_id: tax_income_id,
      tax_id: tax_id,
      tax_expense_id: tax_expense_id,
      unit_id: unit_id,
      stock?: stock?,
      stock_id: stock_id,
      stock_place_id: stock_place_id,
      stock_nr: stock_nr,
      stock_min_nr: stock_min_nr,
      stock_reserved_nr: stock_reserved_nr,
      stock_available_nr: stock_available_nr,
      stock_picked_nr: stock_picked_nr,
      stock_disposed_nr: stock_disposed_nr,
      stock_ordered_nr: stock_ordered_nr,
      width: width,
      height: height,
      weight: weight,
      volume: volume,
      remarks: remarks,
      delivery_price: to_decimal(delivery_price),
      article_group_id: article_group_id
    }
  end

  defp article_type(1), do: :physical
  defp article_type(2), do: :service

  defp remap_item(
         %Item{
           article_type: article_type,
           stock_nr: stock_nr
         } = item
       ) do
    item
    |> remap_edit_item()
    |> Map.put(:article_type_id, article_type_id(article_type))
    |> Map.put(:stock_nr, stock_nr)
  end

  defp remap_edit_item(%Item{
         user_id: user_id,
         contact_id: contact_id,
         deliverer_code: deliverer_code,
         deliverer_name: deliverer_name,
         deliverer_description: deliverer_description,
         intern_code: intern_code,
         intern_name: intern_name,
         intern_description: intern_description,
         purchase_price: purchase_price,
         sale_price: sale_price,
         purchase_total: purchase_total,
         sale_total: sale_total,
         currency_id: currency_id,
         tax_income_id: tax_income_id,
         tax_expense_id: tax_expense_id,
         unit_id: unit_id,
         stock?: stock?,
         stock_id: stock_id,
         stock_place_id: stock_place_id,
         stock_min_nr: stock_min_nr,
         width: width,
         height: height,
         volume: volume,
         remarks: remarks,
         delivery_price: delivery_price,
         article_group_id: article_group_id
       }) do
    %{
      user_id: user_id,
      contact_id: contact_id,
      deliverer_code: deliverer_code,
      deliverer_name: deliverer_name,
      deliverer_description: deliverer_description,
      intern_code: intern_code,
      intern_name: intern_name,
      intern_description: intern_description,
      purchase_price: to_string(purchase_price),
      sale_price: to_string(sale_price),
      purchase_total: to_string(purchase_total),
      sale_total: to_string(sale_total),
      currency_id: currency_id,
      tax_income_id: tax_income_id,
      tax_expense_id: tax_expense_id,
      unit_id: unit_id,
      is_stock: stock?,
      stock_id: stock_id,
      stock_place_id: stock_place_id,
      stock_min_nr: stock_min_nr,
      width: width,
      height: height,
      volume: volume,
      remarks: remarks,
      delivery_price: delivery_price,
      article_group_id: article_group_id
    }
  end

  defp article_type_id(:physical), do: 1
  defp article_type_id(:service), do: 2

  @doc """
  Fetch a list of stock locations.
  """
  @spec fetch_stock_locations(
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | {:error, any()}
  def fetch_stock_locations(client, opts \\ []) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/stock", query: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  Search sock locations via query.
  The following search fields are supported:

  * name
  """
  @spec search_stock_locations(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | {:error, any()}
  def search_stock_locations(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(
          client,
          "/2.0/stock/search",
          criteria,
          query: opts_to_query(opts)
        )
      end,
      &body_to_map/2
    )
  end

  @doc """
  Fetch a list of stock areas.
  """
  @spec fetch_stock_areas(
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | {:error, any()}
  def fetch_stock_areas(client, opts \\ []) do
    bexio_body_handling(
      fn ->
        Tesla.get(client, "/2.0/stock_place", query: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  Search sock areas via query.
  The following search fields are supported:

  * name
  * stock_id
  """
  @spec search_stock_areas(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, %{integer() => String.t()}} | {:error, any()}
  def search_stock_areas(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Tesla.post(
          client,
          "/2.0/stock_place/search",
          criteria,
          query: opts_to_query(opts)
        )
      end,
      &body_to_map/2
    )
  end
end
