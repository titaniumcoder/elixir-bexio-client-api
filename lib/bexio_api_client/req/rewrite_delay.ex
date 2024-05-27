defmodule BexioApiClient.Req.RewriteDelay do
  require Logger

  @moduledoc """
  Plugin to fetch a new access token for the given refresh token.
  """

  # RateLimit-Reset

  @spec attach(Req.Request.t()) :: Req.Request.t()
  def attach(%Req.Request{} = request, _options \\ []) do
    Req.Request.prepend_response_steps(request, rewrite_delay: &rewrite_delay/1)
  end

  defp rewrite_delay({request, response}) do
    Logger.info("Rewriting delay with #{inspect(request)} #{inspect(response)}")
    request
  end
end
