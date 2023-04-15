defmodule BexioApiClient.OthersTest do
  use ExUnit.Case, async: true

  doctest BexioApiClient.Others

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
end
