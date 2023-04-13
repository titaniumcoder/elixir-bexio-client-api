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
      #Decimal<2.331>
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

  @spec string_to_array(String.t() | nil) :: [integer()]
  def string_to_array(nil), do: []

  def string_to_array(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.uniq()
    |> Enum.sort()
  end

  @spec bexio_return_handling(call :: (() -> any()), callback :: (any() -> any())) ::
          {:ok, any()}
          | {:error,
             :invalid_access
             | :unauthorized
             | :not_found
             | :length_required
             | :invalid_data
             | :could_not_be_saved
             | :rate_limited
             | :unexpected_api_condition
             | :api_not_available}
  def bexio_return_handling(call, callback) do
    case call.() do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, callback.(body)}

      {:ok, %Tesla.Env{status: 201, body: body}} ->
        {:ok, callback.(body)}

      {:ok, %Tesla.Env{status: 301, body: body}} ->
        {:ok, callback.(body)}

      {:ok, %Tesla.Env{status: 401}} ->
        {:error, :invalid_access}

      {:ok, %Tesla.Env{status: 403}} ->
        {:error, :unauthorized}

      {:ok, %Tesla.Env{status: 404}} ->
        {:error, :not_found}

      {:ok, %Tesla.Env{status: 411}} ->
        {:error, :length_required}

      {:ok, %Tesla.Env{status: 415}} ->
        {:error, :invalid_data}

      {:ok, %Tesla.Env{status: 422}} ->
        {:error, :could_not_be_saved}

      {:ok, %Tesla.Env{status: 429}} ->
        {:error, :rate_limited}

      {:ok, %Tesla.Env{status: 500}} ->
        {:error, :unexpected_api_condition}

      {:ok, %Tesla.Env{status: 503}} ->
        {:error, :api_not_available}

      {:error, error} ->
        {:error, error}
    end
  end
end
