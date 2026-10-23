defmodule BexioApiClient.FilesTest do
  use ExUnit.Case, async: true

  @moduletag :tmp_dir
  doctest BexioApiClient.Files

  describe "fetching a list of files" do
    setup do
      Req.Test.stub(BexioApiClient, fn conn ->
        Req.Test.json(conn, [
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
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Files.fetch_files(client)

      assert result.id == 1
      assert result.uuid == "474cc93a-2d6f-47e9-bd3f-a5b5a1941314"
      assert result.name == "screenshot"
      assert result.size_in_bytes == 218_476
      assert result.extension == "png"
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
      Req.Test.stub(BexioApiClient, fn conn ->
        Req.Test.json(conn, [
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
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Files.search_files(client, [])

      assert result.id == 1
      assert result.uuid == "474cc93a-2d6f-47e9-bd3f-a5b5a1941314"
      assert result.name == "screenshot"
      assert result.size_in_bytes == 218_476
      assert result.extension == "png"
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
      Req.Test.stub(BexioApiClient, fn conn ->
        case List.last(conn.path_info) do
          "1" ->
            Req.Test.json(conn, %{
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

          "2" ->
            Plug.Conn.send_resp(conn, 404, "File does not exist")
        end
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, result} = BexioApiClient.Files.fetch_file(client, 1)
      assert result.id == 1
      assert result.uuid == "474cc93a-2d6f-47e9-bd3f-a5b5a1941314"
      assert result.name == "screenshot"
      assert result.size_in_bytes == 218_476
      assert result.extension == "png"
      assert result.mime_type == "image/png"
      assert result.uploader_email == "contact@example.org"
      assert result.user_id == 1
      assert result.archived? == false
      assert result.source_type == :web
      assert result.referenced? == false
      assert result.created_at == ~U[2018-06-09 08:52:10Z]
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "File does not exist"} =
               BexioApiClient.Files.fetch_file(client, 2)
    end
  end

  describe "downloading a single file" do
    setup do
      Req.Test.stub(BexioApiClient, fn conn ->
        # headers: [{"content-type", "application/pdf"}],
        conn
        |> Plug.Conn.put_resp_content_type("application/pdf", nil)
        |> Plug.Conn.send_resp(200, "string")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, {body, content_type}} = BexioApiClient.Files.download_file(client, 1)

      assert body == "string"
      assert "application/pdf" in content_type
    end
  end

  describe "preview a single file" do
    setup do
      Req.Test.stub(BexioApiClient, fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("image/png", nil)
        |> Plug.Conn.send_resp(200, "string")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, {body, content_type}} = BexioApiClient.Files.preview_file(client, 1)

      assert body == "string"
      assert "image/png" in content_type
    end
  end

  describe "creating a file" do
    setup %{tmp_dir: tmp_dir} do
      path = Path.join(tmp_dir, "screenshot.png")
      File.write!(path, "image-data")

      Req.Test.stub(BexioApiClient, fn
        %{method: "POST", request_path: "/3.0/files"} = conn ->
          assert [multipart] = Plug.Conn.get_req_header(conn, "content-type")
          assert String.starts_with?(multipart, "multipart/form-data; boundary=")

          Req.Test.json(conn, %{
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
      end)

      {:ok, path: path}
    end

    test "creates and parses the file", %{path: path} do
      client = BexioApiClient.new("123")
      assert {:ok, result} = BexioApiClient.Files.create_file(client, path)

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
      assert result.source_id == 2
      assert result.referenced? == false
      assert result.created_at == ~U[2018-06-09 08:52:10Z]
    end

    test "fails on validation error", %{path: path} do
      Req.Test.stub(BexioApiClient, fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(422, ~s({"error": ["File could not be saved"]}))
      end)

      client = BexioApiClient.new("123")

      assert {:error, :could_not_be_saved, %{"error" => ["File could not be saved"]}} =
               BexioApiClient.Files.create_file(client, path)
    end
  end

  describe "creating a file with the array response sample from the docs" do
    setup %{tmp_dir: tmp_dir} do
      path = Path.join(tmp_dir, "screenshot.png")
      File.write!(path, "image-data")

      Req.Test.stub(BexioApiClient, fn conn ->
        Req.Test.json(conn, [
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

      {:ok, path: path}
    end

    test "normalizes the response to a single file", %{path: path} do
      client = BexioApiClient.new("123")

      assert {:ok, %BexioApiClient.Files.File{id: 1}} =
               BexioApiClient.Files.create_file(client, path)
    end
  end

  describe "updating a file" do
    setup do
      Req.Test.stub(BexioApiClient, fn
        %{method: "PATCH", request_path: "/3.0/files/1"} = conn ->
          assert ["application/json"] = Plug.Conn.get_req_header(conn, "content-type")

          Req.Test.json(conn, %{
            "id" => 1,
            "uuid" => "474cc93a-2d6f-47e9-bd3f-a5b5a1941314",
            "name" => "screenshot",
            "size_in_bytes" => 218_476,
            "extension" => "png",
            "mime_type" => "image/png",
            "uploader_email" => "contact@example.org",
            "user_id" => 1,
            "is_archived" => true,
            "source_id" => 2,
            "source_type" => "web",
            "is_referenced" => false,
            "created_at" => "2018-06-09T08:52:10+00:00"
          })

        %{method: "PATCH", request_path: "/3.0/files/2"} = conn ->
          Plug.Conn.send_resp(conn, 404, "File does not exist")
      end)

      file = %BexioApiClient.Files.File{
        id: 1,
        uuid: "474cc93a-2d6f-47e9-bd3f-a5b5a1941314",
        name: "screenshot",
        size_in_bytes: 218_476,
        extension: :png,
        mime_type: "image/png",
        uploader_email: "contact@example.org",
        user_id: 1,
        archived?: false,
        source_type: :web,
        source_id: 2,
        referenced?: false,
        created_at: ~U[2018-06-09 08:52:10Z]
      }

      {:ok, bexio_file: file}
    end

    test "updates and parses the file", %{bexio_file: file} do
      client = BexioApiClient.new("123")
      assert {:ok, result} = BexioApiClient.Files.update_file(client, file)

      assert result.id == 1
      assert result.name == "screenshot"
      assert result.archived? == true
      assert result.source_type == :web
      assert result.source_id == 2
      assert result.created_at == ~U[2018-06-09 08:52:10Z]
    end

    test "fails on unknown id", %{bexio_file: file} do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "File does not exist"} =
               BexioApiClient.Files.update_file(client, %{file | id: 2})
    end
  end

  describe "deleting a file" do
    setup do
      Req.Test.stub(BexioApiClient, fn
        %{method: "DELETE", request_path: "/3.0/files/1"} = conn ->
          Req.Test.json(conn, %{"success" => true})

        %{method: "DELETE", request_path: "/3.0/files/2"} = conn ->
          Plug.Conn.send_resp(conn, 404, "File does not exist")
      end)

      :ok
    end

    test "deletes the file" do
      client = BexioApiClient.new("123")

      assert {:ok, true} = BexioApiClient.Files.delete_file(client, 1)
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "File does not exist"} =
               BexioApiClient.Files.delete_file(client, 2)
    end
  end

  describe "showing file usage" do
    setup do
      Req.Test.stub(BexioApiClient, fn
        %{method: "GET", request_path: "/3.0/files/1/usage"} = conn ->
          Req.Test.json(conn, %{
            "id" => 1,
            "ref_class" => "KbInvoice",
            "title" => "RE-00001",
            "document_nr" => "RE-00001"
          })

        %{method: "GET", request_path: "/3.0/files/2/usage"} = conn ->
          Plug.Conn.send_resp(conn, 404, "File does not exist")
      end)

      :ok
    end

    test "shows the usage" do
      client = BexioApiClient.new("123")
      assert {:ok, usage} = BexioApiClient.Files.fetch_file_usage(client, 1)

      assert usage == %BexioApiClient.Files.FileUsage{
               id: 1,
               ref_class: "KbInvoice",
               title: "RE-00001",
               document_nr: "RE-00001"
             }
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "File does not exist"} =
               BexioApiClient.Files.fetch_file_usage(client, 2)
    end
  end
end
