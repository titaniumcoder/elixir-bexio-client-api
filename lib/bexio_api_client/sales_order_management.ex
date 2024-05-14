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
    Invoice,
    Delivery,
    PositionSubposition,
    PositionPagebreak,
    PositionDiscount,
    PositionItem,
    PositionDefault,
    PositionText,
    PositionSubtotal
  }

  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @type api_error_type :: BexioApiClient.Helpers.api_error_type()

  # Quotes

  @doc """
  This action fetches a list of all quotes.
  """
  @spec fetch_quotes(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) ::
          {:ok, [Quote.t()]} | api_error_type
  def fetch_quotes(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_offer", query: opts_to_query(opts))
      end,
      &map_from_quotes/2
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
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) ::
          {:ok, [Quote.t()]} | api_error_type

  def search_quotes(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_offer/search", json: criteria, query: opts_to_query(opts))
      end,
      &map_from_quotes/2
    )
  end

  @doc """
  This action fetches a single quote
  """
  @spec fetch_quote(
          req :: Req.Request.t(),
          quote_id :: pos_integer()
        ) ::
          {:ok, Quote.t()} | api_error_type

  def fetch_quote(req, quote_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_offer/#{quote_id}")
      end,
      &map_from_quote/2
    )
  end

  @doc """
  Create a quote (id in order will be ignored). Be also aware: whether you need or must not send a document number depends on the settings in Bexio. It cannot be controlled by the API
  and as such will just send if it exists.
  """
  @spec create_quote(
          req :: Req.Request.t(),
          offer :: Quote.t()
        ) ::
          {:ok, Quote.t()} | api_error_type
  def create_quote(req, offer) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_offer", json: remap_quote(offer))
      end,
      &map_from_quote/2
    )
  end

  @doc """
  Edit a quote.
  """
  @spec edit_quote(
          req :: Req.Request.t(),
          offer :: Quote.t()
        ) :: {:ok, Quote.t()} | api_error_type
  def edit_quote(req, offer) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_offer/#{offer.id}", json: remap_edit_quote(offer))
      end,
      &map_from_quote/2
    )
  end

  @doc """
  Delete a quote.
  """
  @spec delete_quote(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def delete_quote(req, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/kb_offer/#{id}")
      end,
      &success_response/2
    )
  end

  @doc """
  Issue a quote.
  """
  @spec issue_quote(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def issue_quote(req, id) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_offer/#{id}/issue", json: %{})
      end,
      &success_response/2
    )
  end

  @doc """
  Revert Issue a quote.
  """
  @spec revert_issue_quote(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def revert_issue_quote(req, id) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_offer/#{id}/revertIssue", json: %{})
      end,
      &success_response/2
    )
  end

  @doc """
  Accept a quote.
  """
  @spec accept_quote(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def accept_quote(req, id) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_offer/#{id}/accept", json: %{})
      end,
      &success_response/2
    )
  end

  @doc """
  Decline a quote.
  """
  @spec decline_quote(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def decline_quote(req, id) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_offer/#{id}/reject", json: %{})
      end,
      &success_response/2
    )
  end

  @doc """
  Reissue a quote.
  """
  @spec reissue_quote(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def reissue_quote(req, id) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_offer/#{id}/reissue", json: %{})
      end,
      &success_response/2
    )
  end

  @doc """
  Mark a quote as sent.
  """
  @spec mark_quote_as_sent(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | {:error, any()}
  def mark_quote_as_sent(req, id) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_offer/#{id}/mark_as_sent", json: %{})
      end,
      &success_response/2
    )
  end

  @doc """
  This action returns a pdf document of the quote
  """
  @spec quote_pdf(
          req :: Req.Request.t(),
          quote_id :: pos_integer()
        ) :: {:ok, map()} | api_error_type
  def quote_pdf(req, quote_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_offer/#{quote_id}/pdf")
      end,
      &map_from_pdf/2
    )
  end

  defp remap_quote(
         %Quote{
           positions: positions
         } = offer
       ) do
    offer
    |> remap_edit_quote()
    |> Map.put(:positions, Enum.map(positions, &map_to_post_position/1))
  end

  defp map_from_pdf(%{"name" => name, "size" => size, "mime" => mime, "content" => content}, _env) do
    %{
      name: name,
      size: size,
      mime: mime,
      content: content
    }
  end

  defp remap_edit_quote(%Quote{
         title: title,
         document_nr: document_nr,
         contact_id: contact_id,
         contact_sub_id: contact_sub_id,
         user_id: user_id,
         project_id: project_id,
         language_id: language_id,
         bank_account_id: bank_account_id,
         currency_id: curency_id,
         payment_type_id: payment_type_id,
         header: header,
         footer: footer,
         mwst_type: mwst_type,
         mwst_is_net?: mwst_is_net?,
         show_position_taxes?: show_position_taxes?,
         is_valid_from: is_valid_from,
         is_valid_until: is_valid_until,
         delivery_address_type: delivery_address_type,
         api_reference: api_reference,
         viewed_by_client_at: viewed_by_client_at,
         kb_terms_of_payment_template_id: kb_terms_of_payment_template_id,
         template_slug: template_slug
       }) do
    %{
      title: title,
      document_nr: document_nr,
      contact_id: contact_id,
      contact_sub_id: contact_sub_id,
      user_id: user_id,
      pr_project_id: project_id,
      language_id: language_id,
      bank_account_id: bank_account_id,
      currency_id: curency_id,
      payment_type_id: payment_type_id,
      header: header,
      footer: footer,
      mwst_type: mwst_type_id(mwst_type),
      mwst_is_net: mwst_is_net?,
      show_position_taxes: show_position_taxes?,
      is_valid_from: to_iso8601(is_valid_from),
      is_valid_until: to_iso8601(is_valid_until),
      delivery_address_type: delivery_address_type,
      api_reference: api_reference,
      viewed_by_client_at: to_naive_string(viewed_by_client_at),
      kb_terms_of_payment_template_id: kb_terms_of_payment_template_id,
      template_slug: template_slug
    }
    |> remove_document_no_if_nil()
  end

  defp map_to_post_position(%PositionDefault{
         amount: amount,
         unit_id: unit_id,
         account_id: account_id,
         tax_id: tax_id,
         text: text,
         unit_price: unit_price,
         discount_in_percent: discount_in_percent
       }),
       do: %{
         type: "KbPositionCustom",
         amount: Decimal.to_string(amount, :normal),
         unit_id: unit_id,
         account_id: account_id,
         tax_id: tax_id,
         unit_price: Decimal.to_string(unit_price, :normal),
         discount_in_percent: Decimal.to_string(discount_in_percent, :normal),
         text: text
       }

  defp map_to_post_position(%PositionItem{
         amount: amount,
         unit_id: unit_id,
         account_id: account_id,
         tax_id: tax_id,
         text: text,
         unit_price: unit_price,
         discount_in_percent: discount_in_percent,
         article_id: article_id
       }),
       do: %{
         type: "KbPositionArticle",
         amount: Decimal.to_string(amount, :normal),
         unit_id: unit_id,
         account_id: account_id,
         tax_id: tax_id,
         unit_price: Decimal.to_string(unit_price, :normal),
         discount_in_percent: Decimal.to_string(discount_in_percent, :normal),
         text: text,
         article_id: article_id
       }

  defp map_to_post_position(%PositionText{
         text: text,
         show_pos_nr?: show_pos_nr?
       }),
       do: %{
         type: "KbPositionText",
         text: text,
         show_pos_nr: show_pos_nr?
       }

  defp map_to_post_position(%PositionSubtotal{text: text}),
    do: %{
      type: "KbPositionSubtotal",
      text: text
    }

  defp map_to_post_position(%PositionPagebreak{}),
    do: %{
      type: "KbPositionPagebreak",
      pagebreak: true
    }

  defp map_to_post_position(%PositionDiscount{
         text: text,
         percentual?: percentual?,
         value: value
       }),
       do: %{
         type: "KbPositionDiscount",
         is_percentual: percentual?,
         text: text,
         value: Decimal.to_string(value, :normal)
       }

  defp map_from_quotes(quotes, _env), do: Enum.map(quotes, &map_from_quote/1)

  defp map_from_quote(
         %{
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
         } = map,
         _env \\ nil
       ) do
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
    |> map_quote_positions(Map.get(map, "positions"))
  end

  defp map_quote_positions(q, nil), do: q
  defp map_quote_positions(q, positions), do: %{q | positions: remap_positions(positions)}

  defp mwst_type(0), do: :including
  defp mwst_type(1), do: :excluding
  defp mwst_type(2), do: :exempt

  defp mwst_type_id(:including), do: 0
  defp mwst_type_id(:excluding), do: 1
  defp mwst_type_id(:exempt), do: 2

  defp kb_item_status(1), do: :draft
  defp kb_item_status(2), do: :pending
  defp kb_item_status(3), do: :confirmed
  defp kb_item_status(4), do: :declined

  defp to_tax(%{"percentage" => percentage, "value" => value}),
    do: %{percentage: percentage, value: value}

  # Orders

  @doc """
  This action fetches a list of all orders.
  """
  @spec fetch_orders(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Order.t()]} | api_error_type
  def fetch_orders(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_order", query: opts_to_query(opts))
      end,
      &map_from_orders/2
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
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Order.t()]} | api_error_type
  def search_orders(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_order/search", json: criteria, query: opts_to_query(opts))
      end,
      &map_from_orders/2
    )
  end

  @doc """
  This action fetches a single order
  """
  @spec fetch_order(
          req :: Req.Request.t(),
          order_id :: pos_integer()
        ) :: {:ok, Order.t()} | api_error_type
  def fetch_order(req, order_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_order/#{order_id}")
      end,
      &map_from_order/2
    )
  end

  @doc """
  Create an order (id in order will be ignored). Be also aware: whether you need or must not send a document number depends on the settings in Bexio. It cannot be controlled by the API
  and as such will just send if it exists.
  """
  @spec create_order(
          req :: Req.Request.t(),
          order :: Order.t()
        ) :: {:ok, Order.t()} | api_error_type
  def create_order(req, order) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_order", json: remap_order(order))
      end,
      &map_from_order/2
    )
  end

  @doc """
  Edit an order.
  """
  @spec edit_order(
          req :: Req.Request.t(),
          order :: Order.t()
        ) :: {:ok, Order.t()} | api_error_type
  def edit_order(req, order) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_order/#{order.id}", json: remap_edit_order(order))
      end,
      &map_from_order/2
    )
  end

  @doc """
  Delete an order.
  """
  @spec delete_order(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def delete_order(req, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/kb_order/#{id}")
      end,
      &success_response/2
    )
  end

  @doc """
  This action returns a pdf document of the order
  """
  @spec order_pdf(
          req :: Req.Request.t(),
          order_id :: pos_integer()
        ) :: {:ok, map()} | api_error_type
  def order_pdf(req, order_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_order/#{order_id}/pdf")
      end,
      &map_from_pdf/2
    )
  end

  defp remap_order(
         %Order{
           positions: positions
         } = order
       ) do
    order
    |> remap_edit_order()
    |> Map.put(:positions, Enum.map(positions, &map_to_post_position/1))
  end

  defp remap_edit_order(%Order{
         title: title,
         document_nr: document_nr,
         contact_id: contact_id,
         contact_sub_id: contact_sub_id,
         user_id: user_id,
         project_id: project_id,
         language_id: language_id,
         bank_account_id: bank_account_id,
         currency_id: curency_id,
         payment_type_id: payment_type_id,
         header: header,
         footer: footer,
         mwst_type: mwst_type,
         mwst_is_net?: mwst_is_net?,
         show_position_taxes?: show_position_taxes?,
         is_valid_from: is_valid_from,
         delivery_address_type: delivery_address_type,
         api_reference: api_reference,
         template_slug: template_slug
       }) do
    %{
      title: title,
      document_nr: document_nr,
      contact_id: contact_id,
      contact_sub_id: contact_sub_id,
      user_id: user_id,
      pr_project_id: project_id,
      language_id: language_id,
      bank_account_id: bank_account_id,
      currency_id: curency_id,
      payment_type_id: payment_type_id,
      header: header,
      footer: footer,
      mwst_type: mwst_type_id(mwst_type),
      mwst_is_net: mwst_is_net?,
      show_position_taxes: show_position_taxes?,
      is_valid_from: Date.to_iso8601(is_valid_from),
      delivery_address_type: delivery_address_type,
      api_reference: api_reference,
      template_slug: template_slug
    }
    |> remove_document_no_if_nil()
  end

  defp map_from_orders(orders, _env), do: Enum.map(orders, &map_from_order/1)

  defp map_from_order(
         %{
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
         } = map,
         _env \\ nil
       ) do
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
    |> map_order_positions(Map.get(map, "positions"))
  end

  defp map_order_positions(q, nil), do: q
  defp map_order_positions(q, positions), do: %{q | positions: remap_positions(positions)}

  defp order_kb_item_status(5), do: :pending
  defp order_kb_item_status(6), do: :done
  defp order_kb_item_status(15), do: :partial
  defp order_kb_item_status(21), do: :cancelled

  # Deliveries

  @doc """
  This action fetches a list of all deliveries.
  """
  @spec fetch_deliveries(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Delivery.t()]} | api_error_type
  def fetch_deliveries(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_delivery", query: opts_to_query(opts))
      end,
      &map_from_deliveries/2
    )
  end

  @doc """
  This action fetches a single delivery
  """
  @spec fetch_delivery(
          req :: Req.Request.t(),
          delivery_id :: pos_integer()
        ) :: {:ok, Delivery.t()} | api_error_type
  def fetch_delivery(req, delivery_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_delivery/#{delivery_id}")
      end,
      &map_from_delivery/2
    )
  end

  @doc """
  Issues a delivery (only possible if it's in draft status!). The result whether the issue was successful or not
  """
  @spec issue_delivery(
          req :: Req.Request.t(),
          delivery_id :: integer()
        ) :: {:ok, boolean()} | api_error_type
  def issue_delivery(req, delivery_id) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_delivery/#{delivery_id}/issue", json: %{})
      end,
      &success_response/2
    )
  end

  defp map_from_deliveries(deliveries, _env), do: Enum.map(deliveries, &map_from_delivery/1)

  defp map_from_delivery(
         %{
           "id" => id,
           "document_nr" => document_nr,
           "title" => title,
           "contact_id" => contact_id,
           "contact_sub_id" => contact_sub_id,
           "user_id" => user_id,
           "language_id" => language_id,
           "bank_account_id" => bank_account_id,
           "currency_id" => currency_id,
           "header" => header,
           "footer" => footer,
           "total_gross" => total_gross,
           "total_net" => total_net,
           "total_taxes" => total_taxes,
           "total" => total,
           "total_rounding_difference" => total_rounding_difference,
           "mwst_type" => mwst_type_id,
           "mwst_is_net" => mwst_is_net?,
           "is_valid_from" => is_valid_from,
           "contact_address" => contact_address,
           "delivery_address_type" => delivery_address_type,
           "delivery_address" => delivery_address,
           "kb_item_status_id" => kb_item_status_id,
           "api_reference" => api_reference,
           "updated_at" => updated_at,
           "taxs" => taxs
         } = map,
         _env \\ nil
       ) do
    %Delivery{
      id: id,
      document_nr: document_nr,
      title: title,
      contact_id: contact_id,
      contact_sub_id: contact_sub_id,
      user_id: user_id,
      language_id: language_id,
      bank_account_id: bank_account_id,
      currency_id: currency_id,
      header: header,
      footer: footer,
      total_gross: to_decimal(total_gross),
      total_net: to_decimal(total_net),
      total_taxes: to_decimal(total_taxes),
      total: to_decimal(total),
      total_rounding_difference: total_rounding_difference,
      mwst_type: mwst_type(mwst_type_id),
      mwst_is_net?: mwst_is_net?,
      is_valid_from: to_date(is_valid_from),
      contact_address: contact_address,
      delivery_address_type: delivery_address_type,
      delivery_address: delivery_address,
      kb_item_status: delivery_kb_item_status(kb_item_status_id),
      api_reference: api_reference,
      updated_at: to_datetime(updated_at),
      taxs: Enum.map(taxs, &to_tax/1)
    }
    |> map_delivery_positions(Map.get(map, "positions"))
  end

  defp map_delivery_positions(q, nil), do: q
  defp map_delivery_positions(q, positions), do: %{q | positions: remap_positions(positions)}

  defp delivery_kb_item_status(10), do: :draft
  defp delivery_kb_item_status(18), do: :done
  defp delivery_kb_item_status(20), do: :cancelled

  # Invoices

  @doc """
  This action fetches a list of all invoices.
  """
  @spec fetch_invoices(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Invoice.t()]} | api_error_type
  def fetch_invoices(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_invoice", query: opts_to_query(opts))
      end,
      &map_from_invoices/2
    )
  end

  @doc """
  Search invoices via query.
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
  * is_valid_to
  * updated_at
  """
  @spec search_invoices(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Invoice.t()]} | api_error_type
  def search_invoices(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_invoice/search", json: criteria, query: opts_to_query(opts))
      end,
      &map_from_invoices/2
    )
  end

  @doc """
  This action fetches a single invoice
  """
  @spec fetch_invoice(
          req :: Req.Request.t(),
          invoice_id :: pos_integer()
        ) :: {:ok, Quote.t()} | api_error_type
  def fetch_invoice(req, invoice_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_invoice/#{invoice_id}")
      end,
      &map_from_invoice/2
    )
  end

  @doc """
  Create an invoice (id in order will be ignored). Be also aware: whether you need or must not send a document number depends on the settings in Bexio. It cannot be controlled by the API
  and as such will just send if it exists.
  """
  @spec create_invoice(
          req :: Req.Request.t(),
          invoice :: Invoice.t()
        ) :: {:ok, Invoice.t()} | api_error_type
  def create_invoice(req, invoice) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_invoice", json: remap_invoice(invoice))
      end,
      &map_from_invoice/2
    )
  end

  @doc """
  Edit an invoice.
  """
  @spec edit_invoice(
          req :: Req.Request.t(),
          invoice :: Invoice.t()
        ) :: {:ok, Invoice.t()} | api_error_type
  def edit_invoice(req, invoice) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_invoice/#{invoice.id}", json: remap_edit_invoice(invoice))
      end,
      &map_from_invoice/2
    )
  end

  @doc """
  Delete an invoice.
  """
  @spec delete_invoice(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def delete_invoice(req, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/kb_invoice/#{id}")
      end,
      &success_response/2
    )
  end

  @doc """
  Issue an invoice.
  """
  @spec issue_invoice(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def issue_invoice(req, id) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_invoice/#{id}/issue", json: %{})
      end,
      &success_response/2
    )
  end

  @doc """
  Revert Issue an invoice.
  """
  @spec revert_issue_invoice(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def revert_issue_invoice(req, id) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_invoice/#{id}/revert_issue", json: %{})
      end,
      &success_response/2
    )
  end

  @doc """
  This action returns a pdf document of the quote
  """
  @spec invoice_pdf(
          req :: Req.Request.t(),
          invoice_id :: pos_integer()
        ) :: {:ok, map()} | api_error_type
  def invoice_pdf(req, invoice_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_invoice/#{invoice_id}/pdf")
      end,
      &map_from_pdf/2
    )
  end

  defp remap_invoice(
         %Invoice{
           positions: positions
         } = invoice
       ) do
    invoice
    |> remap_edit_invoice()
    |> Map.put(:positions, Enum.map(positions, &map_to_post_position/1))
  end

  defp remap_edit_invoice(%Invoice{
         title: title,
         document_nr: document_nr,
         contact_id: contact_id,
         contact_sub_id: contact_sub_id,
         user_id: user_id,
         project_id: project_id,
         language_id: language_id,
         bank_account_id: bank_account_id,
         currency_id: curency_id,
         payment_type_id: payment_type_id,
         header: header,
         footer: footer,
         mwst_type: mwst_type,
         mwst_is_net?: mwst_is_net?,
         show_position_taxes?: show_position_taxes?,
         is_valid_from: is_valid_from,
         is_valid_to: is_valid_to,
         api_reference: api_reference,
         template_slug: template_slug,
         reference: reference
       }) do
    %{
      title: title,
      document_nr: document_nr,
      contact_id: contact_id,
      contact_sub_id: contact_sub_id,
      user_id: user_id,
      pr_project_id: project_id,
      language_id: language_id,
      bank_account_id: bank_account_id,
      currency_id: curency_id,
      payment_type_id: payment_type_id,
      header: header,
      footer: footer,
      mwst_type: mwst_type_id(mwst_type),
      mwst_is_net: mwst_is_net?,
      show_position_taxes: show_position_taxes?,
      is_valid_from: to_iso8601(is_valid_from),
      is_valid_to: to_iso8601(is_valid_to),
      reference: reference,
      api_reference: api_reference,
      template_slug: template_slug
    }
    |> remove_document_no_if_nil()
  end

  defp map_from_invoices(invoices, _env), do: Enum.map(invoices, &map_from_invoice/1)

  defp map_from_invoice(
         %{
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
           "is_valid_to" => is_valid_to,
           "contact_address" => contact_address,
           "kb_item_status_id" => kb_item_status_id,
           "api_reference" => api_reference,
           "viewed_by_client_at" => viewed_by_client_at,
           "updated_at" => updated_at,
           "template_slug" => template_slug,
           "taxs" => taxs,
           "network_link" => network_link,
           "esr_id" => esr_id,
           "qr_invoice_id" => qr_invoice_id,
           "reference" => reference,
           "total_credit_vouchers" => total_credit_vouchers,
           "total_received_payments" => total_received_payments,
           "total_remaining_payments" => total_remaining_payments
         } = map,
         _env \\ nil
       ) do
    %Invoice{
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
      is_valid_to: to_date(is_valid_to),
      contact_address: contact_address,
      kb_item_status: invoice_kb_item_status(kb_item_status_id),
      api_reference: api_reference,
      viewed_by_client_at: to_datetime(viewed_by_client_at),
      updated_at: to_datetime(updated_at),
      template_slug: template_slug,
      taxs: Enum.map(taxs, &to_tax/1),
      network_link: network_link,
      esr_id: esr_id,
      qr_invoice_id: qr_invoice_id,
      reference: reference,
      total_credit_vouchers: to_decimal(total_credit_vouchers),
      total_received_payments: to_decimal(total_received_payments),
      total_remaining_payments: to_decimal(total_remaining_payments)
    }
    |> map_invoice_positions(Map.get(map, "positions"))
  end

  defp map_invoice_positions(q, nil), do: q
  defp map_invoice_positions(q, positions), do: %{q | positions: remap_positions(positions)}

  defp invoice_kb_item_status(7), do: :draft
  defp invoice_kb_item_status(8), do: :pending
  defp invoice_kb_item_status(9), do: :paid
  defp invoice_kb_item_status(16), do: :partial
  defp invoice_kb_item_status(19), do: :cancelled
  defp invoice_kb_item_status(31), do: :unpaid

  # Comments

  @doc """
  This action fetches a list of comments.
  """
  @spec fetch_comments(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Comment.t()]} | api_error_type
  def fetch_comments(
        req,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_#{document_type}/#{document_id}/comment",
          query: opts_to_query(opts)
        )
      end,
      &map_from_comments/2
    )
  end

  @doc """
  This action fetches a single comment.
  """
  @spec fetch_comment(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          comment_id :: pos_integer()
        ) :: {:ok, Comment.t()} | api_error_type
  def fetch_comment(
        req,
        document_type,
        document_id,
        comment_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/comment/#{comment_id}"
        )
      end,
      &map_from_comment/2
    )
  end

  @doc """
  Create a comment
  """
  @spec create_comment(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          comment :: Comment.t()
        ) :: {:ok, Comment.t()} | api_error_type
  def create_comment(
        req,
        document_type,
        document_id,
        comment
      ) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/comment",
          json: mapped_comment(comment)
        )
      end,
      &map_from_comment/2
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

  defp map_from_comments(comments, _env), do: Enum.map(comments, &map_from_comment/1)

  defp map_from_comment(
         %{
           "id" => id,
           "text" => text,
           "user_id" => user_id,
           "user_email" => user_email,
           "user_name" => user_name,
           "date" => date,
           "is_public" => public?,
           "image" => image,
           "image_path" => image_path
         },
         _env \\ nil
       ) do
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

  # Remap positions for single orders / quotes
  defp remap_positions([]), do: []
  defp remap_positions([position | tl]), do: [remap_position(position) | remap_positions(tl)]

  defp remap_position(%{"type" => "KbPositionCustom"} = position),
    do: map_from_default_position(position)

  defp remap_position(%{"type" => "KbPositionArticle"} = position),
    do: map_from_item_position(position)

  defp remap_position(%{"type" => "KbPositionText"} = position),
    do: map_from_text_position(position)

  defp remap_position(%{"type" => "KbPositionSubtotal"} = position),
    do: map_from_subtotal_position(position)

  defp remap_position(%{"type" => "KbPositionPagebreak"} = position),
    do: map_from_pagebreak_position(position)

  defp remap_position(%{"type" => "KbPositionDiscount"} = position),
    do: map_from_discount_position(position)

  # Subtotal Positions

  @doc """
  This action fetches a list of all subtotal positions for a document.
  """
  @spec fetch_subtotal_positions(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [PositionSubtotal.t()]} | api_error_type
  def fetch_subtotal_positions(
        req,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_subtotal",
          query: opts_to_query(opts)
        )
      end,
      &map_from_subtotal_positions/2
    )
  end

  @doc """
  This action fetches a single subtotal position for a document.
  """
  @spec fetch_subtotal_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, PositionSubtotal.t()} | api_error_type
  def fetch_subtotal_position(
        req,
        document_type,
        document_id,
        position_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_subtotal/#{position_id}"
        )
      end,
      &map_from_subtotal_position/2
    )
  end

  @doc """
  Create a subtotal position.
  """
  @spec create_subtotal_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          text :: String.t()
        ) :: {:ok, PositionSubtotal.t()} | api_error_type
  def create_subtotal_position(req, document_type, document_id, text) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_subtotal", json: %{
          text: text
        })
      end,
      &map_from_subtotal_position/2
    )
  end

  @doc """
  Edit a subtotal position.
  """
  @spec edit_subtotal_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer(),
          text :: String.t()
        ) :: {:ok, PositionSubtotal.t()} | api_error_type
  def edit_subtotal_position(req, document_type, document_id, position_id, text) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_subtotal/#{position_id}",
          json: %{text: text}
        )
      end,
      &map_from_subtotal_position/2
    )
  end

  @doc """
  Delete a subtotal position.
  """
  @spec delete_subtotal_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def delete_subtotal_position(req, document_type, document_id, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_subtotal/#{id}")
      end,
      &success_response/2
    )
  end

  defp map_from_subtotal_positions(subtotal_positions, _env),
    do: Enum.map(subtotal_positions, &map_from_subtotal_position/1)

  defp map_from_subtotal_position(
         %{
           "id" => id,
           "text" => text,
           "value" => value,
           "internal_pos" => internal_pos,
           "is_optional" => optional?,
           "parent_id" => parent_id
         },
         _env \\ nil
       ) do
    %PositionSubtotal{
      id: id,
      text: text,
      value: decimal_nil_as_zero(value),
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
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [PositionText.t()]} | api_error_type
  def fetch_text_positions(
        req,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_text",
          query: opts_to_query(opts)
        )
      end,
      &map_from_text_positions/2
    )
  end

  @doc """
  This action fetches a single text position for a document.
  """
  @spec fetch_text_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, PositionText.t()} | api_error_type
  def fetch_text_position(
        req,
        document_type,
        document_id,
        position_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_text/#{position_id}"
        )
      end,
      &map_from_text_position/2
    )
  end

  @doc """
  Create a text position
  """
  @spec create_text_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          text :: String.t(),
          show_pos_nr? :: boolean()
        ) :: {:ok, PositionText.t()} | api_error_type
  def create_text_position(req, document_type, document_id, text, show_pos_nr?) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_text",
          json: %{text: text, show_pos_nr: show_pos_nr?}
        )
      end,
      &map_from_text_position/2
    )
  end

  @doc """
  Edit a text position.
  """
  @spec edit_text_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer(),
          text :: String.t(),
          show_pos_nr? :: boolean()
        ) :: {:ok, PositionText.t()} | api_error_type
  def edit_text_position(req, document_type, document_id, position_id, text, show_pos_nr?) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_text/#{position_id}",
          json: %{text: text, show_pos_nr: show_pos_nr?}
        )
      end,
      &map_from_text_position/2
    )
  end

  @doc """
  Delete a text position.
  """
  @spec delete_text_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def delete_text_position(req, document_type, document_id, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_text/#{id}")
      end,
      &success_response/2
    )
  end

  defp map_from_text_positions(text_positions, _env),
    do: Enum.map(text_positions, &map_from_text_position/1)

  defp map_from_text_position(
         %{
           "id" => id,
           "text" => text,
           "show_pos_nr" => show_pos_nr?,
           "pos" => pos,
           "internal_pos" => internal_pos,
           "is_optional" => optional?,
           "parent_id" => parent_id
         },
         _env \\ nil
       ) do
    %PositionText{
      id: id,
      text: text,
      show_pos_nr?: show_pos_nr?,
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
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [PositionDefault.t()]} | api_error_type
  def fetch_default_positions(
        req,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_custom",
          query: opts_to_query(opts)
        )
      end,
      &map_from_default_positions/2
    )
  end

  @doc """
  This action fetches a single default position for a document.
  """
  @spec fetch_default_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, PositionDefault.t()} | api_error_type
  def fetch_default_position(
        req,
        document_type,
        document_id,
        position_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_custom/#{position_id}"
        )
      end,
      &map_from_default_position/2
    )
  end

  @doc """
  Create a default position
  """
  @spec create_default_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position :: PositionDefault.t()
        ) :: {:ok, PositionDefault.t()} | api_error_type
  def create_default_position(req, document_type, document_id, position) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_custom",
          json: remap_default_position(position)
        )
      end,
      &map_from_default_position/2
    )
  end

  @doc """
  Edit a default position.
  """
  @spec edit_default_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position :: PositionDefault.t()
        ) :: {:ok, PositionDefault.t()} | api_error_type
  def edit_default_position(req, document_type, document_id, position) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_custom/#{position.id}",
          json: remap_default_position(position)
        )
      end,
      &map_from_default_position/2
    )
  end

  @doc """
  Delete a default position.
  """
  @spec delete_default_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def delete_default_position(req, document_type, document_id, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_custom/#{id}")
      end,
      &success_response/2
    )
  end

  defp remap_default_position(%PositionDefault{
         amount: amount,
         unit_id: unit_id,
         account_id: account_id,
         tax_id: tax_id,
         text: text,
         unit_price: unit_price,
         discount_in_percent: discount_in_percent
       }) do
    %{
      amount: Decimal.to_string(amount, :normal),
      unit_id: unit_id,
      account_id: account_id,
      tax_id: tax_id,
      text: text,
      unit_price: Decimal.to_string(unit_price, :normal),
      discount_in_percent: Decimal.to_string(discount_in_percent, :normal)
    }
  end

  defp map_from_default_positions(default_positions, _env),
    do: Enum.map(default_positions, &map_from_default_position/1)

  defp map_from_default_position(
         %{
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
         },
         _env \\ nil
       ) do
    %PositionDefault{
      id: id,
      amount: decimal_nil_as_zero(amount),
      unit_id: unit_id,
      account_id: account_id,
      unit_name: unit_name,
      tax_id: tax_id,
      tax_value: decimal_nil_as_zero(tax_value),
      text: text,
      unit_price: decimal_nil_as_zero(unit_price),
      discount_in_percent: decimal_nil_as_zero(discount_in_percent),
      position_total: decimal_nil_as_zero(position_total),
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
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [PositionItem.t()]} | api_error_type
  def fetch_item_positions(
        req,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_article",
          query: opts_to_query(opts)
        )
      end,
      &map_from_item_positions/2
    )
  end

  @doc """
  This action fetches a single item position for a document.
  """
  @spec fetch_item_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, PositionItem.t()} | api_error_type
  def fetch_item_position(
        req,
        document_type,
        document_id,
        position_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_article/#{position_id}"
        )
      end,
      &map_from_item_position/2
    )
  end

  @doc """
  Create an item position
  """
  @spec create_item_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position :: PositionItem.t()
        ) :: {:ok, PositionItem.t()} | api_error_type
  def create_item_position(req, document_type, document_id, position) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_article",
          json: remap_item_position(position)
        )
      end,
      &map_from_item_position/2
    )
  end

  @doc """
  Edit an item.
  """
  @spec edit_item_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position :: PositionItem.t()
        ) :: {:ok, PositionItem.t()} | api_error_type
  def edit_item_position(req, document_type, document_id, position) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_article/#{position.id}",
          json: remap_item_position(position)
        )
      end,
      &map_from_default_position/2
    )
  end

  @doc """
  Delete a default position.
  """
  @spec delete_item_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def delete_item_position(req, document_type, document_id, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_article/#{id}")
      end,
      &success_response/2
    )
  end

  defp remap_item_position(%PositionItem{
         amount: amount,
         unit_id: unit_id,
         account_id: account_id,
         tax_id: tax_id,
         text: text,
         unit_price: unit_price,
         discount_in_percent: discount_in_percent,
         article_id: article_id
       }) do
    %{
      amount: Decimal.to_string(amount, :normal),
      unit_id: unit_id,
      account_id: account_id,
      tax_id: tax_id,
      text: text,
      unit_price: Decimal.to_string(unit_price, :normal),
      discount_in_percent: Decimal.to_string(discount_in_percent, :normal),
      article_id: article_id
    }
  end

  defp map_from_item_positions(item_positions, _env),
    do: Enum.map(item_positions, &map_from_item_position/1)

  defp map_from_item_position(
         %{
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
         },
         _env \\ nil
       ) do
    %PositionItem{
      id: id,
      amount: decimal_nil_as_zero(amount),
      unit_id: unit_id,
      account_id: account_id,
      unit_name: unit_name,
      tax_id: tax_id,
      tax_value: decimal_nil_as_zero(tax_value),
      text: text,
      unit_price: decimal_nil_as_zero(unit_price),
      discount_in_percent: decimal_nil_as_zero(discount_in_percent),
      position_total: decimal_nil_as_zero(position_total),
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
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [PositionDiscount.t()]} | api_error_type
  def fetch_discount_positions(
        req,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_discount",
          query: opts_to_query(opts)
        )
      end,
      &map_from_discount_positions/2
    )
  end

  @doc """
  This action fetches a single discount position for a document.
  """
  @spec fetch_discount_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, PositionDiscount.t()} | api_error_type
  def fetch_discount_position(
        req,
        document_type,
        document_id,
        position_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_discount/#{position_id}"
        )
      end,
      &map_from_discount_position/2
    )
  end

  @doc """
  Create a discount position
  """
  @spec create_discount_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position :: PositionDiscount.t()
        ) :: {:ok, PositionDiscount.t()} | api_error_type
  def create_discount_position(req, document_type, document_id, position) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_discount",
          json: remap_discount_position(position)
        )
      end,
      &map_from_discount_position/2
    )
  end

  @doc """
  Edit a discount position.
  """
  @spec edit_discount_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position :: PositionDiscount.t()
        ) :: {:ok, PositionDiscount.t()} | api_error_type
  def edit_discount_position(req, document_type, document_id, position) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_discount/#{position.id}",
          json: remap_discount_position(position)
        )
      end,
      &map_from_discount_position/2
    )
  end

  @doc """
  Delete a discount position.
  """
  @spec delete_discount_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def delete_discount_position(req, document_type, document_id, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_discount/#{id}")
      end,
      &success_response/2
    )
  end

  defp remap_discount_position(%PositionDiscount{
         text: text,
         percentual?: percentual?,
         value: value
       }) do
    %{
      text: text,
      is_percentual: percentual?,
      value: Decimal.to_string(value, :normal)
    }
  end

  defp map_from_discount_positions(discount_positions, _env),
    do: Enum.map(discount_positions, &map_from_discount_position/1)

  defp map_from_discount_position(
         %{
           "id" => id,
           "text" => text,
           "value" => value,
           "discount_total" => discount_total,
           "is_percentual" => percentual?
         },
         _env \\ nil
       ) do
    %PositionDiscount{
      id: id,
      text: text,
      value: decimal_nil_as_zero(value),
      discount_total: decimal_nil_as_zero(discount_total),
      percentual?: percentual?
    }
  end

  ### Pagebreak Position

  @doc """
  This action fetches a list of all pagebreak positions for a document.
  """
  @spec fetch_pagebreak_positions(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [PositionPagebreak.t()]} | api_error_type
  def fetch_pagebreak_positions(
        req,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_pagebreak",
          query: opts_to_query(opts)
        )
      end,
      &map_from_pagebreak_positions/2
    )
  end

  @doc """
  This action fetches a single pagebreak position for a document.
  """
  @spec fetch_pagebreak_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) :: {:ok, PositionPagebreak.t()} | api_error_type
  def fetch_pagebreak_position(
        req,
        document_type,
        document_id,
        position_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_pagebreak/#{position_id}"
        )
      end,
      &map_from_pagebreak_position/2
    )
  end

  @doc """
  Create a pagebreak position
  """
  @spec create_pagebreak_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer()
        ) :: {:ok, PositionPagebreak.t()} | api_error_type
  def create_pagebreak_position(req, document_type, document_id) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_pagebreak",
          json: %{}
        )
      end,
      &map_from_pagebreak_position/2
    )
  end

  @doc """
  Edit a pagebreak position.
  """
  @spec edit_pagebreak_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer(),
          pagebreak :: boolean()
        ) :: {:ok, PositionPagebreak.t()} | api_error_type
  def edit_pagebreak_position(req, document_type, document_id, position_id, pagebreak) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_pagebreak/#{position_id}",
          json: %{papebreak: pagebreak}
        )
      end,
      &map_from_pagebreak_position/2
    )
  end

  @doc """
  Delete a pagebreak position.
  """
  @spec delete_pagebreak_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def delete_pagebreak_position(req, document_type, document_id, id) do
    bexio_body_handling(
      fn ->
        Req.delete(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_pagebreak/#{id}"
        )
      end,
      &success_response/2
    )
  end

  defp map_from_pagebreak_positions(pagebreak_positions, _env),
    do: Enum.map(pagebreak_positions, &map_from_pagebreak_position/1)

  defp map_from_pagebreak_position(
         %{
           "id" => id,
           "internal_pos" => internal_pos,
           "is_optional" => optional?,
           "parent_id" => parent_id
         },
         _env \\ nil
       ) do
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
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) ::
          {:ok, [PositionSubposition.t()]} | api_error_type
  def fetch_subposition_positions(
        req,
        document_type,
        document_id,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_subposition",
          query: opts_to_query(opts)
        )
      end,
      &map_from_subposition_positions/2
    )
  end

  @doc """
  This action fetches a single subposition position for a document.
  """
  @spec fetch_subposition_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer()
        ) ::
          {:ok, PositionSubposition.t()} | api_error_type
  def fetch_subposition_position(
        req,
        document_type,
        document_id,
        position_id
      ) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_subposition/#{position_id}"
        )
      end,
      &map_from_subposition_position/2
    )
  end

  @doc """
  Create a subposition position
  """
  @spec create_subposition_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          text :: String.t(),
          show_pos_nr? :: boolean()
        ) :: {:ok, PositionSubposition.t()} | api_error_type
  def create_subposition_position(req, document_type, document_id, text, show_pos_nr?) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_subposition",
          json: %{text: text, show_pos_nr: show_pos_nr?}
        )
      end,
      &map_from_subposition_position/2
    )
  end

  @doc """
  Edit a subposition position.
  """
  @spec edit_subposition_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          position_id :: pos_integer(),
          text :: String.t(),
          show_pos_nr? :: boolean()
        ) :: {:ok, PositionSubposition.t()} | api_error_type
  def edit_subposition_position(
        req,
        document_type,
        document_id,
        position_id,
        text,
        show_pos_nr?
      ) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_subposition/#{position_id}",
          json: %{text: text, show_pos_nr: show_pos_nr?}
        )
      end,
      &map_from_subposition_position/2
    )
  end

  @doc """
  Delete a subposition position.
  """
  @spec delete_subposition_position(
          req :: Req.Request.t(),
          document_type :: :offer | :order | :invoice,
          document_id :: pos_integer(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type
  def delete_subposition_position(req, document_type, document_id, id) do
    bexio_body_handling(
      fn ->
        Req.delete(
          req,
          url: "/2.0/kb_#{document_type}/#{document_id}/kb_position_subposition/#{id}"
        )
      end,
      &success_response/2
    )
  end

  defp map_from_subposition_positions(subposition_positions, _env),
    do: Enum.map(subposition_positions, &map_from_subposition_position/1)

  defp map_from_subposition_position(
         %{
           "id" => id,
           "text" => text,
           "pos" => pos,
           "internal_pos" => internal_pos,
           "show_pos_nr" => show_pos_nr?,
           "is_optional" => optional?,
           "total_sum" => total_sum,
           "show_pos_prices" => show_pos_prices?,
           "parent_id" => parent_id
         },
         _env \\ nil
       ) do
    %PositionSubposition{
      id: id,
      text: text,
      pos: pos,
      internal_pos: internal_pos,
      show_pos_prices?: show_pos_prices?,
      show_pos_nr?: show_pos_nr?,
      total_sum: decimal_nil_as_zero(total_sum),
      optional?: optional?,
      parent_id: parent_id
    }
  end
end
