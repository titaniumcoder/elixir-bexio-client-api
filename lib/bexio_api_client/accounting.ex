defmodule BexioApiClient.Accounting do
  @moduledoc """
  Bexio API for the accounting part of the API.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria

  alias BexioApiClient.Accounting.{
    Account,
    AccountGroup,
    BusinessYear,
    CalendarYear,
    Currency,
    ExchangeRate,
    JournalEntry,
    ManualEntry,
    ManualEntryFile,
    ManualEntryLine,
    Tax,
    VatPeriod
  }

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @type api_error_type :: BexioApiClient.Helpers.api_error_type()

  @typedoc """
  One multipart/form-data part for uploading files to manual entries,
  following the `:form_multipart` format of `Req`.
  """
  @type file_upload_part :: {String.t() | atom(), any()}
  @type file_upload_parts :: [file_upload_part()]

  @doc """
  Fetch a list of accounts.
  """
  @spec fetch_accounts(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Account.t()]} | api_error_type()
  def fetch_accounts(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/accounts", params: opts_to_query(opts))
      end,
      &map_from_accounts/2
    )
  end

  @doc """
  Search accounts via query.
  The following search fields are supported:

  * account_no
  * fibo_account_group_id (TODO: test this)
  * name
  * account_type
  """
  @spec search_accounts(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Account.t()]} | api_error_type()
  def search_accounts(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/2.0/accounts/search",
          json: Enum.map(criteria, &update_account_type_in_search_criteria/1),
          params: opts_to_query(opts)
        )
      end,
      &map_from_accounts/2
    )
  end

  defp update_account_type_in_search_criteria(%SearchCriteria{
         field: :account_type,
         criteria: criteria,
         value: value
       }) do
    %SearchCriteria{
      field: :acount_type,
      criteria: criteria,
      value:
        case value do
          :earning -> 1
          :expenditure -> 2
          :active_account -> 3
          :passive_account -> 4
          :complete_account -> 5
        end
    }
  end

  defp update_account_type_in_search_criteria(search_criteria), do: search_criteria

  defp map_from_accounts(accounts, _env), do: Enum.map(accounts, &map_from_account/1)

  defp map_from_account(
         %{
           "id" => id,
           "account_no" => account_no,
           "name" => name,
           "fibu_account_group_id" => account_group_id,
           "account_type" => account_type_id,
           "tax_id" => tax_id,
           "is_active" => active?,
           "is_locked" => locked?
         },
         _env \\ nil
       ) do
    %Account{
      id: id,
      account_no: account_no,
      name: name,
      account_group_id: account_group_id,
      account_type: account_type(account_type_id),
      tax_id: tax_id,
      active?: active?,
      locked?: locked?
    }
  end

  defp account_type(1), do: :earning
  defp account_type(2), do: :expenditure
  defp account_type(3), do: :active_account
  defp account_type(4), do: :passive_account
  defp account_type(5), do: :complete_account

  @doc """
  Fetch a list of account groups.
  """
  @spec fetch_account_groups(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [AccountGroup.t()]} | api_error_type()
  def fetch_account_groups(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/account_groups", params: opts_to_query(opts))
      end,
      &map_from_account_groups/2
    )
  end

  defp map_from_account_groups(accounts, _env), do: Enum.map(accounts, &map_from_account_group/1)

  defp map_from_account_group(
         %{
           "id" => id,
           "account_no" => account_no,
           "name" => name,
           "parent_fibu_account_group_id" => parent_fibu_account_group_id,
           "is_active" => active?,
           "is_locked" => locked?
         },
         _env \\ nil
       ) do
    %AccountGroup{
      id: id,
      account_no: account_no,
      name: name,
      parent_fibu_account_group_id: parent_fibu_account_group_id,
      active?: active?,
      locked?: locked?
    }
  end

  @doc """
  Fetch a list of calendar years.
  """
  @spec fetch_calendar_years(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [CalendarYear.t()]} | api_error_type()
  def fetch_calendar_years(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/accounting/calendar_years", params: opts_to_query(opts))
      end,
      &map_from_calendar_years/2
    )
  end

  defp map_from_calendar_years(calendar_years, _env),
    do: Enum.map(calendar_years, &map_from_calendar_year/1)

  defp map_from_calendar_year(
         %{
           "id" => id,
           "start" => start,
           "end" => end_date,
           "is_vat_subject" => vat_subject?,
           "is_annual_reporting" => annual_reporting?,
           "created_at" => created_at,
           "updated_at" => updated_at,
           "vat_accounting_method" => vat_accounting_method,
           "vat_accounting_type" => vat_accounting_type
         },
         _env \\ nil
       ) do
    %CalendarYear{
      id: id,
      start: to_date(start),
      end: to_date(end_date),
      vat_subject?: vat_subject?,
      annual_reporting?: annual_reporting?,
      created_at: to_offset_datetime(created_at),
      updated_at: to_offset_datetime(updated_at),
      # both fields are null when the calendar year is not subjected to vat
      vat_accounting_method: to_enum(vat_accounting_method, [:effective, :net_tax]),
      vat_accounting_type: to_enum(vat_accounting_type, [:agreed, :collected])
    }
  end

  @doc """
  Create a calendar year.

  If only the year is given, the next year is created with the same settings
  as the year before, otherwise all settings must be given.

  The response is a list of calendar years because bexio creates all the years
  in between when creating a future year.
  """
  @spec create_calendar_year(
          req :: Req.Request.t(),
          year :: String.t() | non_neg_integer(),
          opts :: [
            {:vat_subject?, boolean()}
            | {:annual_reporting?, boolean()}
            | {:vat_accounting_method, :effective | :net_tax}
            | {:vat_accounting_type, :agreed | :collected}
            | {:default_tax_income_id, integer()}
            | {:default_tax_expense_id, integer()}
          ]
        ) :: {:ok, [CalendarYear.t()]} | api_error_type()
  def create_calendar_year(req, year, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/3.0/accounting/calendar_years",
          json: calendar_year_payload(year, opts)
        )
      end,
      &map_from_calendar_years/2
    )
  end

  defp calendar_year_payload(year, opts) do
    payload =
      %{year: to_string(year)}
      |> put_optional(opts, :vat_subject?, :is_vat_subject)
      |> put_optional(opts, :annual_reporting?, :is_annual_reporting)
      |> put_optional(opts, :default_tax_income_id)
      |> put_optional(opts, :default_tax_expense_id)

    payload =
      case Keyword.get(opts, :vat_accounting_method) do
        nil -> payload
        method -> Map.put(payload, :vat_accounting_method, Atom.to_string(method))
      end

    case Keyword.get(opts, :vat_accounting_type) do
      nil -> payload
      type -> Map.put(payload, :vat_accounting_type, Atom.to_string(type))
    end
  end

  defp put_optional(payload, opts, key, json_key \\ nil) do
    json_key = json_key || key

    case Keyword.get(opts, key) do
      nil -> payload
      value -> Map.put(payload, json_key, value)
    end
  end

  @doc """
  Search calendar years via query.

  If you want to search for the end date, use the `:like` criteria instead of
  `:equal`, because searching for equality requires the date in the format
  "2018-12-31 23:59:59".
  """
  @spec search_calendar_years(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [CalendarYear.t()]} | api_error_type()
  def search_calendar_years(req, criteria, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/3.0/accounting/calendar_years/search",
          json: criteria,
          params: opts_to_query(opts)
        )
      end,
      &map_from_calendar_years/2
    )
  end

  @doc """
  Fetch a single calendar year.
  """
  @spec fetch_calendar_year(
          req :: Req.Request.t(),
          calendar_year_id :: non_neg_integer()
        ) :: {:ok, CalendarYear.t()} | api_error_type()
  def fetch_calendar_year(req, calendar_year_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/accounting/calendar_years/#{calendar_year_id}")
      end,
      &map_from_calendar_year/2
    )
  end

  @doc """
  Fetch a list of currencies.
  """
  @spec fetch_currencies(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Currency.t()]} | api_error_type()
  def fetch_currencies(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/currencies", params: opts_to_query(opts))
      end,
      &map_from_currencies/2
    )
  end

  defp map_from_currencies(currencies, _env),
    do: Enum.map(currencies, &map_from_currency/1)

  defp map_from_currency(
         %{"id" => id, "name" => name, "round_factor" => round_factor} = currency,
         _env \\ nil
       ) do
    %Currency{
      id: id,
      name: name,
      round_factor: round_factor,
      # embedded default exchange rate fields; not present/null for the base currency
      exchange_rate: Map.get(currency, "exchange_rate"),
      exchange_rate_date: to_date(Map.get(currency, "exchange_rate_date")),
      exchange_rate_id: Map.get(currency, "exchange_rate_id"),
      exchange_rate_to_ratio: Map.get(currency, "exchange_rate_to_ratio"),
      ratio: Map.get(currency, "ratio"),
      source: Map.get(currency, "source"),
      source_reason: Map.get(currency, "source_reason")
    }
  end

  @doc """
  Fetch a single currency.
  """
  @spec fetch_currency(
          req :: Req.Request.t(),
          currency_id :: non_neg_integer()
        ) :: {:ok, Currency.t()} | api_error_type()
  def fetch_currency(req, currency_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/currencies/#{currency_id}")
      end,
      &map_from_currency/2
    )
  end

  @doc """
  Create a currency. The name must be in the ISO 4217 format and must be unique.
  """
  @spec create_currency(
          req :: Req.Request.t(),
          currency :: Currency.t()
        ) :: {:ok, Currency.t()} | api_error_type()
  def create_currency(req, currency) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/3.0/currencies", json: Map.take(currency, [:name, :round_factor]))
      end,
      &map_from_currency/2
    )
  end

  @doc """
  Update a currency (only the round factor can be changed).
  """
  @spec edit_currency(
          req :: Req.Request.t(),
          currency :: Currency.t()
        ) :: {:ok, Currency.t()} | api_error_type()
  def edit_currency(req, currency) do
    bexio_body_handling(
      fn ->
        Req.patch(
          req,
          url: "/3.0/currencies/#{currency.id}",
          json: Map.take(currency, [:round_factor])
        )
      end,
      &map_from_currency/2
    )
  end

  @doc """
  Delete a currency.
  """
  @spec delete_currency(
          req :: Req.Request.t(),
          currency_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_currency(req, currency_id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/3.0/currencies/#{currency_id}")
      end,
      &success_response/2
    )
  end

  @doc """
  Fetch all possible currency codes (in the format CHF, EUR, etc.).
  """
  @spec fetch_currency_codes(req :: Req.Request.t()) :: {:ok, [String.t()]} | api_error_type()
  def fetch_currency_codes(req) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/currencies/codes")
      end,
      &map_from_currency_codes/2
    )
  end

  # the docs show the currency codes nested in an outer list: [["EUR", "GBP", "PLN"]]
  defp map_from_currency_codes([first | _], _env) when is_list(first), do: first
  defp map_from_currency_codes(codes, _env), do: codes

  @doc """
  Fetch a list of currency exchange rates.
  """
  @spec fetch_exchange_rates(
          req :: Req.Request.t(),
          id :: integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [ExchangeRate.t()]} | api_error_type()
  def fetch_exchange_rates(req, id, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/currencies/#{id}/exchange_rates", params: opts_to_query(opts))
      end,
      &map_from_exchange_rates/2
    )
  end

  defp map_from_exchange_rates(exchange_rates, _env),
    do: Enum.map(exchange_rates, &map_from_exchange_rate/1)

  defp map_from_exchange_rate(%{
         "factor_nr" => factor_nr,
         "exchange_currency" => exchange_currency
       }) do
    %ExchangeRate{
      factor: factor_nr,
      exchange_currency: map_from_currency(exchange_currency)
    }
  end

  @doc """
  Fetch a list of taxes.

  Arguments:

  * `date` - all taxes which are active at the date given
  * `types` - filter the types of tax (:sales_tax or :pre_tax)
  """
  @spec fetch_taxes(
          req :: Req.Request.t(),
          date :: Date.t() | nil,
          types :: :sales_tax | :pre_tax | nil,
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [Tax.t()]} | api_error_type()
  def fetch_taxes(req, date \\ nil, types \\ nil, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req,
          url: "/3.0/taxes",
          params: opts |> opts_to_query() |> opts_with_date(date) |> opts_with_type(types)
        )
      end,
      &map_from_taxes/2
    )
  end

  defp opts_with_date(opts, nil), do: opts
  defp opts_with_date(opts, date), do: Keyword.put(opts, :date, Date.to_iso8601(date))
  defp opts_with_type(opts, nil), do: opts
  defp opts_with_type(type, opts), do: Keyword.put(opts, :types, type)

  defp map_from_taxes(taxes, _env), do: Enum.map(taxes, &map_from_tax/1)

  defp map_from_tax(
         %{
           "id" => id,
           "uuid" => uuid,
           "name" => name,
           "code" => code,
           "digit" => digit,
           "type" => type,
           "account_id" => account_id,
           "tax_settlement_type" => tax_settlement_type,
           "value" => value,
           "net_tax_value" => net_tax_value,
           "start_year" => start_year,
           "end_year" => end_year,
           "start_month" => start_month,
           "end_month" => end_month,
           "is_active" => active?,
           "display_name" => display_name
         },
         _env \\ nil
       ) do
    %Tax{
      id: id,
      uuid: uuid,
      name: name,
      code: code,
      digit: digit,
      type:
        to_enum(type, [
          :net_tax,
          :non_consideration_sales_tax,
          :pre_customs_tax_investment,
          :pre_customs_tax_material,
          :pre_regards_tax_investment,
          :pre_regards_tax_material,
          :pre_tax_investment,
          :pre_tax_material,
          :sales_tax
        ]),
      account_id: account_id,
      tax_settlement_type: tax_settlement_type,
      value: value,
      net_tax_value: net_tax_value,
      start_year: start_year,
      end_year: end_year,
      start_month: start_month,
      end_month: end_month,
      active?: active?,
      display_name: display_name
    }
  end

  @doc """
  Fetch a single tax.
  """
  @spec fetch_tax(
          req :: Req.Request.t(),
          tax_id :: non_neg_integer()
        ) :: {:ok, Tax.t()} | api_error_type()
  def fetch_tax(req, tax_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/taxes/#{tax_id}")
      end,
      &map_from_tax/2
    )
  end

  @doc """
  Delete a tax.

  Taxes which are used and/or referenced within bexio, and taxes assigned to
  the digit 000 can not be deleted — the API answers with a conflict error.
  """
  @spec delete_tax(
          req :: Req.Request.t(),
          tax_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_tax(req, tax_id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/3.0/taxes/#{tax_id}")
      end,
      &success_response/2
    )
  end

  @doc """
  Fetch a list of business years.
  """
  @spec fetch_business_years(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [BusinessYear.t()]} | api_error_type()
  def fetch_business_years(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/accounting/business_years", params: opts_to_query(opts))
      end,
      &map_from_business_years/2
    )
  end

  @doc """
  Fetch a single business year.
  """
  @spec fetch_business_year(
          req :: Req.Request.t(),
          business_year_id :: non_neg_integer()
        ) :: {:ok, BusinessYear.t()} | api_error_type()
  def fetch_business_year(req, business_year_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/accounting/business_years/#{business_year_id}")
      end,
      &map_from_business_year/2
    )
  end

  defp map_from_business_years(business_years, _env),
    do: Enum.map(business_years, &map_from_business_year/1)

  defp map_from_business_year(
         %{
           "id" => id,
           "start" => start,
           "end" => end_date,
           "status" => status
         } = business_year,
         _env \\ nil
       ) do
    %BusinessYear{
      id: id,
      start: to_date(start),
      end: to_date(end_date),
      status: String.to_atom(status),
      closed_at: to_date(Map.get(business_year, "closed_at"))
    }
  end

  @doc """
  Fetch a list of vat periods.
  """
  @spec fetch_vat_periods(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [VatPeriod.t()]} | api_error_type()
  def fetch_vat_periods(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/accounting/vat_periods", params: opts_to_query(opts))
      end,
      &map_from_vat_periods/2
    )
  end

  @doc """
  Fetch a single vat period.
  """
  @spec fetch_vat_period(
          req :: Req.Request.t(),
          vat_period_id :: non_neg_integer()
        ) :: {:ok, VatPeriod.t()} | api_error_type()
  def fetch_vat_period(req, vat_period_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/accounting/vat_periods/#{vat_period_id}")
      end,
      &map_from_vat_period/2
    )
  end

  defp map_from_vat_periods(vat_periods, _env), do: Enum.map(vat_periods, &map_from_vat_period/1)

  defp map_from_vat_period(
         %{
           "id" => id,
           "start" => start,
           "end" => end_date,
           "type" => type,
           "status" => status
         } = vat_period,
         _env \\ nil
       ) do
    %VatPeriod{
      id: id,
      start: to_date(start),
      end: to_date(end_date),
      type: String.to_atom(type),
      status: String.to_atom(status),
      closed_at: to_date(Map.get(vat_period, "closed_at"))
    }
  end

  @doc """
  Fetch the accounting journal.

  Arguments (in `opts`):

  * `:from` - filter for entries after this date
  * `:to` - filter for entries until this date
  * `:account_uuid` - filter for entries with an account with this uuid
  """
  @spec fetch_journal(
          req :: Req.Request.t(),
          opts :: [
            GlobalArguments.offset_without_order_by_arg()
            | {:from, Date.t()}
            | {:to, Date.t()}
            | {:account_uuid, String.t()}
          ]
        ) :: {:ok, [JournalEntry.t()]} | api_error_type()
  def fetch_journal(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req,
          url: "/3.0/accounting/journal",
          params:
            opts
            |> opts_to_query()
            |> opts_with_date(opts, :from)
            |> opts_with_date(opts, :to)
            |> opts_with_value(opts, :account_uuid)
        )
      end,
      &map_from_journal_entries/2
    )
  end

  defp opts_with_date(params, opts, key) do
    case Keyword.get(opts, key) do
      nil -> params
      date -> Keyword.put(params, key, Date.to_iso8601(date))
    end
  end

  defp opts_with_value(params, opts, key) do
    case Keyword.get(opts, key) do
      nil -> params
      value -> Keyword.put(params, key, value)
    end
  end

  defp map_from_journal_entries(journal_entries, _env),
    do: Enum.map(journal_entries, &map_from_journal_entry/1)

  defp map_from_journal_entry(
         %{
           "id" => id,
           "ref_id" => ref_id,
           "ref_uuid" => ref_uuid,
           "ref_class" => ref_class,
           "date" => date,
           "debit_account_id" => debit_account_id,
           "credit_account_id" => credit_account_id,
           "description" => description,
           "amount" => amount,
           "currency_id" => currency_id,
           "currency_factor" => currency_factor,
           "base_currency_id" => base_currency_id,
           "base_currency_amount" => base_currency_amount
         },
         _env \\ nil
       ) do
    %JournalEntry{
      id: id,
      ref_id: ref_id,
      ref_uuid: ref_uuid,
      ref_class: document_class(ref_class),
      date: to_offset_datetime(date),
      debit_account_id: debit_account_id,
      credit_account_id: credit_account_id,
      description: description,
      amount: to_decimal_amount(amount),
      currency_id: currency_id,
      currency_factor: currency_factor,
      base_currency_id: base_currency_id,
      base_currency_amount: to_decimal_amount(base_currency_amount)
    }
  end

  @doc """
  Fetch a list of manual entries.
  """
  @spec fetch_manual_entries(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [ManualEntry.t()]} | api_error_type()
  def fetch_manual_entries(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/accounting/manual_entries", params: opts_to_query(opts))
      end,
      &map_from_manual_entries/2
    )
  end

  @doc """
  Create a manual entry for the account ledger.
  """
  @spec create_manual_entry(
          req :: Req.Request.t(),
          manual_entry :: ManualEntry.t()
        ) :: {:ok, ManualEntry.t()} | api_error_type()
  def create_manual_entry(req, manual_entry) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/3.0/accounting/manual_entries",
          json: remap_manual_entry(manual_entry)
        )
      end,
      &map_from_manual_entry/2
    )
  end

  @doc """
  Update a manual entry.
  """
  @spec edit_manual_entry(
          req :: Req.Request.t(),
          manual_entry :: ManualEntry.t()
        ) :: {:ok, ManualEntry.t()} | api_error_type()
  def edit_manual_entry(req, manual_entry) do
    bexio_body_handling(
      fn ->
        Req.put(
          req,
          url: "/3.0/accounting/manual_entries/#{manual_entry.id}",
          json: remap_manual_entry(manual_entry)
        )
      end,
      &map_from_manual_entry/2
    )
  end

  @doc """
  Delete a manual entry.
  """
  @spec delete_manual_entry(
          req :: Req.Request.t(),
          manual_entry_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_manual_entry(req, manual_entry_id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/3.0/accounting/manual_entries/#{manual_entry_id}")
      end,
      &success_response/2
    )
  end

  @doc """
  Fetch the next reference number for a manual entry.
  """
  @spec fetch_next_manual_entry_reference_nr(req :: Req.Request.t()) ::
          {:ok, String.t()} | api_error_type()
  def fetch_next_manual_entry_reference_nr(req) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/accounting/manual_entries/next_ref_nr")
      end,
      fn %{"next_ref_nr" => next_ref_nr}, _env -> next_ref_nr end
    )
  end

  @doc """
  Fetch the files attached to a manual entry line.
  """
  @spec fetch_manual_entry_line_files(
          req :: Req.Request.t(),
          manual_entry_id :: non_neg_integer(),
          entry_id :: non_neg_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [ManualEntryFile.t()]} | api_error_type()
  def fetch_manual_entry_line_files(req, manual_entry_id, entry_id, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/3.0/accounting/manual_entries/#{manual_entry_id}/entries/#{entry_id}/files",
          params: opts_to_query(opts)
        )
      end,
      &map_from_manual_entry_files/2
    )
  end

  @doc """
  Upload one or multiple files and attach them to a manual entry line
  (only for the entry types `:manual_single_entry` and `:manual_group_entry`).

  The `files` are passed to `Req` as `:form_multipart`, e.g.:

      [fileName1: {"<file content>", filename: "screenshot.png"}]

  Max. file size is 12MB, supported formats are PNG, JPG, JPEG, GIF, DOC,
  DOCX, XLS, XLSX, PPT, PPTX and PDF.
  """
  @spec add_manual_entry_line_file(
          req :: Req.Request.t(),
          manual_entry_id :: non_neg_integer(),
          entry_id :: non_neg_integer(),
          files :: file_upload_parts()
        ) :: {:ok, [ManualEntryFile.t()]} | api_error_type()
  def add_manual_entry_line_file(req, manual_entry_id, entry_id, files) do
    bexio_body_handling(
      fn ->
        upload_manual_entry_files(
          req,
          "/3.0/accounting/manual_entries/#{manual_entry_id}/entries/#{entry_id}/files",
          files
        )
      end,
      &map_from_manual_entry_files/2
    )
  end

  @doc """
  Fetch a file attached to a manual entry line
  (only for the entry types `:manual_single_entry` and `:manual_group_entry`).
  """
  @spec fetch_manual_entry_line_file(
          req :: Req.Request.t(),
          manual_entry_id :: non_neg_integer(),
          entry_id :: non_neg_integer(),
          file_id :: non_neg_integer()
        ) :: {:ok, ManualEntryFile.t()} | api_error_type()
  def fetch_manual_entry_line_file(req, manual_entry_id, entry_id, file_id) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url:
            "/3.0/accounting/manual_entries/#{manual_entry_id}/entries/#{entry_id}/files/#{file_id}"
        )
      end,
      &map_from_manual_entry_file/2
    )
  end

  @doc """
  Delete the connection between a file and a manual entry line
  (only for the entry types `:manual_single_entry` and `:manual_group_entry`).
  """
  @spec delete_manual_entry_line_file(
          req :: Req.Request.t(),
          manual_entry_id :: non_neg_integer(),
          entry_id :: non_neg_integer(),
          file_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_manual_entry_line_file(req, manual_entry_id, entry_id, file_id) do
    bexio_body_handling(
      fn ->
        Req.delete(
          req,
          url:
            "/3.0/accounting/manual_entries/#{manual_entry_id}/entries/#{entry_id}/files/#{file_id}"
        )
      end,
      &success_response/2
    )
  end

  @doc """
  Fetch the files attached to a manual compound entry.
  """
  @spec fetch_manual_compound_entry_files(
          req :: Req.Request.t(),
          manual_entry_id :: non_neg_integer(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, [ManualEntryFile.t()]} | api_error_type()
  def fetch_manual_compound_entry_files(req, manual_entry_id, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/3.0/accounting/manual_entries/#{manual_entry_id}/files",
          params: opts_to_query(opts)
        )
      end,
      &map_from_manual_entry_files/2
    )
  end

  @doc """
  Upload one or multiple files and attach them to a manual compound entry.

  The `files` are passed to `Req` as `:form_multipart`, e.g.:

      [fileName1: {"<file content>", filename: "screenshot.png"}]

  Max. file size is 12MB, supported formats are PNG, JPG, JPEG, GIF, DOC,
  DOCX, XLS, XLSX, PPT, PPTX and PDF.
  """
  @spec add_manual_compound_entry_file(
          req :: Req.Request.t(),
          manual_entry_id :: non_neg_integer(),
          files :: file_upload_parts()
        ) :: {:ok, [ManualEntryFile.t()]} | api_error_type()
  def add_manual_compound_entry_file(req, manual_entry_id, files) do
    bexio_body_handling(
      fn ->
        upload_manual_entry_files(
          req,
          "/3.0/accounting/manual_entries/#{manual_entry_id}/files",
          files
        )
      end,
      &map_from_manual_entry_files/2
    )
  end

  @doc """
  Fetch a file attached to a manual compound entry.
  """
  @spec fetch_manual_compound_entry_file(
          req :: Req.Request.t(),
          manual_entry_id :: non_neg_integer(),
          file_id :: non_neg_integer()
        ) :: {:ok, ManualEntryFile.t()} | api_error_type()
  def fetch_manual_compound_entry_file(req, manual_entry_id, file_id) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/3.0/accounting/manual_entries/#{manual_entry_id}/files/#{file_id}"
        )
      end,
      &map_from_manual_entry_file/2
    )
  end

  @doc """
  Delete the connection between a file and a manual compound entry.
  """
  @spec delete_manual_compound_entry_file(
          req :: Req.Request.t(),
          manual_entry_id :: non_neg_integer(),
          file_id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_manual_compound_entry_file(req, manual_entry_id, file_id) do
    bexio_body_handling(
      fn ->
        Req.delete(
          req,
          url: "/3.0/accounting/manual_entries/#{manual_entry_id}/files/#{file_id}"
        )
      end,
      &success_response/2
    )
  end

  # the base client sets a default content-type header, so the multipart
  # content-type (including the boundary) has to be set explicitly
  defp upload_manual_entry_files(req, url, files) do
    multipart = Req.Utils.encode_form_multipart(files)

    Req.post(req,
      url: url,
      body: multipart.body,
      headers: [{"content-type", multipart.content_type}]
    )
  end

  defp remap_manual_entry(%ManualEntry{} = manual_entry) do
    %{
      id: manual_entry.id,
      type: Atom.to_string(manual_entry.type),
      date: to_iso8601(manual_entry.date),
      reference_nr: manual_entry.reference_nr,
      entries: Enum.map(manual_entry.entries, &remap_manual_entry_line/1)
    }
    |> reject_nil_values()
  end

  defp remap_manual_entry_line(%ManualEntryLine{} = line) do
    %{
      id: line.id,
      debit_account_id: line.debit_account_id,
      credit_account_id: line.credit_account_id,
      tax_id: line.tax_id,
      tax_account_id: line.tax_account_id,
      description: line.description,
      amount: decimal_to_string(line.amount),
      currency_id: line.currency_id,
      base_currency_id: line.base_currency_id,
      currency_factor: line.currency_factor,
      base_currency_amount: decimal_to_string(line.base_currency_amount)
    }
    |> reject_nil_values()
  end

  defp decimal_to_string(nil), do: nil
  defp decimal_to_string(decimal), do: Decimal.to_string(decimal, :normal)

  defp to_decimal_amount(nil), do: nil
  defp to_decimal_amount(amount) when is_binary(amount), do: to_decimal(amount)
  defp to_decimal_amount(amount) when is_float(amount), do: Decimal.from_float(amount)
  defp to_decimal_amount(amount) when is_integer(amount), do: Decimal.new(amount)

  defp reject_nil_values(map) do
    map
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  defp map_from_manual_entries(manual_entries, _env),
    do: Enum.map(manual_entries, &map_from_manual_entry/1)

  defp map_from_manual_entry(
         %{
           "id" => id,
           "type" => type,
           "date" => date,
           "entries" => entries,
           "is_locked" => locked?
         } = manual_entry,
         _env \\ nil
       ) do
    %ManualEntry{
      id: id,
      type: String.to_atom(type),
      date: to_date(date),
      reference_nr: Map.get(manual_entry, "reference_nr"),
      created_by_user_id: Map.get(manual_entry, "created_by_user_id"),
      edited_by_user_id: Map.get(manual_entry, "edited_by_user_id"),
      entries: Enum.map(entries, &map_from_manual_entry_line/1),
      locked?: locked?,
      locked_info: Map.get(manual_entry, "locked_info")
    }
  end

  defp map_from_manual_entry_line(
         %{
           "date" => date,
           "debit_account_id" => debit_account_id,
           "credit_account_id" => credit_account_id,
           "amount" => amount,
           "currency_id" => currency_id
         } = entry,
         _env \\ nil
       ) do
    %ManualEntryLine{
      id: Map.get(entry, "id"),
      date: to_date(date),
      debit_account_id: debit_account_id,
      credit_account_id: credit_account_id,
      tax_id: Map.get(entry, "tax_id"),
      tax_account_id: Map.get(entry, "tax_account_id"),
      description: Map.get(entry, "description"),
      amount: to_decimal_amount(amount),
      currency_id: currency_id,
      base_currency_id: Map.get(entry, "base_currency_id"),
      currency_factor: Map.get(entry, "currency_factor"),
      base_currency_amount: to_decimal_amount(Map.get(entry, "base_currency_amount")),
      created_by_user_id: Map.get(entry, "created_by_user_id"),
      edited_by_user_id: Map.get(entry, "edited_by_user_id")
    }
  end

  defp map_from_manual_entry_files(files, _env),
    do: Enum.map(files, &map_from_manual_entry_file/1)

  defp map_from_manual_entry_file(
         %{
           "id" => id,
           "uuid" => uuid,
           "name" => name,
           "size_in_bytes" => size_in_bytes,
           "extension" => extension,
           "mime_type" => mime_type,
           "user_id" => user_id,
           "is_archived" => archived?,
           "is_referenced" => referenced?,
           "created_at" => created_at
         } = file,
         _env \\ nil
       ) do
    source_type = Map.get(file, "source_type")

    %ManualEntryFile{
      id: id,
      uuid: uuid,
      name: name,
      size_in_bytes: size_in_bytes,
      extension: String.to_atom(extension),
      mime_type: mime_type,
      uploader_email: Map.get(file, "uploader_email"),
      user_id: user_id,
      archived?: archived?,
      source_type: if(is_nil(source_type), do: nil, else: String.to_atom(source_type)),
      # deprecated by bexio in favor of source_type; not always present
      source_id: Map.get(file, "source_id"),
      referenced?: referenced?,
      created_at: to_offset_datetime(created_at),
      data: Map.get(file, "data")
    }
  end
end
