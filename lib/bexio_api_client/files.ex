defmodule BexioApiClient.Files do
  @moduledoc """
  Bexio API for the files part of the API
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria

  alias BexioApiClient.Files.File
  alias BexioApiClient.Files.FileUsage

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
         } = file,
         _response \\ nil
       ) do
    %File{
      id: id,
      uuid: uuid,
      name: name,
      size_in_bytes: size_in_bytes,
      # the extension is an open set, not a documented enum, so we keep the string
      extension: extension,
      mime_type: mime_type,
      uploader_email: uploader_email,
      user_id: user_id,
      archived?: archived?,
      # source_type is nullable in the API
      source_type: to_enum(source_type, [:web, :email, :mobile]),
      referenced?: referenced?,
      created_at: to_offset_datetime(created_at),
      # deprecated by bexio in favor of source_type; not always present
      source_id: Map.get(file, "source_id")
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

  @doc """
  Create a file by uploading it from the given path as multipart/form-data.

  The file name and content type are derived from the path.
  """
  @spec create_file(
          req :: Req.Request.t(),
          path :: String.t()
        ) :: {:ok, File.t()} | api_error_type()
  def create_file(req, path) do
    bexio_body_handling(
      fn ->
        # the base client preset `content-type: application/json`; a multipart
        # upload must not carry it, Req sets the multipart content-type itself
        req
        |> Req.Request.delete_header("content-type")
        |> Req.post(url: "/3.0/files", form_multipart: [file: Elixir.File.stream!(path)])
      end,
      &map_from_created_file/2
    )
  end

  # The docs' response sample for the create endpoint shows an array containing
  # a single file, while the sibling endpoints (GET/PATCH /3.0/files/{file_id})
  # return a single object and the endpoint creates exactly one file. Both
  # shapes are therefore normalized to a single file (see docs/reference/UNTRUTHS.md).
  defp map_from_created_file([file | _rest], response), do: map_from_file(file, response)
  defp map_from_created_file(file, response), do: map_from_file(file, response)

  @doc """
  Update a file (name, archived state and/or source type).
  """
  @spec update_file(
          req :: Req.Request.t(),
          file :: File.t()
        ) :: {:ok, File.t()} | api_error_type()
  def update_file(req, file) do
    bexio_body_handling(
      fn ->
        Req.patch(
          req,
          url: "/3.0/files/#{file.id}",
          json: remap_edit_file(file)
        )
      end,
      &map_from_file/2
    )
  end

  defp remap_edit_file(file) do
    file
    |> Map.take([:name, :archived?, :source_type])
    |> Map.new(fn
      {:archived?, archived?} -> {:is_archived, archived?}
      field -> field
    end)
  end

  @doc """
  Delete a file. It cannot be undone.
  """
  @spec delete_file(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, boolean()} | api_error_type()
  def delete_file(req, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/3.0/files/#{id}")
      end,
      &success_response/2
    )
  end

  @doc """
  Show file usage.
  """
  @spec fetch_file_usage(
          req :: Req.Request.t(),
          id :: non_neg_integer()
        ) :: {:ok, FileUsage.t()} | api_error_type()
  def fetch_file_usage(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/files/#{id}/usage")
      end,
      &map_from_file_usage/2
    )
  end

  defp map_from_file_usage(
         %{
           "id" => id,
           "ref_class" => ref_class,
           "title" => title,
           "document_nr" => document_nr
         },
         _response
       ) do
    %FileUsage{
      id: id,
      ref_class: ref_class,
      title: title,
      document_nr: document_nr
    }
  end
end
