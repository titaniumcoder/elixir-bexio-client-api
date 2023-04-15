defmodule BexioApiClient.OthersTest do
  use ExUnit.Case, async: true

  doctest BexioApiClient.Others

  alias BexioApiClient.Others.FictionalUser
  alias BexioApiClient.SearchCriteria

  import Tesla.Mock

  describe "fetching a list of company profiles" do
    setup do
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/2.0/company_profile"
        } ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/company_profile/1"} ->
          json(%{
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
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
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/2.0/country"
        } ->
          json([
            %{
              "id" => 1,
              "name" => "Kiribati",
              "name_short" => "KI",
              "iso3166_alpha2" => "KI"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [result]} = BexioApiClient.Others.fetch_countries(client)

      assert result.id == 1
      assert result.name == "Kiribati"
      assert result.name_short == "KI"
      assert result.iso3166_alpha2 == "KI"
    end
  end

  describe "searching countries" do
    setup do
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/country/search",
          body: _body
        } ->
          json([
            %{
              "id" => 1,
              "name" => "Kiribati",
              "name_short" => "KI",
              "iso3166_alpha2" => "KI"
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [result]} =
               BexioApiClient.Others.search_countries(client, [
                 SearchCriteria.nil?(:name_short),
                 SearchCriteria.part_of(:name, ["fred", "queen"])
               ])

      assert result.id == 1
      assert result.name == "Kiribati"
      assert result.name_short == "KI"
      assert result.iso3166_alpha2 == "KI"
    end
  end

  describe "fetching a single country" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/country/1"} ->
          json(%{
            "id" => 1,
            "name" => "Kiribati",
            "name_short" => "KI",
            "iso3166_alpha2" => "KI"
          })

        %{method: :get, url: "https://api.bexio.com/2.0/country/99"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:ok, result} = BexioApiClient.Others.fetch_country(client, 1)
      assert result.id == 1
      assert result.name == "Kiribati"
      assert result.name_short == "KI"
      assert result.iso3166_alpha2 == "KI"
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:error, :not_found} = BexioApiClient.Others.fetch_country(client, 99)
    end
  end

  describe "fetching a list of languages" do
    setup do
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/2.0/language"
        } ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/language/search",
          body: _body
        } ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/3.0/users"
        } ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/3.0/users/4"
        } ->
          json(%{
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/3.0/fictional_users"
        } ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/3.0/fictional_users/4"
        } ->
          json(%{
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/3.0/fictional_users",
          body: body
        } ->
          body_json = Jason.decode!(body)
          assert body_json["email"] == "rudolph.smith@bexio.com"
          assert body_json["salutation_type"] == "male"
          assert body_json["firstname"] == "Rudolph"
          assert body_json["lastname"] == "Smith"

          json(%{
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{
          method: :patch,
          url: "https://api.bexio.com/3.0/fictional_users/4",
          body: body
        } ->
          body_json = Jason.decode!(body)
          assert body_json["email"] == "rudolph.smith@bexio.com"
          assert body_json["salutation_type"] == "male"
          assert body_json["firstname"] == "Rudolph"
          assert body_json["lastname"] == "Smith"

          json(%{
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{
          method: :delete,
          url: "https://api.bexio.com/3.0/fictional_users/4"
        } ->
          json(%{"success" => true})
      end)

      :ok
    end

    test "success" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, result} = BexioApiClient.Others.delete_fictional_user(client, 4)

      assert result == true
    end
  end

  describe "getting access information of logged in user" do
    setup do
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/3.0/permissions"
        } ->
          json(%{
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, result} = BexioApiClient.Others.get_access_information(client)

      assert length(result.components) == 49

      assert result.permissions.writer.activation == :enabled
      assert result.permissions.gdrive.activation == :enabled
      assert result.permissions.kb_offer.edit == :all
      assert result.permissions.kb_offer.show == :all
    end
  end
end
