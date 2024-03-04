defmodule BexioApiClient.Requests.Request do
  @enforce_keys [:method, :path]
  defstruct [:method, :path, :body, :query_params]

  # TODO helpers??
  def req(method, path, args \\ []) do
    %__MODULE__{method: method, path: path, body: nil, query_params: args}
  end

  def req_body(method, path, body, args \\ []) do
    %__MODULE__{method: method, path: path, body: body, query_params: args}
  end
end
