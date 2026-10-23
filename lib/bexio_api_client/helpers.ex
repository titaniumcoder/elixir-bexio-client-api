defmodule BexioApiClient.Helpers do
  @moduledoc false

  @doc """
  Convert the given string into an Elixir date.

  Examples:
      iex> BexioApiClient.Helpers.to_date(nil)
      nil

      iex> BexioApiClient.Helpers.to_date("2013-02-22")
      ~D[2013-02-22]
  """
  @spec to_date(String.t() | nil) :: Date.t() | nil
  def to_date(nil), do: nil

  def to_date(date) do
    Date.from_iso8601!(date)
  end

  @doc """
  Convert the given string into an Elixir decimal.

  Examples:
      iex> BexioApiClient.Helpers.to_decimal(nil)
      nil

      iex> BexioApiClient.Helpers.to_decimal("2.331")
      Decimal.new("2.331")
  """
  @spec to_decimal(String.t() | nil) :: Decimal.t() | nil
  def to_decimal(nil), do: nil
  def to_decimal(decimal), do: Decimal.new(decimal)

  # The format from Bexio is 2022-09-13 09:14:21
  @doc """
  Convert the given string into an Elixir date.

  Examples:
      iex> BexioApiClient.Helpers.to_datetime(nil)
      nil

      iex> BexioApiClient.Helpers.to_datetime("2022-09-13 09:14:21")
      ~N[2022-09-13 09:14:21]
  """
  @spec to_datetime(String.t() | nil) :: DateTime.t() | nil
  def to_datetime(nil), do: nil

  def to_datetime(datetime) do
    [zurich_date, zurich_time] = String.split(datetime, " ")
    date = Date.from_iso8601!(zurich_date)
    time = Time.from_iso8601!(zurich_time)
    NaiveDateTime.new!(date, time)
  end

  def to_iso8601(nil), do: nil
  def to_iso8601(%NaiveDateTime{} = n), do: NaiveDateTime.to_iso8601(n)
  def to_iso8601(%DateTime{} = dt), do: DateTime.to_iso8601(dt)
  def to_iso8601(%Date{} = dt), do: Date.to_iso8601(dt)

  def to_naive_string(nil), do: nil
  def to_naive_string(n), do: NaiveDateTime.to_string(n)

  # The format from Bexio 3.0 is 2022-09-13T09:14:21+00:00
  @doc """
  Convert the given string into an elixir date using offsets

  Examples:
      iex> BexioApiClient.Helpers.to_offset_datetime(nil)
      nil

      iex> BexioApiClient.Helpers.to_offset_datetime("2022-09-13T09:14:21+02:00")
      ~U[2022-09-13 07:14:21Z]
  """
  def to_offset_datetime(nil), do: nil

  def to_offset_datetime(datetime) do
    case DateTime.from_iso8601(datetime) do
      {:ok, datetime, _offset} -> datetime
      {:error, error} -> raise ArgumentError, message: error
    end
  end

  @spec string_to_array(String.t() | nil) :: [integer()]
  def string_to_array(nil), do: []

  def string_to_array(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.uniq()
    |> Enum.sort()
  end

  @type handler_callback_result_type :: any()
  @type body_callback_type :: any()
  @type api_error_type ::
          {:error,
           :invalid_access
           | :unauthorized
           | :not_found
           | :length_required
           | :invalid_data
           | :could_not_be_saved
           | :rate_limited
           | :unexpected_api_condition
           | :api_not_available
           | :conflict, nil | any()}
          | {:error, nil | any()}

  @spec bexio_body_handling(
          call :: (-> body_callback_type),
          callback :: (body_callback_type, Req.Response.t() -> handler_callback_result_type)
        ) ::
          {:ok, handler_callback_result_type} | api_error_type
  def bexio_body_handling(call, callback) do
    bexio_handling(call, fn body, env ->
      {:ok, callback.(body, env)}
    end)
  end

  @doc """
  Like `bexio_body_handling/2`, but for endpoints that respond with `204 No Content`
  (e.g. the payroll v4 endpoints) on success instead of a JSON body.

  Returns `{:ok, true}` for a `204` response, otherwise behaves like
  `bexio_handling/2` (the `callback` is only invoked for `200`/`201` responses).
  """
  @spec bexio_no_content_handling(
          call :: (-> body_callback_type),
          callback :: (body_callback_type, Req.Response.t() -> handler_callback_result_type)
        ) ::
          {:ok, handler_callback_result_type} | api_error_type
  def bexio_no_content_handling(call, callback \\ fn _body, _env -> true end) do
    case call.() do
      {:ok, %Req.Response{status: 204}} ->
        {:ok, true}

      response ->
        bexio_handling(fn -> response end, callback)
    end
  end

  @spec bexio_handling(
          call :: (-> body_callback_type),
          callback :: (body_callback_type, Req.Response.t() -> handler_callback_result_type)
        ) ::
          handler_callback_result_type | api_error_type() | {:error, nil | any()}
  def bexio_handling(call, callback) do
    case call.() do
      {:ok, %Req.Response{status: status, body: body} = response} when status in [200, 201] ->
        callback.(body, response)

      {:ok, %Req.Response{status: status, body: body}} ->
        {:error, error_code(status), body}

      {:error, error} ->
        {:error, error}
    end
  end

  defp error_code(400), do: :bad_request
  defp error_code(401), do: :invalid_access
  defp error_code(403), do: :unauthorized
  defp error_code(404), do: :not_found
  defp error_code(411), do: :length_required
  defp error_code(415), do: :invalid_data
  defp error_code(422), do: :could_not_be_saved
  defp error_code(429), do: :rate_limited
  defp error_code(409), do: :conflict
  defp error_code(500), do: :unexpected_api_condition
  defp error_code(502), do: :bad_gateway
  defp error_code(503), do: :api_not_available

  @doc """
  converts a list of maps ("id" => id, "name" => name) into a single map with all values converted to %{id: name}

  Examples:

    iex> BexioApiClient.Helpers.body_to_map([%{"id" => 1, "name" => "hello"}, %{"id" => 2, "name" => "world"}], nil)
    %{1 => "hello", 2 => "world"}

  """
  @spec body_to_map(list(%{String.t() => any()}), Req.Response.t()) :: %{integer() => String.t()}
  def body_to_map(body, _env) do
    body
    |> Enum.map(fn %{"id" => id, "name" => name} -> {id, name} end)
    |> Enum.into(%{})
  end

  @doc """
  Converts the pattern %{"id" => id, "name" => name} into %{id: id, name: name}

  Examples:

    iex> BexioApiClient.Helpers.id_name(%{"id" => 1, "name" => "hello"}, nil)
    %{id: 1, name: "hello"}

  """
  @spec id_name(%{String.t() => any()}, Req.Response.t()) :: %{id: integer(), name: String.t()}
  def id_name(%{"id" => id, "name" => name}, _env), do: %{id: id, name: name}

  @doc """
  Just interprets the delete result into either true or false depending on the success key in the map

  Example:

    iex> BexioApiClient.Helpers.success_response(%{"success" => true}, %Req.Response{})
    true

    iex> BexioApiClient.Helpers.success_response(%{"failure" => true}, %Req.Response{})
    false

  """
  @spec success_response(map(), Req.Response.t()) :: boolean()
  def success_response(%{"success" => true}, _env), do: true
  def success_response(_result, _env), do: false

  @spec decimal_nil_as_zero(nil | integer() | binary() | float()) :: Decimal.t()
  def decimal_nil_as_zero(nil), do: Decimal.new(0)

  def decimal_nil_as_zero(number) when is_integer(number) or is_binary(number),
    do: Decimal.new(number)

  def decimal_nil_as_zero(number) when is_float(number), do: Decimal.from_float(number)

  @doc """
  Converts a string into an atom when the value is a member of the documented
  `values` enum, otherwise keeps the string.

  The atom literals in `values` must be written in compiled code (e.g. as a
  literal list at the call site or in a module attribute) so that
  `String.to_existing_atom/1` cannot create new atoms at runtime.

  ## Examples

      iex> BexioApiClient.Helpers.to_enum("effective", [:effective, :net_tax])
      :effective

      iex> BexioApiClient.Helpers.to_enum("something_new", [:effective, :net_tax])
      "something_new"

      iex> BexioApiClient.Helpers.to_enum(nil, [:effective, :net_tax])
      nil
  """
  @spec to_enum(nil | String.t() | atom(), [atom()]) :: nil | atom() | String.t()
  def to_enum(nil, _values), do: nil

  def to_enum(value, values) when is_binary(value) do
    if value in Enum.map(values, &Atom.to_string/1) do
      String.to_existing_atom(value)
    else
      value
    end
  end

  def to_enum(value, _values) when is_atom(value), do: value

  @doc """
  Converts a bexio document class name (`KbOffer`, `KbOrder`, `KbInvoice`,
  `KbDelivery` — as returned by e.g. `kb_item_class` and `ref_class` fields)
  into an idiomatic atom, keeping unknown class names as strings.

  ## Examples

      iex> BexioApiClient.Helpers.document_class("KbInvoice")
      :kb_invoice

      iex> BexioApiClient.Helpers.document_class("KbSomethingNew")
      "KbSomethingNew"

      iex> BexioApiClient.Helpers.document_class(nil)
      nil
  """
  @spec document_class(nil | String.t()) ::
          nil | :kb_offer | :kb_order | :kb_invoice | :kb_delivery | String.t()
  def document_class(nil), do: nil
  def document_class("KbOffer"), do: :kb_offer
  def document_class("KbOrder"), do: :kb_order
  def document_class("KbInvoice"), do: :kb_invoice
  def document_class("KbDelivery"), do: :kb_delivery
  def document_class(other), do: other

  @spec remove_document_no_if_nil(map() | nil) :: map() | nil
  def remove_document_no_if_nil(nil), do: nil
  def remove_document_no_if_nil(%{document_nr: nil} = map), do: Map.delete(map, :document_nr)
  def remove_document_no_if_nil(map_without), do: map_without
end
