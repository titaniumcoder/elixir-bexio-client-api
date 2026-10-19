defmodule BexioApiClient.RefreshError do
  defexception [:reason]

  @impl Exception
  def message(%__MODULE__{reason: reason}) do
    "Bexio access token refresh failed: #{inspect(reason)}"
  end
end
