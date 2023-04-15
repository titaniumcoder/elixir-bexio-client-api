defmodule BexioApiClient.SalesOrderManagement do
  @moduledoc """
  Bexio API for the sales order management part of the API.
  """

  import BexioApiClient.Helpers

  alias BexioApiClient.GlobalArguments
  alias BexioApiClient.SearchCriteria

  alias BexioApiClient.SalesOrderManagement.{
    Comment,
    Order,
    Quote,
    PositionSubposition,
    PositionPagebreak,
    PositionDiscount,
    PositionItem,
    PositionDefault,
    PositionText,
    PositionSubtotal
  }

  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  # Quotes

  @doc """
  This action fetches a list of all quotes.
  """
  @spec fetch_quotes(
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Quote.t()]} | {:error, any()}
  def fetch_quotes(client, opts \\ []) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_offer", query: opts_to_query(opts))
      end,
      &map_from_quotes/1
    )
  end

  @doc """
  Search quotes via query.
  The following search fields are supported:

  * id
  * kb_item_status
  * document_nr
  * title
  * contact_id
  * contact_sub_id
  * user_id
  * currency_id
  * total_gross
  * total_net
  * total
  * is_valid_from
  * is_valid_until
  * is_valid_to (?)
  * updated_at
  """
  @spec search_quotes(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Quote.t()]} | {:error, any()}
  def search_quotes(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_return_handling(
      fn ->
        Tesla.post(client, "/2.0/kb_offer/search", criteria, query: opts_to_query(opts))
      end,
      &map_from_quotes/1
    )
  end

  @doc """
  This action fetches a single quote
  """
  @spec fetch_quote(
          client :: Tesla.Client.t(),
          quote_id :: pos_integer()
        ) :: {:ok, [Quote.t()]} | {:error, any()}
  def fetch_quote(client, quote_id) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_offer/#{quote_id}")
      end,
      &map_from_quote/1
    )
  end

  defp map_from_quotes(quotes), do: Enum.map(quotes, &map_from_quote/1)

  defp map_from_quote(%{
         "id" => id,
         "document_nr" => document_nr,
         "title" => title,
         "contact_id" => contact_id,
         "contact_sub_id" => contact_sub_id,
         "user_id" => user_id,
         "project_id" => project_id,
         "language_id" => language_id,
         "bank_account_id" => bank_account_id,
         "currency_id" => currency_id,
         "payment_type_id" => payment_type_id,
         "header" => header,
         "footer" => footer,
         "total_gross" => total_gross,
         "total_net" => total_net,
         "total_taxes" => total_taxes,
         "total" => total,
         "total_rounding_difference" => total_rounding_difference,
         "mwst_type" => mwst_type_id,
         "mwst_is_net" => mwst_is_net?,
         "show_position_taxes" => show_position_taxes?,
         "is_valid_from" => is_valid_from,
         "is_valid_until" => is_valid_until,
         "contact_address" => contact_address,
         "delivery_address_type" => delivery_address_type,
         "delivery_address" => delivery_address,
         "kb_item_status_id" => kb_item_status_id,
         "api_reference" => api_reference,
         "viewed_by_client_at" => viewed_by_client_at,
         "kb_terms_of_payment_template_id" => kb_terms_of_payment_template_id,
         "show_total" => show_total?,
         "updated_at" => updated_at,
         "template_slug" => template_slug,
         "taxs" => taxs,
         "network_link" => network_link
       }) do
    %Quote{
      id: id,
      document_nr: document_nr,
      title: title,
      contact_id: contact_id,
      contact_sub_id: contact_sub_id,
      user_id: user_id,
      project_id: project_id,
      language_id: language_id,
      bank_account_id: bank_account_id,
      currency_id: currency_id,
      payment_type_id: payment_type_id,
      header: header,
      footer: footer,
      total_gross: to_decimal(total_gross),
      total_net: to_decimal(total_net),
      total_taxes: to_decimal(total_taxes),
      total: to_decimal(total),
      total_rounding_difference: total_rounding_difference,
      mwst_type: mwst_type(mwst_type_id),
      mwst_is_net?: mwst_is_net?,
      show_position_taxes?: show_position_taxes?,
      is_valid_from: to_date(is_valid_from),
      is_valid_until: to_date(is_valid_until),
      contact_address: contact_address,
      delivery_address_type: delivery_address_type,
      delivery_address: delivery_address,
      kb_item_status: kb_item_status(kb_item_status_id),
      api_reference: api_reference,
      viewed_by_client_at: to_datetime(viewed_by_client_at),
      kb_terms_of_payment_template_id: kb_terms_of_payment_template_id,
      show_total?: show_total?,
      updated_at: to_datetime(updated_at),
      template_slug: template_slug,
      taxs: Enum.map(taxs, &to_tax/1),
      network_link: network_link
    }
  end

  defp mwst_type(0), do: :including
  defp mwst_type(1), do: :excluding
  defp mwst_type(2), do: :exempt

  defp kb_item_status(1), do: :draft
  defp kb_item_status(2), do: :pending
  defp kb_item_status(3), do: :confirmed
  defp kb_item_status(4), do: :declined

  defp kb_item_status_id(:draft), do: 1
  defp kb_item_status_id(:pending), do: 2
  defp kb_item_status_id(:confirmed), do: 3
  defp kb_item_status_id(:declined), do: 4

  defp to_tax(%{"percentage" => percentage, "value" => value}),
    do: %{percentage: percentage, value: value}

  # Orders

  @doc """
  This action fetches a list of all orders.
  """
  @spec fetch_orders(
          client :: Tesla.Client.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Order.t()]} | {:error, any()}
  def fetch_orders(client, opts \\ []) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_order", query: opts_to_query(opts))
      end,
      &map_from_orders/1
    )
  end

  @doc """
  Search orders via query.
  The following search fields are supported:

  * id
  * kb_item_status
  * document_nr
  * title
  * contact_id
  * contact_sub_id
  * user_id
  * currency_id
  * total_gross
  * total_net
  * total
  * is_valid_from
  * updated_at
  """
  @spec search_orders(
          client :: Tesla.Client.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Order.t()]} | {:error, any()}
  def search_orders(
        client,
        criteria,
        opts \\ []
      ) do
    bexio_return_handling(
      fn ->
        Tesla.post(client, "/2.0/kb_order/search", criteria, query: opts_to_query(opts))
      end,
      &map_from_orders/1
    )
  end

  @doc """
  This action fetches a single order
  """
  @spec fetch_order(
          client :: Tesla.Client.t(),
          order_id :: pos_integer()
        ) :: {:ok, [Order.t()]} | {:error, any()}
  def fetch_order(client, order_id) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_order/#{order_id}")
      end,
      &map_from_order/1
    )
  end

  defp map_from_orders(orders), do: Enum.map(orders, &map_from_order/1)

  defp map_from_order(%{
         "id" => id,
         "document_nr" => document_nr,
         "title" => title,
         "contact_id" => contact_id,
         "contact_sub_id" => contact_sub_id,
         "user_id" => user_id,
         "project_id" => project_id,
         "language_id" => language_id,
         "bank_account_id" => bank_account_id,
         "currency_id" => currency_id,
         "payment_type_id" => payment_type_id,
         "header" => header,
         "footer" => footer,
         "total_gross" => total_gross,
         "total_net" => total_net,
         "total_taxes" => total_taxes,
         "total" => total,
         "total_rounding_difference" => total_rounding_difference,
         "mwst_type" => mwst_type_id,
         "mwst_is_net" => mwst_is_net?,
         "show_position_taxes" => show_position_taxes?,
         "is_valid_from" => is_valid_from,
         "contact_address" => contact_address,
         "delivery_address_type" => delivery_address_type,
         "delivery_address" => delivery_address,
         "kb_item_status_id" => kb_item_status_id,
         "is_recurring" => is_recurring?,
         "api_reference" => api_reference,
         "viewed_by_client_at" => viewed_by_client_at,
         "updated_at" => updated_at,
         "template_slug" => template_slug,
         "taxs" => taxs,
         "network_link" => network_link
       }) do
    %Order{
      id: id,
      document_nr: document_nr,
      title: title,
      contact_id: contact_id,
      contact_sub_id: contact_sub_id,
      user_id: user_id,
      project_id: project_id,
      language_id: language_id,
      bank_account_id: bank_account_id,
      currency_id: currency_id,
      payment_type_id: payment_type_id,
      header: header,
      footer: footer,
      total_gross: to_decimal(total_gross),
      total_net: to_decimal(total_net),
      total_taxes: to_decimal(total_taxes),
      total: to_decimal(total),
      total_rounding_difference: total_rounding_difference,
      mwst_type: mwst_type(mwst_type_id),
      mwst_is_net?: mwst_is_net?,
      show_position_taxes?: show_position_taxes?,
      is_valid_from: to_date(is_valid_from),
      contact_address: contact_address,
      delivery_address_type: delivery_address_type,
      delivery_address: delivery_address,
      kb_item_status: order_kb_item_status(kb_item_status_id),
      api_reference: api_reference,
      viewed_by_client_at: to_datetime(viewed_by_client_at),
      is_recurring?: is_recurring?,
      updated_at: to_datetime(updated_at),
      template_slug: template_slug,
      taxs: Enum.map(taxs, &to_tax/1),
      network_link: network_link
    }
  end

  defp order_kb_item_status(5), do: :pending
  defp order_kb_item_status(6), do: :done
  defp order_kb_item_status(15), do: :partial
  defp order_kb_item_status(21), do: :canceled

  defp order_kb_item_status_id(:pending), do: 5
  defp order_kb_item_status_id(:done), do: 6
  defp order_kb_item_status_id(:partial), do: 15
  defp order_kb_item_status_id(:canceled), do: 21

  # Comments

  @doc """
  This action fetches a list of comments.
  """
  @spec fetch_comments(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Comment.t()]} | {:error, any()}
  def fetch_comments(
        client,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/comment",
          query: opts_to_query(opts)
        )
      end,
      &map_from_comments/1
    )
  end

  @doc """
  This action fetches a single comment.
  """
  @spec fetch_comment(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          comment_id :: pos_integer()
        ) :: {:ok, [Comment.t()]} | {:error, any()}
  def fetch_comment(
        client,
        document_type,
        document_id,
        comment_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(
          client,
          "/2.0/kb_#{document_type}/#{document_id}/comment/#{comment_id}"
        )
      end,
      &map_from_comment/1
    )
  end

  @doc """
  Create a comment
  """
  @spec create_comment(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          comment :: Comment.t()
        ) :: {:ok, [Comment.t()]} | {:error, any()}
  def create_comment(
        client,
        document_type,
        document_id,
        comment
      ) do
    bexio_return_handling(
      fn ->
        Tesla.post(
          client,
          "/2.0/kb_#{document_type}/#{document_id}/comment",
          mapped_comment(comment)
        )
      end,
      &map_from_comment/1
    )
  end

  defp mapped_comment(%{
         text: text,
         user_id: user_id,
         user_email: user_email,
         user_name: user_name,
         public?: public?
       }) do
    %{
      text: text,
      user_id: user_id,
      user_email: user_email,
      user_name: user_name,
      is_public: public?
    }
  end

  defp map_from_comments(comments), do: Enum.map(comments, &map_from_comment/1)

  defp map_from_comment(%{
         "id" => id,
         "text" => text,
         "user_id" => user_id,
         "user_email" => user_email,
         "user_name" => user_name,
         "date" => date,
         "is_public" => public?,
         "image" => image,
         "image_path" => image_path
       }) do
    %Comment{
      id: id,
      text: text,
      user_id: user_id,
      user_email: user_email,
      user_name: user_name,
      date: to_datetime(date),
      public?: public?,
      image: image,
      image_path: image_path
    }
  end

  # Subtotal Positions

  @doc """
  This action fetches a list of all subtotal positions for a document.
  """
  @spec fetch_subtotal_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [PositionSubtotal.t()]} | {:error, any()}
  def fetch_subtotal_positions(
        client,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_subtotal",
          query: opts_to_query(opts)
        )
      end,
      &map_from_subtotal_positions/1
    )
  end

  @doc """
  This action fetches a single subtotal position for a document.
  """
  @spec fetch_subtotal_position(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, [PositionSubtotal.t()]} | {:error, any()}
  def fetch_subtotal_position(
        client,
        document_type,
        document_id,
        position_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(
          client,
          "/2.0/kb_#{document_type}/#{document_id}/kb_position_subtotal/#{position_id}"
        )
      end,
      &map_from_subtotal_position/1
    )
  end

  defp map_from_subtotal_positions(subtotal_positions),
    do: Enum.map(subtotal_positions, &map_from_subtotal_position/1)

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
  """
  @spec fetch_text_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [PositionText.t()]} | {:error, any()}
  def fetch_text_positions(
        client,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_text",
          query: opts_to_query(opts)
        )
      end,
      &map_from_text_positions/1
    )
  end

  @doc """
  This action fetches a single text position for a document.
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
        Tesla.get(
          client,
          "/2.0/kb_#{document_type}/#{document_id}/kb_position_text/#{position_id}"
        )
      end,
      &map_from_text_position/1
    )
  end

  defp map_from_text_positions(text_positions),
    do: Enum.map(text_positions, &map_from_text_position/1)

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
  """
  @spec fetch_default_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [PositionDefault.t()]} | {:error, any()}
  def fetch_default_positions(
        client,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_custom",
          query: opts_to_query(opts)
        )
      end,
      &map_from_default_positions/1
    )
  end

  @doc """
  This action fetches a single default position for a document.
  """
  @spec fetch_default_position(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, [PositionDefault.t()]} | {:error, any()}
  def fetch_default_position(
        client,
        document_type,
        document_id,
        position_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(
          client,
          "/2.0/kb_#{document_type}/#{document_id}/kb_position_custom/#{position_id}"
        )
      end,
      &map_from_default_position/1
    )
  end

  defp map_from_default_positions(default_positions),
    do: Enum.map(default_positions, &map_from_default_position/1)

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
  """
  @spec fetch_item_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [PositionItem.t()]} | {:error, any()}
  def fetch_item_positions(
        client,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_article",
          query: opts_to_query(opts)
        )
      end,
      &map_from_item_positions/1
    )
  end

  @doc """
  This action fetches a single item position for a document.
  """
  @spec fetch_item_position(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, [PositionItem.t()]} | {:error, any()}
  def fetch_item_position(
        client,
        document_type,
        document_id,
        position_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(
          client,
          "/2.0/kb_#{document_type}/#{document_id}/kb_position_article/#{position_id}"
        )
      end,
      &map_from_item_position/1
    )
  end

  defp map_from_item_positions(item_positions),
    do: Enum.map(item_positions, &map_from_item_position/1)

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
  """
  @spec fetch_discount_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [PositionDiscount.t()]} | {:error, any()}
  def fetch_discount_positions(
        client,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_discount",
          query: opts_to_query(opts)
        )
      end,
      &map_from_discount_positions/1
    )
  end

  @doc """
  This action fetches a single discount position for a document.
  """
  @spec fetch_discount_position(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, [PositionDiscount.t()]} | {:error, any()}
  def fetch_discount_position(
        client,
        document_type,
        document_id,
        position_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(
          client,
          "/2.0/kb_#{document_type}/#{document_id}/kb_position_discount/#{position_id}"
        )
      end,
      &map_from_discount_position/1
    )
  end

  defp map_from_discount_positions(discount_positions),
    do: Enum.map(discount_positions, &map_from_discount_position/1)

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
      percentual?: percentual?
    }
  end

  ### Pagebreak Position

  @doc """
  This action fetches a list of all pagebreak positions for a document.
  """
  @spec fetch_pagebreak_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [PositionPagebreak.t()]} | {:error, any()}
  def fetch_pagebreak_positions(
        client,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_pagebreak",
          query: opts_to_query(opts)
        )
      end,
      &map_from_pagebreak_positions/1
    )
  end

  @doc """
  This action fetches a single pagebreak position for a document.
  """
  @spec fetch_pagebreak_position(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, [PositionPagebreak.t()]} | {:error, any()}
  def fetch_pagebreak_position(
        client,
        document_type,
        document_id,
        position_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(
          client,
          "/2.0/kb_#{document_type}/#{document_id}/kb_position_pagebreak/#{position_id}"
        )
      end,
      &map_from_pagebreak_position/1
    )
  end

  defp map_from_pagebreak_positions(pagebreak_positions),
    do: Enum.map(pagebreak_positions, &map_from_pagebreak_position/1)

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

  ### Subposition Position

  @doc """
  This action fetches a list of all subposition positions for a document.
  """
  @spec fetch_subposition_positions(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) ::
          {:ok, [PositionSubposition.t()]} | {:error, any()}
  def fetch_subposition_positions(
        client,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(client, "/2.0/kb_#{document_type}/#{document_id}/kb_position_subposition",
          query: opts_to_query(opts)
        )
      end,
      &map_from_subposition_positions/1
    )
  end

  @doc """
  This action fetches a single subposition position for a document.
  """
  @spec fetch_subposition_position(
          client :: Tesla.Client.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) ::
          {:ok, [PositionSubposition.t()]} | {:error, any()}
  def fetch_subposition_position(
        client,
        document_type,
        document_id,
        position_id
      ) do
    bexio_return_handling(
      fn ->
        Tesla.get(
          client,
          "/2.0/kb_#{document_type}/#{document_id}/kb_position_subposition/#{position_id}"
        )
      end,
      &map_from_subposition_position/1
    )
  end

  defp map_from_subposition_positions(subposition_positions),
    do: Enum.map(subposition_positions, &map_from_subposition_position/1)

  defp map_from_subposition_position(%{
         "id" => id,
         "text" => text,
         "pos" => pos,
         "internal_pos" => internal_pos,
         "show_pos_nr" => show_pos_nr?,
         "is_optional" => optional?,
         "total_sum" => total_sum,
         "show_pos_prices" => show_pos_prices?,
         "parent_id" => parent_id
       }) do
    %PositionSubposition{
      id: id,
      text: text,
      pos: pos,
      internal_pos: internal_pos,
      show_pos_prices?: show_pos_prices?,
      show_pos_nr?: show_pos_nr?,
      total_sum: Decimal.new(total_sum),
      optional?: optional?,
      parent_id: parent_id
    }
  end
end
