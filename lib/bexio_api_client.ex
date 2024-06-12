defmodule BexioApiClient do
  require Logger

  # Base API, always put the accept header to application/json and overwrite it for the seldom cases
  # where it's different. Transient retry: also retry on posts, puts, deletes, etc.
  @base_request_options [
    base_url: "https://api.bexio.com",
    headers: [accept: "application/json", content_type: "application/json"],
    retry: :transient,
    max_retries: 100,
    retry_log_level: :warn,
    retry: &BexioApiClient.Req.RewriteDelay.retry/2
  ]

  @moduledoc """
  base functionality like refreshing the access token.

  The API Documentation for Bexio can be found under https://docs.bexio.com.

  Fields or arguments with date time reference expect them in the time zone Europe/Zurich.

  ## Requirements:

    * Http Client:
    ** Req: the api client depends on Req.

  """

  @doc """
  Creates a new client using the never ending all powerful API Token.
  """
  @spec new(String.t()) :: Req.Request.t()
  def new(api_token) do
    @base_request_options
    |> Keyword.put_new(:auth, {:bearer, api_token})
    |> Keyword.merge(Application.get_env(:bexio_api_client, :req_options, []))
    |> Req.new()
  end

  @doc """
  Creates a new client using the client id, client secret and refresh token. Be aware that getting
  this information is part of the OpenID flow which is not in the scope of this library.
  """
  @spec new(String.t(), String.t(), String.t()) :: Req.Request.t()
  def new(client_id, client_secret, refresh_token) do
    _ = BexioApiClient.Req.AccessTokenRefresher.create_ets_table()

    @base_request_options
    |> Keyword.merge(Application.get_env(:bexio_api_client, :req_options, []))
    |> Req.new()
    |> BexioApiClient.Req.AccessTokenRefresher.attach(
      refresh_token: refresh_token,
      client_id: client_id,
      client_secret: client_secret
    )
  end

  @doc """
  Removes all expired access tokens from the ETS table.
  """
  def remove_expired_access_tokens do
    BexioApiClient.Req.AccessTokenRefresher.remove_expired_tokens()
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
  @spec access_token(String.t(), String.t(), String.t()) ::
          {:ok, String.t(), integer()} | {:error, any()}
  def access_token(refresh_token, client_id, client_secret) do
    idp_req =
      Application.get_env(:bexio_api_client, :req_options, [])
      |> Req.new()

    case Req.post(
           idp_req,
           url: "https://idp.bexio.com/token",
           form: %{
             "grant_type" => "refresh_token",
             "refresh_token" => refresh_token
           },
           auth: {:basic, "#{client_id}:#{client_secret}"}
         ) do
      {:ok, %Req.Response{status: 401}} ->
        {:error, :unauthenticated}

      {:ok, %Req.Response{} = response} ->
        case response.body do
          %{
            "access_token" => access_token,
            "expires_in" => expires_in
          } ->
            {:ok, access_token, expires_in}

          _ ->
            {:error, {:unexpected_response, response.body}}
        end

      {:error, exception} ->
        Logger.error("Could not fetch a new access token: #{inspect(exception)}")
        {:error, exception}
    end
  end
end
