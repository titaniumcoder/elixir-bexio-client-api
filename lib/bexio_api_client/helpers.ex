defmodule BexioApiClient.Helpers do
  @moduledoc """
  Helper Functionality used in multiple places mostly to work around different type of the api and elixir
  """

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

  # The format from Bexio is 2022-09-13 09:14:21
  @doc """
  Convert the given string into an Elixir date.

  Examples:
      iex> BexioApiClient.Helpers.to_datetime(nil)
      nil

      iex> BexioApiClient.Helpers.to_datetime("2022-09-13 09:14:21")
      ~U[2022-09-13 07:14:21Z]
  """
  @spec to_datetime(String.t() |  nil) :: DateTime.t() | nil
  def to_datetime(nil), do: nil
  def to_datetime(datetime) do
    [zurich_date, zurich_time] = String.split(datetime, " ")
    date = Date.from_iso8601!(zurich_date)
    time = Time.from_iso8601!(zurich_time)
    DateTime.new!(date, time, "Europe/Zurich") |> DateTime.shift_zone!("Etc/UTC")
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
end
