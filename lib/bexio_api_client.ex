defmodule BexioApiClient do
  use GenServer

  require Logger

  @base_request_options [
    base_url: "https://api.bexio.com",
    headers: [accept: "application/json"],
    retry: :transient
  ]

  @moduledoc """
  Base Module for the API Client. It's a GenServer that will receive normal requests and will handle the API calls while also adding some
  base functionality like refreshing the access token.

  The API Documentation for Bexio can be found under https://docs.bexio.com.

<<<<<<< HEAD
  Fields or arguments with date time reference expect them in the time zone Europe/Zurich.

  ## Requirements:

    * Http Client:
    ** Req: the api client depends on Req.

  """

  alias BexioApiClient.Requests.BexioAuth

  @doc """
  Create a Req that can be used to call the Bexio API with the correct headers and everything prepared when the input is an API Token (https://office.bexio.com/index.php/admin/apiTokens)

  Rate Limits:

  Bexio APIs are rate limited, using 429 to indicate too many requests.

  Retries: there are automatic retries on the following status codes:

  * 500, 502, 503: server errors that probably will be fixed. will use an exponential backoff if possible for the retries to give the server time to recover
  * 429 will be handled using the header ratelimit-reset if available else waiting for 1 minute
  """
  def create_req(api_token, opts \\ []) do
    # TODO improve logic for 429 replies where I want to wait for 1 minute!
    jitter_delay_function = fn n ->
      trunc(Integer.pow(2, n) * 1000 * (1 - 0.1 * :rand.uniform()))
    end

    req =
      Req.new(
        base_url: "https://api.bexio.com",
        retry_delay: jitter_delay_function,
        auth: {:bearer, api_token},
        headers: {"accept", "application/json"}
      )
=======
  Fields or arguments with date time reference expect them in the time zone Europe/Zurich. FIXME: should probably switch to UTC or make it configurable
  """

  @impl GenServer
  def init(args) do
    Logger.info("Starting the Bexio API Client GenServer with #{inspect(args)}")

    send(self(), :create_req)

    {:ok,
     %{
       req: nil,
       refresher: nil,
       client_id: args[:client_id],
       client_secret: args[:client_secret],
       api_token: args[:api_token]
     }}
  end

  @doc """
  Create the Bexio API Client comes in two flavors:

  * Using an API Key (not recommended anymore, but simpler)

    You get a base Req setup using new with an api key. This is not recommended anymore, but will never expire.

  * Using a regular OpenID workflow (recommended)

    This is a bit more tricky. The client_id, client_secret, and refresh_token are needed. The client_id and client_secret are used to fetch a new access_token
    using the refresh_token. The problem is that the expiration time of the access_token must be managed by the client himself.

  """
  @spec new(String.t()) :: Req.Request.t()
  def new(api_token) do
    @base_request_options
    |> Keyword.put_new(:auth, {:bearer, api_token})
    |> Keyword.merge(Application.get_env(:bexio_api_client, :bexio_req_options, []))
    |> Req.new()
  end

  @doc """
  Fetch a new access token for the given refresh token.

  ## Arguments:

    * `refresh_token` -> the refresh token we need the access key for
    * `client_id` -> the client id of our application that also got the refresh token
    * `client_secret` -> the client secret of our application

  ## Response

    {:ok, %{access_token: "", expires_in: 3600, id_token: "", refresh_token: "", scope: "openid profile email", token_type: "Bearer}}

    {:error, :unauthorized}
  """
  @spec access_token(String.t(), String.t(), String.t()) :: {:ok, map()} | {:error, any()}
  def access_token(refresh_token, client_id, client_secret) do
    case Req.post(
           url: "https://idp.bexio.com/token",
           form: %{
             "grant_type" => "refresh_token",
             "refresh_token" => refresh_token
           },
           auth: {:basic, client_id, client_secret}
         ) do
      {:ok, %Req.Response{} = response} ->
        Logger.info("Received a response: #{inspect(response)}")

        access_token = response.body["access_token"]
        expires_in = response.body["expires_in"]

        # TODO validate this logic!
        ref = Process.send_after(self(), :access_token, expires_in * 1000)

        @base_request_options
        |> Keyword.put_new(:auth, {:bearer, access_token})
        |> Keyword.merge(Application.get_env(:bexio_api_client, :bexio_req_options, []))
        |> Req.new()

      {:error, exception} ->
        Logger.error("Could not fetch a new access token: #{inspect(exception)}")
        {:error, exception}
    end

    """
    case tesla_response do
      {:ok, %Tesla.Env{status: 200, body: json_stringified}} ->
        case Jason.decode(json_stringified) do
          {:ok,
           %{
             "access_token" => access_token,
             "expires_in" => expires_in,
             "id_token" => id_token,
             "refresh_token" => refresh_token,
             "scope" => scope,
             "token_type" => token_type
           }} ->
            {:ok,
             %{
               access_token: access_token,
               expires_in: expires_in,
               id_token: id_token,
               refresh_token: refresh_token,
               scope: scope,
               token_type: token_type
             }}

          {:ok, map} ->
            {:error, {:unexpected_response, map}}

          {:error, error} ->
            {:error, error}
        end

      {:ok, %Tesla.Env{status: 401}} ->
        {:error, :unauthorized}
    end
    """
>>>>>>> a2c9912 (Continued logic, pushing before replacing the laptop ;))
  end
end
