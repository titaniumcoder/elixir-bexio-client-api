defmodule BexioApiClient do
  @moduledoc """
  Base Module for the API Client.
  
  The API Documentation for Bexio can be found under https://docs.bexio.com.
  
  Fields or arguments with date time reference expect them in the time zone Europe/Zurich.
  
  ## Requirements:
  
    * Tesla: the api client depends on Tesla. Every API call needs an instance of a `Tesla.Client` to be able to do the rest calls.any()
  
  """

  @doc """
  Create Tesla API Client.
  
  This must be given a token from https://office.bexio.com/admin/apiTokens#/ which will then be used as bearer token.
  The client can then be used everywhere where it's useful.
  
  It also allows an optional setup for retrying to allow to limit if needed. The defaults are listed below:
  
  ## Options:
  
    * `:delay` - Initial Delay for Backoff (Default: 500)
    * `:max_retries` - Maximal number of retries (Default: 10)
    * `:max_delay` - Maximal delay between requests (Default: 4_000)
    * `:log_level` - Log Level for Requests (Default: `:info`)
    * `:debug` - whether to include debug information (Default: `false`)
    * `:adapter` - Which adapter to use (Defalt: `nil`, recommended one with SSL support like Hackney)
  
  """
  @spec new(String.t(), keyword()) :: Tesla.Client.t()
  def new(api_token, opts \\ []) do
    delay = Keyword.get(opts, :delay, 500)
    max_retries = Keyword.get(opts, :max_retries, 10)
    max_delay = Keyword.get(opts, :max_delay, 4_000)
    log_level = Keyword.get(opts, :log_level, :info)
    adapter = Keyword.get(opts, :adapter)
    debug = Keyword.get(opts, :debug, false)

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.bexio.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BearerAuth, token: api_token},
      {Tesla.Middleware.Headers, [{"accept", "application/json"}]},
      {Tesla.Middleware.Logger,
       log_level: log_level, filter_headers: ["authorization"], debug: debug},
      {Tesla.Middleware.Retry,
       delay: delay,
       max_retries: max_retries,
       max_delay: max_delay,
       should_retry: fn
         {:ok, %{status: status}} when status in [500, 503, 429] -> true
         {:ok, _} -> false
         {:error, _} -> true
       end}
    ]

    Tesla.client(middleware, adapter)
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
  @spec access_token(String.t(), String.t(), String.t(), any()) :: {:ok, map()} | {:error, any()}
  def access_token(refresh_token, client_id, client_secret, adapter \\ nil) do
    tesla_response =
      [
        {Tesla.Middleware.BasicAuth, username: client_id, password: client_secret},
        {Tesla.Middleware.Logger,
         log_level: :info, filter_headers: ["authorization"], debug: false},
        Tesla.Middleware.FormUrlencoded
      ]
      |> Tesla.client(adapter)
      |> Tesla.post("https://idp.bexio.com/token", %{
        "grant_type" => "refresh_token",
        "refresh_token" => refresh_token
      })

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
  end
end
