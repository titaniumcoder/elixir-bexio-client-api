defmodule BexioApiClient do
  require Logger

  # Base API, always put the accept header to application/json and overwrite it for the seldom cases
  # where it's different. Transient retry: also retry on posts, puts, deletes, etc.
  @base_request_options [
    base_url: "https://api.bexio.com",
    headers: [accept: "application/json", content_type: "application/json"],
    retry: :transient,
    # try twice, because after the first, the rate may be wrong, but after the second, the retry should wait correctly
    max_retries: 3,
    retry_log_level: :warn,
    retry: &BexioApiClient.Req.RewriteDelay.retry/2
  ]

  @moduledoc """
  base functionality like refreshing the access token.

  The API Documentation for Bexio can be found under https://docs.bexio.com.

  Fields or arguments with date time reference expect them in the time zone Europe/Zurich.

  ## Requirements:

    * Http Client:
    ** Req: the api client depends on Req.

  ## Refresh token rotation

  Bexio's token endpoint (a Keycloak realm) rotates refresh tokens: every token
  response may contain a NEW `refresh_token` and the previously used one becomes
  invalid. Host applications MUST persist the rotated refresh token (see
  `access_token/3` and the `:on_refresh_token_rotated` option of
  `BexioApiClient.Req.AccessTokenRefresher`) or the refresh flow breaks after one
  rotation. Reusing a stale token can get the OAuth client blacklisted by Bexio.

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

  Additional `opts` are passed to `BexioApiClient.Req.AccessTokenRefresher.attach/2`,
  e.g. `on_refresh_token_rotated: {module, function, args}`.
  """
  @spec new(String.t(), String.t(), String.t(), keyword()) :: Req.Request.t()
  def new(client_id, client_secret, refresh_token, opts \\ []) do
    _ = BexioApiClient.Req.AccessTokenRefresher.create_ets_table()

    @base_request_options
    |> Keyword.merge(Application.get_env(:bexio_api_client, :req_options, []))
    |> Req.new()
    |> BexioApiClient.Req.AccessTokenRefresher.attach(
      [refresh_token: refresh_token, client_id: client_id, client_secret: client_secret] ++ opts
    )
  end

  @doc """
  Removes all expired access tokens from the ETS table.
  """
  def remove_expired_access_tokens do
    BexioApiClient.Req.AccessTokenRefresher.remove_expired_tokens()
  end

  @doc """
  Fetches a token response from the Bexio (Keycloak) token endpoint.

  ## Arguments:

    * `refresh_token` -> the refresh token we need the access token for
    * `client_id` -> the client id of our application that also got the refresh token
    * `client_secret` -> the client secret of our application

  ## Response

  On success, the full token map is returned. Bexio rotates refresh tokens, so
  the returned `refresh_token` (when not `nil`) is NEW and the previously used
  one becomes invalid. Host applications MUST persist it, otherwise the refresh
  flow breaks after one rotation.

      {:ok, %{access_token: "", expires_in: 3600, id_token: nil, refresh_token: nil, scope: nil, token_type: nil}}

  Every non-success response (including 2xx with an unexpected body) returns the
  status and body and logs the full `Req.Response`, so failures can be
  classified afterwards:

      {:error, {:unexpected_response, 403, %{"reason" => "blacklisted", "status" => "blocked"}}}

  Transport failures return:

      {:error, {:request_failed, exception}}

  This function never retries on its own; retry policy belongs to
  `BexioApiClient.Req.AccessTokenRefresher`.
  """
  @spec access_token(String.t(), String.t(), String.t()) ::
          {:ok,
           %{
             required(:access_token) => String.t(),
             required(:expires_in) => integer(),
             optional(:refresh_token) => String.t() | nil,
             optional(:id_token) => String.t() | nil,
             optional(:scope) => String.t() | nil,
             optional(:token_type) => String.t() | nil
           }}
          | {:error, {:unexpected_response, integer(), any()}}
          | {:error, {:request_failed, any()}}
  def access_token(refresh_token, client_id, client_secret) do
    idp_url =
      Application.get_env(
        :bexio_api_client,
        :idp_url,
        "https://auth.bexio.com/realms/bexio/protocol/openid-connect/token"
      )

    idp_request()
    |> Req.post(
      url: idp_url,
      form: %{
        "grant_type" => "refresh_token",
        "refresh_token" => refresh_token
      },
      auth: {:basic, "#{client_id}:#{client_secret}"}
    )
    |> handle_token_response()
  end

  defp idp_request do
    Application.get_env(:bexio_api_client, :req_options, [])
    |> Keyword.merge(retry: false)
    |> Req.new()
  end

  defp handle_token_response(
         {:ok,
          %Req.Response{
            status: status,
            body: %{"access_token" => access_token, "expires_in" => expires_in} = body
          }}
       )
       when status in 200..299 do
    {:ok,
     %{
       access_token: access_token,
       expires_in: expires_in,
       refresh_token: Map.get(body, "refresh_token"),
       id_token: Map.get(body, "id_token"),
       scope: Map.get(body, "scope"),
       token_type: Map.get(body, "token_type")
     }}
  end

  defp handle_token_response({:ok, %Req.Response{} = response}) do
    Logger.error("Unexpected token response: #{inspect(response)}")
    {:error, {:unexpected_response, response.status, response.body}}
  end

  defp handle_token_response({:error, exception}) do
    Logger.error("Could not fetch a new access token: #{inspect(exception)}")
    {:error, {:request_failed, exception}}
  end
end
