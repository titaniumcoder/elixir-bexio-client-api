defmodule BexioApiClient do
  require Logger

  @base_request_options [
    base_url: "https://api.bexio.com",
    headers: [accept: "application/json"],
    retry: :transient
    # TODO: attach the refresh token logic. Keeping track
    #  of the refresh tokens is not part of this library,
    #  it only keeps track of the access tokens for a given refresh
    #  token.
  ]

  @moduledoc """
  base functionality like refreshing the access token.

  The API Documentation for Bexio can be found under https://docs.bexio.com.

  Fields or arguments with date time reference expect them in the time zone Europe/Zurich.

  ## Requirements:

    * Http Client:
    ** Req: the api client depends on Req.

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
  end
end
