defmodule BexioApiClient.Req.AccessTokenRefresher do
  @moduledoc """
  Plugin to fetch a new access token for the given refresh token.
  """

  require Logger

  @expires_in_reserve 60
  @ets_table_name :bexio_api_client_access_tokens

  @spec attach(Req.Request.t()) :: Req.Request.t()
  def attach(%Req.Request{} = request, options \\ []) do
    request
    |> Req.Request.register_options([
      :refresh_token,
      :client_id,
      :client_secret
    ])
    |> Req.Request.merge_options(options)
    |> Req.Request.prepend_request_steps(get_access_token: &get_access_token/1)
  end

  def create_ets_table do
    if :ets.whereis(@ets_table_name) == :undefined do
      :ets.new(@ets_table_name, [:named_table, :set, :public])
    end
  end

  @doc """
  Remove all expired access tokens from the ETS table. Triggering this is part of the job of the caller process for now.
  """
  def remove_expired_tokens do
    if :ets.whereis(@ets_table_name) != :undefined do
      :ets.match(@ets_table_name, {:"$0", {:_, :"$1"}})
      |> Enum.filter(fn [_k, e] -> e < System.system_time(:second) end)
      |> Enum.map(fn [k, _] -> k end)
      |> Enum.each(fn k -> :ets.delete(:test, k) end)
    end
  end

  defp get_access_token(%Req.Request{} = request) do
    refresh_token = Req.Request.get_option(request, :refresh_token)
    client_id = Req.Request.get_option(request, :client_id)
    client_secret = Req.Request.get_option(request, :client_secret)

    case get_access_token_from_ets(client_id, refresh_token) do
      nil ->
        Logger.debug("No access token found (or expired) in ETS, fetching a new one")
        fetch_new_access_token_and_store(request, refresh_token, client_id, client_secret)

      access_token ->
        use_access_token(request, access_token)
    end
  end

  defp fetch_new_access_token_and_store(
         %Req.Request{} = req,
         refresh_token,
         client_id,
         client_secret
       ) do
    case BexioApiClient.access_token(refresh_token, client_id, client_secret) do
      {:ok, access_token, expires_in} ->
        Logger.debug("Received a token response: #{access_token}, #{expires_in}")

        # Store the access token in ETS
        store_access_token_in_ets(client_id, refresh_token, access_token, expires_in)

        # Add the access token to the request
        use_access_token(req, access_token)

      {:error, reason} ->
        Logger.error("Failed to fetch a new access token: #{inspect(reason)}")
        req
    end
  end

  defp store_access_token_in_ets(client_id, refresh_token, access_token, expires_in) do
    :ets.insert(
      @ets_table_name,
      {{client_id, refresh_token},
       {access_token, System.system_time(:second) + expires_in - @expires_in_reserve}}
    )
  end

  defp get_access_token_from_ets(client_id, refresh_token) do
    current_time = System.system_time(:second)

    case :ets.lookup(@ets_table_name, {client_id, refresh_token}) do
      [{_, {access_token, expires_at}}] when expires_at > current_time ->
        access_token

      _ ->
        nil
    end
  end

  defp use_access_token(request, access_token) do
    Req.Request.merge_options(request, auth: {:bearer, access_token})
  end
end
