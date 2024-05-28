defmodule BexioApiClient.Files do
  @moduledoc """
  Bexio API for the files part of the API
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria

  alias BexioApiClient.Files.File

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @type api_error_type :: BexioApiClient.Helpers.api_error_type()

  @doc """
  Fetch a list of files.
  """
  @spec fetch_files(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [File.t()]} | api_error_type()
  def fetch_files(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/files", params: opts_to_query(opts))
      end,
      &map_from_files/2
    )
  end

  @doc """
  Search files via query.
  The following search fields are supported:

  * id
  * uuid
  * created_at
  * name
  * extension
  * size_in_bytes
  * mime_type
  * user_id
  * archived?
  * source_id
  """
  @spec search_files(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [File.t()]} | api_error_type()
  def search_files(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/3.0/files/search",
          json: remap(criteria),
          params: opts_to_query(opts)
        )
      end,
      &map_from_files/2
    )
  end

  defp remap([]), do: []
  defp remap(nil), do: nil

  defp remap(keywords) do
    if Keyword.has_key?(keywords, :archived?) do
      keywords
      |> Keyword.put_new(:is_archived, Keyword.get(keywords, :archived?))
      |> Keyword.delete(:arcvived?)
    else
      keywords
    end
  end

  @doc """
  Fetch single file.
  """
  @spec fetch_file(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, File.t()} | api_error_type()
  def fetch_file(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(
          req,
          url: "/3.0/files/#{id}"
        )
      end,
      &map_from_file/2
    )
  end

  defp map_from_files(files, _response), do: Enum.map(files, &map_from_file/1)

  defp map_from_file(
         %{
           "id" => id,
           "uuid" => uuid,
           "name" => name,
           "size_in_bytes" => size_in_bytes,
           "extension" => extension,
           "mime_type" => mime_type,
           "uploader_email" => uploader_email,
           "user_id" => user_id,
           "is_archived" => archived?,
           "source_type" => source_type,
           "is_referenced" => referenced?,
           "created_at" => created_at
         },
         _response \\ nil
       ) do
    %File{
      id: id,
      uuid: uuid,
      name: name,
      size_in_bytes: size_in_bytes,
      extension: String.to_atom(extension),
      mime_type: mime_type,
      uploader_email: uploader_email,
      user_id: user_id,
      archived?: archived?,
      source_type: String.to_atom(source_type),
      referenced?: referenced?,
      created_at: to_offset_datetime(created_at)
    }
  end

  @doc """
  Download file (original content).
  """
  @spec download_file(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, {String.t(), any()}} | api_error_type()
  def download_file(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/files/#{id}/download")
      end,
      fn file, response -> {file, Req.Response.get_header(response, "content-type")} end
    )
  end

  @doc """
  Download file (original content).
  """
  @spec preview_file(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, {String.t(), any()}} | api_error_type()
  def preview_file(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/files/#{id}/preview")
      end,
      fn file, resp -> {file, Req.Response.get_header(resp, "content-type")} end
    )
  end
end
