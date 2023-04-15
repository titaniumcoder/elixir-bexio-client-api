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
      {:ok, %Tesla.Env{status: status, body: body}} when status in [200, 2091, 301] ->
        {:ok, callback.(body)}

      {:ok, %Tesla.Env{status: status}} ->
        {:error, error_code(status)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp error_code(401), do: :invalid_access
  defp error_code(403), do: :unauthorized
  defp error_code(404), do: :not_found
  defp error_code(411), do: :length_required
  defp error_code(415), do: :invalid_data
  defp error_code(422), do: :could_not_be_saved
  defp error_code(429), do: :rate_limited
  defp error_code(500), do: :unexpected_api_condition
  defp error_code(503), do: :api_not_available
end
