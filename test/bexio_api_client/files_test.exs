defmodule BexioApiClient.FilesTest do
  use ExUnit.Case, async: true
  doctest BexioApiClient.Files

  alias BexioApiClient.SearchCriteria

  import Tesla.Mock

  describe "fetching a list of files" do
    setup do
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/3.0/files"
        } ->
          json([
            %{
              "id" => 1,
              "uuid" => "474cc93a-2d6f-47e9-bd3f-a5b5a1941314",
              "name" => "screenshot",
              "size_in_bytes" => 218_476,
              "extension" => "png",
              "mime_type" => "image/png",
              "uploader_email" => "contact@example.org",
              "user_id" => 1,
              "is_archived" => false,
              "source_id" => 2,
              "source_type" => "web",
              "is_referenced" => false,
              "created_at" => "2018-06-09T08:52:10+00:00"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [result]} = BexioApiClient.Files.fetch_files(client)

      assert result.id == 1
      assert result.uuid == "474cc93a-2d6f-47e9-bd3f-a5b5a1941314"
      assert result.name == "screenshot"
      assert result.size_in_bytes == 218_476
      assert result.extension == :png
      assert result.mime_type == "image/png"
      assert result.uploader_email == "contact@example.org"
      assert result.user_id == 1
      assert result.archived? == false
      assert result.source_type == :web
      assert result.referenced? == false
      assert result.created_at == ~U[2018-06-09 08:52:10Z]
    end
  end

  describe "searching files" do
    setup do
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/3.0/files/search",
          body: _body
        } ->
          json([
            %{
              "id" => 1,
              "uuid" => "474cc93a-2d6f-47e9-bd3f-a5b5a1941314",
              "name" => "screenshot",
              "size_in_bytes" => 218_476,
              "extension" => "png",
              "mime_type" => "image/png",
              "uploader_email" => "contact@example.org",
              "user_id" => 1,
              "is_archived" => false,
              "source_id" => 2,
              "source_type" => "web",
              "is_referenced" => false,
              "created_at" => "2018-06-09T08:52:10+00:00"
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [result]} = BexioApiClient.Files.search_files(client, [])

      assert result.id == 1
      assert result.uuid == "474cc93a-2d6f-47e9-bd3f-a5b5a1941314"
      assert result.name == "screenshot"
      assert result.size_in_bytes == 218_476
      assert result.extension == :png
      assert result.mime_type == "image/png"
      assert result.uploader_email == "contact@example.org"
      assert result.user_id == 1
      assert result.archived? == false
      assert result.source_type == :web
      assert result.referenced? == false
      assert result.created_at == ~U[2018-06-09 08:52:10Z]
    end
  end

  describe "fetching a single file" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/3.0/files/1"} ->
          json(%{
            "id" => 1,
            "uuid" => "474cc93a-2d6f-47e9-bd3f-a5b5a1941314",
            "name" => "screenshot",
            "size_in_bytes" => 218_476,
            "extension" => "png",
            "mime_type" => "image/png",
            "uploader_email" => "contact@example.org",
            "user_id" => 1,
            "is_archived" => false,
            "source_id" => 2,
            "source_type" => "web",
            "is_referenced" => false,
            "created_at" => "2018-06-09T08:52:10+00:00"
          })

        %{method: :get, url: "https://api.bexio.com/3.0/files/2"} ->
          %Tesla.Env{status: 404, body: "Salutation does not exist"}
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:ok, result} = BexioApiClient.Files.fetch_file(client, 1)
      assert result.id == 1
      assert result.uuid == "474cc93a-2d6f-47e9-bd3f-a5b5a1941314"
      assert result.name == "screenshot"
      assert result.size_in_bytes == 218_476
      assert result.extension == :png
      assert result.mime_type == "image/png"
      assert result.uploader_email == "contact@example.org"
      assert result.user_id == 1
      assert result.archived? == false
      assert result.source_type == :web
      assert result.referenced? == false
      assert result.created_at == ~U[2018-06-09 08:52:10Z]
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:error, :not_found} = BexioApiClient.Files.fetch_file(client, 2)
    end
  end

  describe "downloading a single file" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/3.0/files/1/download"} ->
          %Tesla.Env{
            status: 200,
            headers: [{"content-type", "application/pdf"}],
            body: "string"
          }
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:ok, {body, content_type}} = BexioApiClient.Files.download_file(client, 1)

      assert body == "string"
      assert content_type == "application/pdf"
    end
  end

  describe "preview a single file" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/3.0/files/1/preview"} ->
          %Tesla.Env{
            status: 200,
            headers: [{"content-type", "image/png"}],
            body: "string"
          }
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:ok, {body, content_type}} = BexioApiClient.Files.preview_file(client, 1)

      assert body == "string"
      assert content_type == "image/png"
    end
  end
end
