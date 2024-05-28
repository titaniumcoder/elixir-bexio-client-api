defmodule BexioApiClient.Req.AccessTokenRefresher do
  require Logger

  @moduledoc """
  Plugin to fetch a new access token for the given refresh token.
  """

  @spec attach(Req.Request.t()) :: Req.Request.t()
  def attach(%Req.Request{} = request, options \\ []) do
    request
    |> Req.Request.register_options([
      :atr_refresh_token,
      :atr_client_id,
      :atr_client_secret,
      :atr_expires_at
    ])
    |> Req.Request.merge_options(options)
    |> Req.Request.append_request_steps(get_access_token: &get_access_token/1)
  end

  defp get_access_token(%Req.Request{} = request) do
    if expired?(request) do
      Logger.info("Access token expired, fetching a new one")

      refresh_token = Req.Request.get_private(request, :refresh_token)
      client_id = Req.Request.get_private(request, :client_id)
      client_secret = Req.Request.get_private(request, :client_secret)

      case BexioApiClient.access_token(refresh_token, client_id, client_secret) do
        {:ok, access_token, expires_in} ->
          Logger.info("Received a response: #{access_token}, #{expires_in}")

          # Calculate expires_at and then store all
          expires_at = System.system_time(:second) + expires_in

          request
          |> Req.Request.merge_options(auth: {:bearer, access_token})
          |> Req.Request.put_private(:expires_at, expires_at)

        # how to save client_id, client_secret, refresh_token?

        {:error, reason} ->
          Logger.error("Failed to fetch a new access token: #{inspect(reason)}")
          request
      end
    else
      request
    end
  end

  defp expired?(%Req.Request{} = request) do
    expires_at = Req.Request.get_private(request, :expires_at)
    expires_at == nil or System.system_time(:second) > expires_at
  end
end
