defmodule TestHelper do
  @doc false
  defmacro __using__(_opts) do
    quote do
      import Req.Test, only: [json: 2]

      import TestHelper
      import Plug.Conn
    end
  end

  def mock_request(func) do
    Req.Test.stub(BexioApiClient, fn conn -> func.(conn) end)
  end
end

Calendar.put_time_zone_database(Tz.TimeZoneDatabase)
ExUnit.start(exclude: [:skip])
