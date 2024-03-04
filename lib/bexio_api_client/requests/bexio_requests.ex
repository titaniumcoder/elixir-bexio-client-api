defmodule BexioApiClient.Requests.BexioRequests do
  use GenServer

  require Logger

  def start_requests(api_key) do
    GenServer.start(__MODULE__, api_key: api_key)
  end

  def start_requests(client_id, client_secret, refresh_token) do
    GenServer.start(__MODULE__,
      client_id: client_id,
      client_secret: client_secret,
      refresh_token: refresh_token
    )
  end

  # TODO child spec
  @impl GenServer
  def child_spec(args) do
    Logger.debug("Child spec with #{inspect(args)}")
  end

  # Server API

  @impl GenServer
  def init(args) do
    Logger.debug("Init with #{inspect(args)}")

    access_token = Keyword.get(args, :api_key)
    refresh_token = Keyword.get(args, :refresh_token)
    client_id = Keyword.get(args, :client_id)
    client_secret = Keyword.get(args, :client_secret)

    init = %{
      limit: nil,
      time_till_rate_reset: nil,
      queue: [],
      access_token: nil,
      refresh_token: nil,
      client_id: nil,
      client_secret: nil,
      refresh_token_expiration: nil
    }

    cond do
      client_id != nil and client_secret != nil and refresh_token != nil ->
        # probably could just to a direct call even without send_after
        Process.send_after(self(), :access_token, 100)

        {:ok,
         init
         |> Map.merge(init, %{
           client_id: client_id,
           client_secret: client_secret,
           refresh_token: refresh_token
         })}

      access_token != nil ->
        Logger.debug("Using an API Key, not recommended anymore!")

        {:ok, Map.put(init, access_token, access_token)}

      true ->
        Logger.error("Neither Client Request Flow nor Access Key is defined, stopping")

        {:error, :not_initialized}
    end

    {:ok}
  end

  @impl GenServer
  def handle_cast(:refresh_token, state) do
    # Tesla.post("https://idp.bexio.com/token", %{
    #  "grant_type" => "refresh_token",
    #  "refresh_token" => refresh_token
    # })

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast(:rate_limit, state) do
    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:request, request}, _from, state) do
    # TODO do this async!
    response = Req.run_request(request)

    {:reply, response, state}
  end
end
