defmodule BexioApiClient.Requests.BexioAuth do
  require Logger

  @moduledoc """
  `Req` plugin for Bexio authentication.

  The plugin authenticates uses the given refresh token to request a new access_token if there is none present.
  """

  @doc """
  Runs the plugin.

  ## Examples

      req = Req.new(http_errors: :raise) |> BexioAuth.attach()
      Req.get!(req, url: "https://api.bexio.com/2.0/company_profile", refresh_token: "xxx").body["login"]
      #=> "wojtekmach"
  """
  def attach(request, opts \\ []) do
    request
    |> Req.Request.register_options([
      :bexio_client_id,
      :bexio_client_secret,
      :bexio_idp_endpoint,
      :refresh_token
    ])
    |> Req.Request.merge_options(opts)
    |> Req.Request.append_request_steps(req_bexio_auth: &auth/1)
  end

  defp auth(%{url: %URI{scheme: "https", host: "api.bexio.com", port: 443}} = request) do
    opts = request.options
    token = read_memory_cache() || request_token(opts)
    Req.Request.put_header(request, "authorization", "Bearer #{token}")
  end

  # Only authorize api.bexio.com
  defp auth(request) do
    request
  end

  defp read_memory_cache do
    :persistent_term.get({__MODULE__, :token}, nil)
  end

  defp request_token(opts) do
    idp_endpoint = Keyword.get(opts, :bexio_idp_endpoint)
    client_id = Keyword.get(opts, :bexio_client_id)
    client_secret = Keyword.get(opts, :bexio_client_secret)
    refresh_token = Keyword.get(opts, :refresh_token)

    result = Req.post!(endpoint, json: %{"grant_type" => "refresh_token", "refresh_token" => refresh_token})

    %{
      "access_token" => access_token,
      "expires_in" => expires_in,
      "id_token" => id_token,
      "refresh_token" => refresh_token,
      "scope" => scope,
      "token_type" => token_type
    } = result.body

    # TODO store the access token in memory for expires_in time...
    access_token
  end

end
