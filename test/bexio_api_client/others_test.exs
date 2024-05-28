defmodule BexioApiClient.OthersTest do
  use TestHelper

  use ExUnit.Case, async: true

  doctest BexioApiClient.Others

  alias BexioApiClient.Others.{FictionalUser, Todo}
  alias BexioApiClient.SearchCriteria

  describe "fetching a list of company profiles" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/company_profile"
        } = conn ->
          json(conn, [
            %{
              id: 1,
              name: "bexio AG",
              address: "Alte Jonastrasse 24",
              address_nr: "",
              postcode: 8640,
              city: "Rapperswil",
              country_id: 1,
              legal_form: "association",
              country_name: "Switzerland",
              mail: "info@bexio.com",
              phone_fixed: "+41 (0)71 552 00 60",
              phone_mobile: "+41 (0)79 123 45 67",
              fax: "",
              url: "https://www.bexio.com",
              skype_name: "",
              facebook_name: "",
              twitter_name: "",
              description: "",
              ust_id_nr: "CHE-322.646.985",
              mwst_nr: "CHE-322.646.985 MWST",
              trade_register_nr: "",
              has_own_logo: true,
              is_public_profile: false,
              is_logo_public: false,
              is_address_public: false,
              is_phone_public: false,
              is_mobile_public: false,
              is_fax_public: false,
              is_mail_public: false,
              is_url_public: false,
              is_skype_public: false,
              logo_base64: "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Others.fetch_company_profiles(client)

      assert result.id == 1
      assert result.name == "bexio AG"
      assert result.address == "Alte Jonastrasse 24"
      assert result.address_nr == ""
      assert result.postcode == 8640
      assert result.city == "Rapperswil"
      assert result.country_id == 1
      assert result.legal_form == :association
      assert result.country_name == "Switzerland"
      assert result.mail == "info@bexio.com"
      assert result.phone_fixed == "+41 (0)71 552 00 60"
      assert result.phone_mobile == "+41 (0)79 123 45 67"
      assert result.fax == ""
      assert result.url == "https://www.bexio.com"
      assert result.skype_name == ""
      assert result.facebook_name == ""
      assert result.twitter_name == ""
      assert result.description == ""
      assert result.ust_id_nr == "CHE-322.646.985"
      assert result.mwst_nr == "CHE-322.646.985 MWST"
      assert result.trade_register_nr == ""
      assert result.own_logo? == true
      assert result.public_profile? == false
      assert result.logo_public? == false
      assert result.address_public? == false
      assert result.phone_public? == false
      assert result.mobile_public? == false
      assert result.fax_public? == false
      assert result.mail_public? == false
      assert result.url_public? == false
      assert result.skype_public? == false
      assert result.logo_base64 == "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
    end
  end

  describe "show company profile" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/company_profile/1"} = conn ->
          json(conn, %{
            id: 1,
            name: "bexio AG",
            address: "Alte Jonastrasse 24",
            address_nr: "",
            postcode: 8640,
            city: "Rapperswil",
            country_id: 1,
            legal_form: "association",
            country_name: "Switzerland",
            mail: "info@bexio.com",
            phone_fixed: "+41 (0)71 552 00 60",
            phone_mobile: "+41 (0)79 123 45 67",
            fax: "",
            url: "https://www.bexio.com",
            skype_name: "",
            facebook_name: "",
            twitter_name: "",
            description: "",
            ust_id_nr: "CHE-322.646.985",
            mwst_nr: "CHE-322.646.985 MWST",
            trade_register_nr: "",
            has_own_logo: true,
            is_public_profile: false,
            is_logo_public: false,
            is_address_public: false,
            is_phone_public: false,
            is_mobile_public: false,
            is_fax_public: false,
            is_mail_public: false,
            is_url_public: false,
            is_skype_public: false,
            logo_base64: "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
          })
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, result} = BexioApiClient.Others.fetch_company_profile(client, 1)

      assert result.id == 1
      assert result.name == "bexio AG"
      assert result.address == "Alte Jonastrasse 24"
      assert result.address_nr == ""
      assert result.postcode == 8640
      assert result.city == "Rapperswil"
      assert result.country_id == 1
      assert result.legal_form == :association
      assert result.country_name == "Switzerland"
      assert result.mail == "info@bexio.com"
      assert result.phone_fixed == "+41 (0)71 552 00 60"
      assert result.phone_mobile == "+41 (0)79 123 45 67"
      assert result.fax == ""
      assert result.url == "https://www.bexio.com"
      assert result.skype_name == ""
      assert result.facebook_name == ""
      assert result.twitter_name == ""
      assert result.description == ""
      assert result.ust_id_nr == "CHE-322.646.985"
      assert result.mwst_nr == "CHE-322.646.985 MWST"
      assert result.trade_register_nr == ""
      assert result.own_logo? == true
      assert result.public_profile? == false
      assert result.logo_public? == false
      assert result.address_public? == false
      assert result.phone_public? == false
      assert result.mobile_public? == false
      assert result.fax_public? == false
      assert result.mail_public? == false
      assert result.url_public? == false
      assert result.skype_public? == false
      assert result.logo_base64 == "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
    end
  end

  describe "fetching a list of countries" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/country"
        } = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "Kiribati",
              "name_short" => "KI",
              "iso_3166_alpha2" => "KI"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Others.fetch_countries(client)

      assert result.id == 1
      assert result.name == "Kiribati"
      assert result.name_short == "KI"
      assert result.iso_3166_alpha2 == "KI"
    end
  end

  describe "searching countries" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/country/search"
        } = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "Kiribati",
              "name_short" => "KI",
              "iso_3166_alpha2" => "KI"
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.Others.search_countries(client, [
                 SearchCriteria.nil?(:name_short),
                 SearchCriteria.part_of(:name, ["fred", "queen"])
               ])

      assert result.id == 1
      assert result.name == "Kiribati"
      assert result.name_short == "KI"
      assert result.iso_3166_alpha2 == "KI"
    end
  end

  describe "fetching a single country" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/country/1"} = conn ->
          json(conn, %{
            "id" => 1,
            "name" => "Kiribati",
            "name_short" => "KI",
            "iso_3166_alpha2" => "KI"
          })

        %{method: "GET", request_path: "/2.0/country/99"} = conn ->
          send_resp(conn, 404, "Country does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, result} = BexioApiClient.Others.fetch_country(client, 1)
      assert result.id == 1
      assert result.name == "Kiribati"
      assert result.name_short == "KI"
      assert result.iso_3166_alpha2 == "KI"
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Country does not exist"} =
               BexioApiClient.Others.fetch_country(client, 99)
    end
  end

  describe "fetching a list of languages" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/language"
        } = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "German",
              "decimal_point" => ".",
              "thousands_separator" => "'",
              "date_format_id" => 1,
              "date_format" => "d.m.Y",
              "iso_639_1" => "de"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Others.fetch_languages(client)

      assert result.id == 1
      assert result.name == "German"
      assert result.decimal_point == "."
      assert result.thousands_separator == "'"
      assert result.date_format_id == :dmy
      assert result.date_format == "d.m.Y"
      assert result.iso_639_1 == "de"
    end
  end

  describe "searching languages" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/language/search"
        } = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "German",
              "decimal_point" => ".",
              "thousands_separator" => "'",
              "date_format_id" => 1,
              "date_format" => "d.m.Y",
              "iso_639_1" => "de"
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} =
               BexioApiClient.Others.search_languages(client, [
                 SearchCriteria.nil?(:name),
                 SearchCriteria.part_of(:iso_639_1, ["fred", "queen"])
               ])

      assert result.id == 1
      assert result.name == "German"
      assert result.decimal_point == "."
      assert result.thousands_separator == "'"
      assert result.date_format_id == :dmy
      assert result.date_format == "d.m.Y"
      assert result.iso_639_1 == "de"
    end
  end

  describe "fetching a list of users" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/3.0/users"
        } = conn ->
          json(conn, [
            %{
              "id" => 4,
              "salutation_type" => "male",
              "firstname" => "Rudolph",
              "lastname" => "Smith",
              "email" => "rudolph.smith@example.com",
              "is_superadmin" => true,
              "is_accountant" => false
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Others.fetch_users(client)

      assert result.id == 4
      assert result.salutation_type == :male
      assert result.firstname == "Rudolph"
      assert result.lastname == "Smith"
      assert result.email == "rudolph.smith@example.com"
      assert result.superadmin? == true
      assert result.accountant? == false
    end
  end

  describe "fetching a user" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/3.0/users/4"
        } = conn ->
          json(conn, %{
            "id" => 4,
            "salutation_type" => "male",
            "firstname" => "Rudolph",
            "lastname" => "Smith",
            "email" => "rudolph.smith@example.com",
            "is_superadmin" => true,
            "is_accountant" => false
          })
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.fetch_user(client, 4)

      assert result.id == 4
      assert result.salutation_type == :male
      assert result.firstname == "Rudolph"
      assert result.lastname == "Smith"
      assert result.email == "rudolph.smith@example.com"
      assert result.superadmin? == true
      assert result.accountant? == false
    end
  end

  describe "fetching a list of fictional users" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/3.0/fictional_users"
        } = conn ->
          json(conn, [
            %{
              "id" => 4,
              "salutation_type" => "male",
              "firstname" => "Rudolph",
              "lastname" => "Smith",
              "email" => "rudolph.smith@example.com",
              "title_id" => nil
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result]} = BexioApiClient.Others.fetch_fictional_users(client)

      assert result.id == 4
      assert result.salutation_type == :male
      assert result.firstname == "Rudolph"
      assert result.lastname == "Smith"
      assert result.email == "rudolph.smith@example.com"
      assert result.title_id == nil
    end
  end

  describe "fetching a fictional user" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/3.0/fictional_users/4"
        } = conn ->
          json(conn, %{
            "id" => 4,
            "salutation_type" => "male",
            "firstname" => "Rudolph",
            "lastname" => "Smith",
            "email" => "rudolph.smith@example.com",
            "title_id" => nil
          })
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.fetch_fictional_user(client, 4)

      assert result.id == 4
      assert result.salutation_type == :male
      assert result.firstname == "Rudolph"
      assert result.lastname == "Smith"
      assert result.email == "rudolph.smith@example.com"
      assert result.title_id == nil
    end
  end

  describe "creating a fictional user" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/3.0/fictional_users"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["email"] == "rudolph.smith@bexio.com"
          assert body_json["salutation_type"] == "male"
          assert body_json["firstname"] == "Rudolph"
          assert body_json["lastname"] == "Smith"

          json(conn, %{
            "id" => 4,
            "salutation_type" => "male",
            "firstname" => "Rudolph",
            "lastname" => "Smith",
            "email" => "rudolph.smith@example.com",
            "title_id" => nil
          })
      end)

      :ok
    end

    test "creates the new user" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Others.create_fictional_user(client, %FictionalUser{
                 id: -1,
                 salutation_type: :male,
                 firstname: "Rudolph",
                 lastname: "Smith",
                 email: "rudolph.smith@bexio.com"
               })

      assert result.id == 4
      assert result.salutation_type == :male
      assert result.firstname == "Rudolph"
      assert result.lastname == "Smith"
      assert result.email == "rudolph.smith@example.com"
      assert result.title_id == nil
    end
  end

  describe "updating a fictional user" do
    setup do
      mock_request(fn
        %{
          method: "PATCH",
          request_path: "/3.0/fictional_users/4"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["email"] == "rudolph.smith@bexio.com"
          assert body_json["salutation_type"] == "male"
          assert body_json["firstname"] == "Rudolph"
          assert body_json["lastname"] == "Smith"

          json(conn, %{
            "id" => 4,
            "salutation_type" => "male",
            "firstname" => "Rudolph",
            "lastname" => "Smith",
            "email" => "rudolph.smith@example.com",
            "title_id" => nil
          })
      end)

      :ok
    end

    test "creates the new user" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Others.update_fictional_user(client, %FictionalUser{
                 id: 4,
                 salutation_type: :male,
                 firstname: "Rudolph",
                 lastname: "Smith",
                 email: "rudolph.smith@bexio.com"
               })

      assert result.id == 4
      assert result.salutation_type == :male
      assert result.firstname == "Rudolph"
      assert result.lastname == "Smith"
      assert result.email == "rudolph.smith@example.com"
      assert result.title_id == nil
    end
  end

  describe "delete a fictional user" do
    setup do
      mock_request(fn
        %{
          method: "DELETE",
          request_path: "/3.0/fictional_users/4"
        } = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "success" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.delete_fictional_user(client, 4)

      assert result == true
    end
  end

  describe "getting access information of logged in user" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/3.0/permissions"
        } = conn ->
          json(conn, %{
            "components" => [
              "api2_access",
              "api3_access",
              "analytics",
              "file_upload",
              "contact",
              "todo",
              "history",
              "project",
              "project_show_conditions",
              "article",
              "admin",
              "user_administration",
              "bill_administration",
              "monitoring",
              "stockmanagement",
              "stockmanagement_changes",
              "dashboard_widget_sales",
              "banking",
              "banking_sync",
              "banking_direct",
              "banking_sgkb",
              "banking_sgkb_oauth2",
              "banking_vabe",
              "banking_vabe_2021H1",
              "banking_tkb",
              "banking_tkb_2021H1",
              "banking_bcju",
              "banking_bcju_2021H1",
              "banking_raif_camt",
              "banking_ubs_camt",
              "banking_bcvl_oauth",
              "accounting_reports",
              "kb_offer",
              "kb_order",
              "kb_invoice",
              "kb_credit_voucher",
              "kb_delivery",
              "kb_account_statement",
              "expense",
              "kb_bill",
              "kb_article_order",
              "kb_wizard_recurring_invoices",
              "kb_wizard_payments",
              "kb_wizard_reminder",
              "kb_wizard_v11",
              "network",
              "document_designer",
              "manual_entries",
              "fm"
            ],
            "permissions" => %{
              "mailchimp" => %{"activation" => "enabled"},
              "document_designer" => %{"activation" => "enabled"},
              "banking_sync" => %{"activation" => "enabled"},
              "banking_direct" => %{"activation" => "enabled"},
              "file_manager_share" => %{"activation" => "enabled"},
              "boxnet" => %{"activation" => "enabled"},
              "history" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "expense" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "file_upload" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "admin" => %{"activation" => "enabled"},
              "kb_credit_voucher" => %{
                "activation" => "enabled",
                "edit" => "all",
                "show" => "all"
              },
              "kb_wizard_payments" => %{"activation" => "enabled"},
              "user_administration" => %{"activation" => "enabled"},
              "monitoring" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "kb_bill" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "kb_order" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "lean_sync" => %{"activation" => "enabled"},
              "project_show_conditions" => %{"activation" => "enabled"},
              "kb_account_statement" => %{
                "activation" => "enabled",
                "edit" => "all",
                "show" => "all"
              },
              "kb_wizard_reminder" => %{"activation" => "enabled"},
              "kb_wizard_v11" => %{"activation" => "enabled"},
              "pingen" => %{"activation" => "enabled"},
              "kb_delivery" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "contact" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "stockmanagement" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "marketing" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "kb_article_order" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "payroll" => %{"activation" => "disabled"},
              "analytics" => %{"activation" => "enabled", "download" => "all"},
              "kb_invoice" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "file_manager" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "bill_administration" => %{"activation" => "enabled"},
              "project" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "banking" => %{"activation" => "enabled", "edit" => "all"},
              "accounting_reports" => %{"activation" => "enabled"},
              "stockmanagement_changes" => %{"edit" => "all"},
              "todo" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "dropbox" => %{"activation" => "enabled"},
              "article" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "dashboard_widget_sales" => %{"activation" => "enabled"},
              "gdrive" => %{"activation" => "enabled"},
              "writer" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "fm" => %{"activation" => "enabled"},
              "calendar" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "kb_offer" => %{"activation" => "enabled", "edit" => "all", "show" => "all"},
              "kb_wizard_recurring_invoices" => %{"activation" => "enabled"}
            }
          })
      end)

      :ok
    end

    test "lists valid permissions" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.get_access_information(client)

      assert length(result.components) == 49

      assert result.permissions.writer.activation == :enabled
      assert result.permissions.gdrive.activation == :enabled
      assert result.permissions.kb_offer.edit == :all
      assert result.permissions.kb_offer.show == :all
    end
  end

  describe "fetching a list of tasks" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/task"
        } = conn ->
          json(conn, [
            %{
              "communication_kind_id" => nil,
              "contact_id" => nil,
              "entry_id" => nil,
              "finish_date" => "2023-03-13 08:00:00",
              "has_reminder" => "true",
              "id" => 2,
              "info" => "Mahnlauf<br /><br />",
              "module_id" => nil,
              "place" => nil,
              "project_id" => nil,
              "remember_time_id" => 3,
              "remember_type_id" => 1,
              "sub_contact_id" => nil,
              "subject" => "Mahnlauf",
              "todo_priority_id" => 4,
              "todo_status_id" => 1,
              "user_id" => 29
            },
            %{
              "communication_kind_id" => nil,
              "contact_id" => nil,
              "entry_id" => nil,
              "finish_date" => "2022-10-17 10:00:00",
              "has_reminder" => "false",
              "id" => 4,
              "info" => "Dessert Testlauf&nbsp;",
              "module_id" => nil,
              "place" => nil,
              "project_id" => nil,
              "remember_time_id" => nil,
              "remember_type_id" => nil,
              "sub_contact_id" => nil,
              "subject" => "Test",
              "todo_priority_id" => 5,
              "todo_status_id" => 5,
              "user_id" => 11
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} = BexioApiClient.Others.fetch_tasks(client)

      assert result1.finish_date == ~N[2023-03-13 08:00:00]
      assert result1.reminder? == true
      assert result1.id == 2
      assert result1.info == "Mahnlauf<br /><br />"
      assert result1.subject == "Mahnlauf"
      assert result1.user_id == 29

      assert result2.finish_date == ~N[2022-10-17 10:00:00]
      assert result2.reminder? == false
      assert result2.id == 4
      assert result2.info == "Dessert Testlauf&nbsp;"
      assert result2.subject == "Test"
      assert result2.user_id == 11
    end
  end

  describe "searching tasks" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/task/search"
        } = conn ->
          json(conn, [
            %{
              "communication_kind_id" => nil,
              "contact_id" => nil,
              "entry_id" => nil,
              "finish_date" => "2023-03-13 08:00:00",
              "has_reminder" => "true",
              "id" => 2,
              "info" => "Mahnlauf<br /><br />",
              "module_id" => nil,
              "place" => nil,
              "project_id" => nil,
              "remember_time_id" => 3,
              "remember_type_id" => 1,
              "sub_contact_id" => nil,
              "subject" => "Mahnlauf",
              "todo_priority_id" => 4,
              "todo_status_id" => 1,
              "user_id" => 29
            },
            %{
              "communication_kind_id" => nil,
              "contact_id" => nil,
              "entry_id" => nil,
              "finish_date" => "2022-10-17 10:00:00",
              "has_reminder" => "false",
              "id" => 4,
              "info" => "Dessert Testlauf&nbsp;",
              "module_id" => nil,
              "place" => nil,
              "project_id" => nil,
              "remember_time_id" => nil,
              "remember_type_id" => nil,
              "sub_contact_id" => nil,
              "subject" => "Test",
              "todo_priority_id" => 5,
              "todo_status_id" => 5,
              "user_id" => 11
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} =
               BexioApiClient.Others.search_tasks(client, [
                 SearchCriteria.nil?(:subject),
                 SearchCriteria.less_than(:reminder, NaiveDateTime.local_now())
               ])

      assert result1.finish_date == ~N[2023-03-13 08:00:00]
      assert result1.reminder? == true
      assert result1.id == 2
      assert result1.info == "Mahnlauf<br /><br />"
      assert result1.subject == "Mahnlauf"
      assert result1.user_id == 29

      assert result2.finish_date == ~N[2022-10-17 10:00:00]
      assert result2.reminder? == false
      assert result2.id == 4
      assert result2.info == "Dessert Testlauf&nbsp;"
      assert result2.subject == "Test"
      assert result2.user_id == 11
    end
  end

  describe "fetching a task" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/task/2"
        } = conn ->
          json(conn, %{
            "communication_kind_id" => nil,
            "contact_id" => nil,
            "entry_id" => nil,
            "finish_date" => "2023-03-13 08:00:00",
            "has_reminder" => "true",
            "id" => 2,
            "info" => "Mahnlauf<br /><br />",
            "module_id" => nil,
            "place" => nil,
            "project_id" => nil,
            "remember_time_id" => 3,
            "remember_type_id" => 1,
            "sub_contact_id" => nil,
            "subject" => "Mahnlauf",
            "todo_priority_id" => 4,
            "todo_status_id" => 1,
            "user_id" => 29
          })
      end)

      :ok
    end

    test "lists found result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.fetch_task(client, 2)

      assert result.finish_date == ~N[2023-03-13 08:00:00]
      assert result.reminder? == true
      assert result.id == 2
      assert result.info == "Mahnlauf<br /><br />"
      assert result.subject == "Mahnlauf"
      assert result.user_id == 29
    end
  end

  describe "creating a task" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/task"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["finish_date"] == "2023-03-13T08:00:00"
          assert body_json["subject"] == "Unterlagen versenden"
          assert body_json["have_remember"] == false

          json(conn, %{
            "communication_kind_id" => nil,
            "contact_id" => nil,
            "entry_id" => nil,
            "finish_date" => "2023-03-13 08:00:00",
            "has_reminder" => "true",
            "id" => 2,
            "info" => "Mahnlauf<br /><br />",
            "module_id" => nil,
            "place" => nil,
            "project_id" => nil,
            "remember_time_id" => 3,
            "remember_type_id" => 1,
            "sub_contact_id" => nil,
            "subject" => "Mahnlauf",
            "todo_priority_id" => 4,
            "todo_status_id" => 1,
            "user_id" => 29
          })
      end)

      :ok
    end

    test "creates a task" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Others.create_task(client, %Todo{
                 id: -1,
                 reminder?: false,
                 finish_date: ~N[2023-03-13 08:00:00],
                 subject: "Unterlagen versenden",
                 user_id: 1,
                 info: "so schnell wie möglich.",
                 todo_status_id: 1
               })

      assert result.finish_date == ~N[2023-03-13 08:00:00]
      assert result.reminder? == true
      assert result.id == 2
      assert result.info == "Mahnlauf<br /><br />"
      assert result.subject == "Mahnlauf"
      assert result.user_id == 29
    end
  end

  describe "updating a task" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/task/2"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["finish_date"] == "2023-03-13T08:00:00"
          assert body_json["subject"] == "Unterlagen versenden"
          assert body_json["have_remember"] == false

          json(conn, %{
            "communication_kind_id" => nil,
            "contact_id" => nil,
            "entry_id" => nil,
            "finish_date" => "2023-03-13 08:00:00",
            "has_reminder" => "true",
            "id" => 2,
            "info" => "Mahnlauf<br /><br />",
            "module_id" => nil,
            "place" => nil,
            "project_id" => nil,
            "remember_time_id" => 3,
            "remember_type_id" => 1,
            "sub_contact_id" => nil,
            "subject" => "Mahnlauf",
            "todo_priority_id" => 4,
            "todo_status_id" => 1,
            "user_id" => 29
          })
      end)

      :ok
    end

    test "updates a task" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Others.edit_task(client, %Todo{
                 id: 2,
                 reminder?: false,
                 finish_date: ~N[2023-03-13 08:00:00],
                 subject: "Unterlagen versenden",
                 user_id: 1,
                 info: "so schnell wie möglich.",
                 todo_status_id: 1
               })

      assert result.finish_date == ~N[2023-03-13 08:00:00]
      assert result.reminder? == true
      assert result.id == 2
      assert result.info == "Mahnlauf<br /><br />"
      assert result.subject == "Mahnlauf"
      assert result.user_id == 29
    end
  end

  describe "deleting a task" do
    setup do
      mock_request(fn
        %{
          method: "DELETE",
          request_path: "/2.0/task/2"
        } = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes a task" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.delete_task(client, 2)

      assert result == true
    end
  end

  describe "fetching a list of task priorities" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/todo_priority"
        } = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "High"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.fetch_task_priorities(client)

      assert result[1] == "High"
    end
  end

  describe "fetching a list of task status" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/todo_status"
        } = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "Open"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.fetch_task_status(client)

      assert result[1] == "Open"
    end
  end

  describe "fetching a list of units" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/unit"
        } = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "h"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.fetch_units(client)

      assert result[1] == "h"
    end
  end

  describe "searching units" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/unit/search"
        } = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "h"
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Others.search_units(client, [
                 SearchCriteria.not_nil?(:name)
               ])

      assert result[1] == "h"
    end
  end

  describe "fetching a unit" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/unit/1"
        } = conn ->
          json(conn, %{
            "id" => 1,
            "name" => "h"
          })
      end)

      :ok
    end

    test "lists found result" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.fetch_unit(client, 1)

      assert result.id == 1
      assert result.name == "h"
    end
  end

  describe "creating a unit" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/unit"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["name"] == "minute"

          json(conn, %{
            "id" => 2,
            "name" => "minute"
          })
      end)

      :ok
    end

    test "creates a unit" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.create_unit(client, "minute")

      assert result.id == 2
      assert result.name == "minute"
    end
  end

  describe "updating a unit" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/unit/1"
        } = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json["name"] == "minute"

          json(conn, %{
            "id" => 1,
            "name" => "minute"
          })
      end)

      :ok
    end

    test "updates a unit" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.edit_unit(client, 1, "minute")

      assert result.id == 1
      assert result.name == "minute"
    end
  end

  describe "deleting a unit" do
    setup do
      mock_request(fn
        %{
          method: "DELETE",
          request_path: "/2.0/unit/2"
        } = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes a unit" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Others.delete_unit(client, 2)

      assert result == true
    end
  end
end
