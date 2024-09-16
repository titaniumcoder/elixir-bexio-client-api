defmodule BexioApiClient.Req.RewriteDelayTest do
  use ExUnit.Case, async: true

  describe "should work when the header is available" do
    test "should return the delay" do
      assert {:delay, 15000} ==
               BexioApiClient.Req.RewriteDelay.retry(
                 %Req.Request{},
                 %Req.Response{status: 429, headers: %{"ratelimit-reset" => ["15"]}}
               )
    end
  end

  describe "should use normal limits when not available" do
    test "should return true" do
      assert true ==
               BexioApiClient.Req.RewriteDelay.retry(
                 %Req.Request{},
                 %Req.Response{status: 429, headers: %{}}
               )
    end
  end

  describe "should just retry on other error-retry-status" do
    test "should return true" do
      Enum.each([408, 500, 502, 503, 504], fn status ->
        assert true ==
                 BexioApiClient.Req.RewriteDelay.retry(
                   %Req.Request{},
                   %Req.Response{status: status}
                 )
      end)
    end
  end

  describe "should do nothing on normal status responses" do
    test "should return true" do
      Enum.each([200, 201, 400, 404, 301], fn status ->
        assert false ==
                 BexioApiClient.Req.RewriteDelay.retry(
                   %Req.Request{},
                   %Req.Response{status: status}
                 )
      end)
    end
  end
end
