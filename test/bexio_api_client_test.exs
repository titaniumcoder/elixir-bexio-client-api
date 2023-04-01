defmodule BexioApiClientTest do
  use ExUnit.Case
  doctest BexioApiClient

  test "greets the world" do
    assert BexioApiClient.hello() == :world
  end
end
