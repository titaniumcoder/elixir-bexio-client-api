defmodule BexioApiClient.Req.RewriteDelayTest do
  use ExUnit.Case, async: false

  describe "should work when the header is available" do
    test "should return the delay" do
      assert {:delay, 15000} ==
               BexioApiClient.Req.RewriteDelay.retry(
                 %Req.Request{},
                 %Req.Response{status: 429, headers: %{"ratelimit-reset" => ["15"]}}
               )
    end

    test "should emit telemetry event with reset seconds" do
      test_pid = self()

      :telemetry.attach(
        "test-rate-limit-handler",
        [:bexio_api_client, :rate_limit, :hit],
        fn event, measurements, metadata, _config ->
          send(test_pid, {:telemetry_event, event, measurements, metadata})
        end,
        nil
      )

      BexioApiClient.Req.RewriteDelay.retry(
        %Req.Request{},
        %Req.Response{status: 429, headers: %{"ratelimit-reset" => ["15"]}}
      )

      assert_receive {:telemetry_event, [:bexio_api_client, :rate_limit, :hit],
                      %{reset_seconds: 15}, %{has_reset_header: true}}

      :telemetry.detach("test-rate-limit-handler")
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

    test "should emit telemetry event without reset seconds" do
      test_pid = self()

      :telemetry.attach(
        "test-rate-limit-no-header-handler",
        [:bexio_api_client, :rate_limit, :hit],
        fn event, measurements, metadata, _config ->
          send(test_pid, {:telemetry_event, event, measurements, metadata})
        end,
        nil
      )

      BexioApiClient.Req.RewriteDelay.retry(
        %Req.Request{},
        %Req.Response{status: 429, headers: %{}}
      )

      assert_receive {:telemetry_event, [:bexio_api_client, :rate_limit, :hit],
                      %{reset_seconds: 0}, %{has_reset_header: false}}

      :telemetry.detach("test-rate-limit-no-header-handler")
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

    test "should emit retry telemetry event" do
      test_pid = self()

      :telemetry.attach(
        "test-retry-handler",
        [:bexio_api_client, :request, :retry],
        fn event, measurements, metadata, _config ->
          send(test_pid, {:telemetry_event, event, measurements, metadata})
        end,
        nil
      )

      Enum.each([408, 500, 502, 503, 504], fn status ->
        BexioApiClient.Req.RewriteDelay.retry(
          %Req.Request{},
          %Req.Response{status: status}
        )

        assert_receive {:telemetry_event, [:bexio_api_client, :request, :retry], %{count: 1},
                        %{status: ^status}}
      end)

      :telemetry.detach("test-retry-handler")
    end
  end

  describe "should do nothing on normal status responses" do
    test "should return false" do
      Enum.each([200, 201, 400, 404, 301], fn status ->
        assert false ==
                 BexioApiClient.Req.RewriteDelay.retry(
                   %Req.Request{},
                   %Req.Response{status: status}
                 )
      end)
    end

    test "should emit success telemetry event for 2xx and 3xx statuses" do
      test_pid = self()

      :telemetry.attach(
        "test-success-handler",
        [:bexio_api_client, :request, :success],
        fn event, measurements, metadata, _config ->
          send(test_pid, {:telemetry_event, event, measurements, metadata})
        end,
        nil
      )

      Enum.each([200, 201, 301], fn status ->
        BexioApiClient.Req.RewriteDelay.retry(
          %Req.Request{},
          %Req.Response{status: status}
        )

        assert_receive {:telemetry_event, [:bexio_api_client, :request, :success], %{count: 1},
                        %{status: ^status}}
      end)

      :telemetry.detach("test-success-handler")
    end

    test "should emit error telemetry event for 4xx statuses" do
      test_pid = self()

      :telemetry.attach(
        "test-error-4xx-handler",
        [:bexio_api_client, :request, :error],
        fn event, measurements, metadata, _config ->
          send(test_pid, {:telemetry_event, event, measurements, metadata})
        end,
        nil
      )

      Enum.each([400, 401, 404], fn status ->
        BexioApiClient.Req.RewriteDelay.retry(
          %Req.Request{},
          %Req.Response{status: status}
        )

        assert_receive {:telemetry_event, [:bexio_api_client, :request, :error], %{count: 1},
                        %{status: ^status}}
      end)

      :telemetry.detach("test-error-4xx-handler")
    end
  end
end
