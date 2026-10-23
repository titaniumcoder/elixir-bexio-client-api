defmodule BexioApiClient.ContactsTest do
  use TestHelper

  use ExUnit.Case, async: true

  doctest BexioApiClient.Contacts

  alias BexioApiClient.Contacts.AdditionalAddress
  alias BexioApiClient.Contacts.Contact
  alias BexioApiClient.Contacts.ContactRelation
  alias BexioApiClient.SearchCriteria

  describe "fetching a list of contacts" do
    setup do
      mock_request(fn
        %{
          method: "GET",
          request_path: "/2.0/contact"
        } = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["show_archived"] == "true"
          assert conn.query_params["limit"] == "100"
          assert conn.query_params["offset"] == "50"
          assert conn.query_params["order_by"] == "id"

          json(conn, [
            %{
              "id" => 111,
              "nr" => "998776",
              "contact_type_id" => 1,
              "name_1" => "Tester AG",
              "name_2" => "Die Testing Firma",
              "salutation_id" => 0,
              "salutation_form" => 1,
              "title_id" => 2,
              "birthday" => nil,
              "address" => "Teststrasse 999",
              "street_name" => "Teststrasse",
              "house_number" => "999",
              "address_addition" => nil,
              "postcode" => "9999",
              "city" => "Testcity",
              "country_id" => 3,
              "mail" => "unknown@testing-ag.inv",
              "mail_second" => "unknown2@testing-ag.inv",
              "phone_fixed" => "099 999 99 99",
              "phone_fixed_second" => "088 888 88 88",
              "phone_mobile" => "077 777 77 77",
              "fax" => "066 666 66 66",
              "url" => "http://unbekannte.url",
              "skype_name" => "ich.bin.in.skype",
              "remarks" => "Lange schoene Bemerkungen",
              "is_lead" => false,
              "language_id" => 4,
              "contact_group_ids" => "2,22,2,3",
              "contact_branch_ids" => "3,33,3,99",
              "user_id" => 5,
              "owner_id" => 6,
              "updated_at" => "2022-09-13 09:14:21"
            },
            %{
              "id" => 311,
              "nr" => "103370",
              "contact_type_id" => 2,
              "name_1" => "Mueller",
              "name_2" => nil,
              "salutation_id" => nil,
              "salutation_form" => nil,
              "title_id" => nil,
              "birthday" => "1973-06-29",
              "address" => nil,
              "street_name" => "Teststrasse",
              "house_number" => "999",
              "address_addition" => nil,
              "postcode" => nil,
              "city" => nil,
              "country_id" => nil,
              "mail" => nil,
              "mail_second" => nil,
              "phone_fixed" => nil,
              "phone_fixed_second" => nil,
              "phone_mobile" => nil,
              "fax" => nil,
              "url" => nil,
              "skype_name" => nil,
              "remarks" => nil,
              "is_lead" => false,
              "language_id" => nil,
              "contact_group_ids" => nil,
              "contact_branch_ids" => nil,
              "user_id" => 2,
              "owner_id" => 3,
              "updated_at" => "2012-01-21 11:56:55"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} =
               BexioApiClient.Contacts.fetch_contacts(
                 client,
                 true,
                 limit: 100,
                 offset: 50,
                 order_by: :id
               )

      assert result1.id == 111
      assert result1.nr == 998_776
      assert result1.contact_type == :company
      assert result1.name_1 == "Tester AG"
      assert result1.name_2 == "Die Testing Firma"
      assert result1.salutation_id == 0
      assert result1.salutation_form == 1
      assert result1.title_id == 2
      assert result1.birthday == nil
      assert result1.address == "Teststrasse 999"
      assert result1.street_name == "Teststrasse"
      assert result1.house_number == "999"
      assert result1.address_addition == nil
      assert result1.lead? == false
      assert result1.postcode == "9999"
      assert result1.city == "Testcity"
      assert result1.country_id == 3
      assert result1.mail == "unknown@testing-ag.inv"
      assert result1.mail_second == "unknown2@testing-ag.inv"
      assert result1.phone_fixed == "099 999 99 99"
      assert result1.phone_fixed_second == "088 888 88 88"
      assert result1.phone_mobile == "077 777 77 77"
      assert result1.fax == "066 666 66 66"
      assert result1.url == "http://unbekannte.url"
      assert result1.skype_name == "ich.bin.in.skype"
      assert result1.remarks == "Lange schoene Bemerkungen"
      assert result1.language_id == 4
      assert result1.contact_group_ids == [2, 3, 22]
      assert result1.contact_branch_ids == [3, 33, 99]
      assert result1.updated_at == ~N[2022-09-13 09:14:21]

      assert result2.id == 311
      assert result2.nr == 103_370
      assert result2.contact_type == :person
      assert result2.name_1 == "Mueller"
      assert result2.name_2 == nil
      assert result2.salutation_id == nil
      assert result2.salutation_form == nil
      assert result2.title_id == nil
      assert result2.birthday == ~D[1973-06-29]
      assert result2.address == nil
      assert result2.postcode == nil
      assert result2.city == nil
      assert result2.country_id == nil
      assert result2.mail == nil
      assert result2.mail_second == nil
      assert result2.phone_fixed == nil
      assert result2.phone_fixed_second == nil
      assert result2.phone_mobile == nil
      assert result2.fax == nil
      assert result2.url == nil
      assert result2.skype_name == nil
      assert result2.remarks == nil
      assert result2.language_id == nil
      assert result2.contact_group_ids == []
      assert result2.contact_branch_ids == []
      assert result2.updated_at == ~N[2012-01-21 11:56:55]
    end
  end

  describe "searching contacts" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/contact/search"
        } = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["show_archived"] == "true"
          assert conn.query_params["limit"] == "100"
          assert conn.query_params["offset"] == "50"
          assert conn.query_params["order_by"] == "id"

          json(conn, [
            %{
              "id" => 111,
              "nr" => "998776",
              "contact_type_id" => 1,
              "name_1" => "Tester AG",
              "name_2" => "Die Testing Firma",
              "salutation_id" => 0,
              "salutation_form" => 1,
              "title_id" => 2,
              "birthday" => nil,
              "address" => "Teststrasse 999",
              "street_name" => "Teststrasse",
              "house_number" => "999",
              "address_addition" => nil,
              "postcode" => "9999",
              "city" => "Testcity",
              "country_id" => 3,
              "mail" => "unknown@testing-ag.inv",
              "mail_second" => "unknown2@testing-ag.inv",
              "phone_fixed" => "099 999 99 99",
              "phone_fixed_second" => "088 888 88 88",
              "phone_mobile" => "077 777 77 77",
              "fax" => "066 666 66 66",
              "url" => "http://unbekannte.url",
              "skype_name" => "ich.bin.in.skype",
              "remarks" => "Lange schoene Bemerkungen",
              "is_lead" => false,
              "language_id" => 4,
              "contact_group_ids" => "2,22,2,3",
              "contact_branch_ids" => "3,33,3,99",
              "user_id" => 5,
              "owner_id" => 6,
              "updated_at" => "2022-09-13 09:14:21"
            },
            %{
              "id" => 311,
              "nr" => "103370",
              "contact_type_id" => 2,
              "name_1" => "Mueller",
              "name_2" => nil,
              "salutation_id" => nil,
              "salutation_form" => nil,
              "title_id" => nil,
              "birthday" => "1973-06-29",
              "address" => nil,
              "street_name" => "Teststrasse",
              "house_number" => "999",
              "address_addition" => nil,
              "postcode" => nil,
              "city" => nil,
              "country_id" => nil,
              "mail" => nil,
              "mail_second" => nil,
              "phone_fixed" => nil,
              "phone_fixed_second" => nil,
              "phone_mobile" => nil,
              "fax" => nil,
              "url" => nil,
              "skype_name" => nil,
              "remarks" => nil,
              "is_lead" => false,
              "language_id" => nil,
              "contact_group_ids" => nil,
              "contact_branch_ids" => nil,
              "user_id" => 2,
              "owner_id" => 3,
              "updated_at" => "2012-01-21 11:56:55"
            }
          ])
      end)

      :ok
    end

    test "lists found results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} =
               BexioApiClient.Contacts.search_contacts(
                 client,
                 [
                   SearchCriteria.nil?(:name_2),
                   SearchCriteria.part_of(:name_1, ["fred", "queen"])
                 ],
                 true,
                 limit: 100,
                 offset: 50,
                 order_by: :id
               )

      assert result1.id == 111
      assert result1.nr == 998_776
      assert result1.contact_type == :company
      assert result1.name_1 == "Tester AG"
      assert result1.name_2 == "Die Testing Firma"
      assert result1.salutation_id == 0
      assert result1.salutation_form == 1
      assert result1.title_id == 2
      assert result1.birthday == nil
      assert result1.address == "Teststrasse 999"
      assert result1.street_name == "Teststrasse"
      assert result1.house_number == "999"
      assert result1.address_addition == nil
      assert result1.lead? == false
      assert result1.postcode == "9999"
      assert result1.city == "Testcity"
      assert result1.country_id == 3
      assert result1.mail == "unknown@testing-ag.inv"
      assert result1.mail_second == "unknown2@testing-ag.inv"
      assert result1.phone_fixed == "099 999 99 99"
      assert result1.phone_fixed_second == "088 888 88 88"
      assert result1.phone_mobile == "077 777 77 77"
      assert result1.fax == "066 666 66 66"
      assert result1.url == "http://unbekannte.url"
      assert result1.skype_name == "ich.bin.in.skype"
      assert result1.remarks == "Lange schoene Bemerkungen"
      assert result1.language_id == 4
      assert result1.contact_group_ids == [2, 3, 22]
      assert result1.contact_branch_ids == [3, 33, 99]
      assert result1.updated_at == ~N[2022-09-13 09:14:21]

      assert result2.id == 311
      assert result2.nr == 103_370
      assert result2.contact_type == :person
      assert result2.name_1 == "Mueller"
      assert result2.name_2 == nil
      assert result2.salutation_id == nil
      assert result2.salutation_form == nil
      assert result2.title_id == nil
      assert result2.birthday == ~D[1973-06-29]
      assert result2.address == nil
      assert result2.postcode == nil
      assert result2.city == nil
      assert result2.country_id == nil
      assert result2.mail == nil
      assert result2.mail_second == nil
      assert result2.phone_fixed == nil
      assert result2.phone_fixed_second == nil
      assert result2.phone_mobile == nil
      assert result2.fax == nil
      assert result2.url == nil
      assert result2.skype_name == nil
      assert result2.remarks == nil
      assert result2.language_id == nil
      assert result2.contact_group_ids == []
      assert result2.contact_branch_ids == []
      assert result2.updated_at == ~N[2012-01-21 11:56:55]
    end
  end

  describe "fetching a single contact" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/contact/34"} = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["show_archived"] == "true"

          json(conn, %{
            "id" => 33,
            "nr" => "998776",
            "contact_type_id" => 1,
            "name_1" => "Tester AG",
            "name_2" => "Die Testing Firma",
            "salutation_id" => 0,
            "salutation_form" => 1,
            "title_id" => 2,
            "birthday" => nil,
            "address" => "Teststrasse 999",
            "street_name" => "Teststrasse",
            "house_number" => "999",
            "address_addition" => nil,
            "postcode" => "9999",
            "city" => "Testcity",
            "country_id" => 3,
            "mail" => "unknown@testing-ag.inv",
            "mail_second" => "unknown2@testing-ag.inv",
            "phone_fixed" => "099 999 99 99",
            "phone_fixed_second" => "088 888 88 88",
            "phone_mobile" => "077 777 77 77",
            "fax" => "066 666 66 66",
            "url" => "http://unbekannte.url",
            "skype_name" => "ich.bin.in.skype",
            "remarks" => "Lange schoene Bemerkungen",
            "language_id" => 4,
            "is_lead" => false,
            "contact_group_ids" => "2,22,2,3",
            "contact_branch_ids" => "3,33,3,99",
            "user_id" => 5,
            "owner_id" => 6,
            "updated_at" => "2022-09-13 09:14:21"
          })

        %{method: "GET", request_path: "/2.0/contact/33"} = conn ->
          conn = fetch_query_params(conn)
          assert conn.query_params["show_archived"] == ""

          json(conn, %{
            "id" => 44,
            "nr" => "998776",
            "contact_type_id" => 1,
            "name_1" => "Tester AG",
            "name_2" => "Die Testing Firma",
            "salutation_id" => 0,
            "salutation_form" => 1,
            "title_id" => 2,
            "birthday" => nil,
            "address" => "Teststrasse 999",
            "street_name" => "Teststrasse",
            "house_number" => "999",
            "address_addition" => nil,
            "postcode" => "9999",
            "city" => "Testcity",
            "country_id" => 3,
            "mail" => "unknown@testing-ag.inv",
            "mail_second" => "unknown2@testing-ag.inv",
            "phone_fixed" => "099 999 99 99",
            "phone_fixed_second" => "088 888 88 88",
            "phone_mobile" => "077 777 77 77",
            "fax" => "066 666 66 66",
            "url" => "http://unbekannte.url",
            "skype_name" => "ich.bin.in.skype",
            "remarks" => "Lange schoene Bemerkungen",
            "is_lead" => false,
            "language_id" => 4,
            "contact_group_ids" => "2,22,2,3",
            "contact_branch_ids" => "3,33,3,99",
            "user_id" => 5,
            "owner_id" => 6,
            "updated_at" => "2022-09-13 09:14:21"
          })

        %{method: "GET", request_path: "/2.0/contact/99"} = conn ->
          send_resp(conn, 404, "Contact does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, result} = BexioApiClient.Contacts.fetch_contact(client, 33)
      assert result.id == 44
      assert result.nr == 998_776
      assert result.contact_type == :company
      assert result.name_1 == "Tester AG"
      assert result.name_2 == "Die Testing Firma"
      assert result.salutation_id == 0
      assert result.salutation_form == 1
      assert result.title_id == 2
      assert result.birthday == nil
      assert result.address == "Teststrasse 999"
      assert result.postcode == "9999"
      assert result.city == "Testcity"
      assert result.country_id == 3
      assert result.mail == "unknown@testing-ag.inv"
      assert result.mail_second == "unknown2@testing-ag.inv"
      assert result.phone_fixed == "099 999 99 99"
      assert result.phone_fixed_second == "088 888 88 88"
      assert result.phone_mobile == "077 777 77 77"
      assert result.fax == "066 666 66 66"
      assert result.url == "http://unbekannte.url"
      assert result.skype_name == "ich.bin.in.skype"
      assert result.remarks == "Lange schoene Bemerkungen"
      assert result.language_id == 4
      assert result.contact_group_ids == [2, 3, 22]
      assert result.contact_branch_ids == [3, 33, 99]
      assert result.updated_at == ~N[2022-09-13 09:14:21]
    end

    test "shows valid result with archive" do
      client = BexioApiClient.new("123")
      assert {:ok, result} = BexioApiClient.Contacts.fetch_contact(client, 34, true)
      assert result.id == 33
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Contact does not exist"} =
               BexioApiClient.Contacts.fetch_contact(client, 99)
    end
  end

  test "handles null nr and profile_image from the show response" do
    mock_request(fn
      %{method: "GET", request_path: "/2.0/contact/55"} = conn ->
        json(conn, %{
          "id" => 55,
          "nr" => nil,
          "contact_type_id" => 1,
          "name_1" => "Tester AG",
          "name_2" => nil,
          "salutation_id" => nil,
          "salutation_form" => nil,
          "title_id" => nil,
          "birthday" => nil,
          "address" => nil,
          "street_name" => nil,
          "house_number" => nil,
          "address_addition" => nil,
          "postcode" => nil,
          "city" => nil,
          "country_id" => nil,
          "mail" => nil,
          "mail_second" => nil,
          "phone_fixed" => nil,
          "phone_fixed_second" => nil,
          "phone_mobile" => nil,
          "fax" => nil,
          "url" => nil,
          "skype_name" => nil,
          "remarks" => nil,
          "is_lead" => false,
          "language_id" => nil,
          "contact_group_ids" => nil,
          "contact_branch_ids" => nil,
          "user_id" => 5,
          "owner_id" => 6,
          "updated_at" => "2022-09-13 09:14:21",
          "profile_image" => "aGVsbG8="
        })
    end)

    client = BexioApiClient.new("123")

    assert {:ok, result} = BexioApiClient.Contacts.fetch_contact(client, 55, false)
    assert result.nr == nil
    assert result.profile_image == "aGVsbG8="
  end

  describe "fetching a list of contact relations" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/contact_relation"} = conn ->
          json(conn, [
            %{
              "id" => 111,
              "contact_id" => 1,
              "contact_sub_id" => 2,
              "description" => "Description 1",
              "updated_at" => "2022-09-13 09:14:21"
            },
            %{
              "id" => 222,
              "contact_id" => 3,
              "contact_sub_id" => 4,
              "description" => "Description 2",
              "updated_at" => "2023-09-13 09:14:21"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} = BexioApiClient.Contacts.fetch_contact_relations(client)

      assert result1.id == 111
      assert result1.contact_id == 1
      assert result1.contact_sub_id == 2
      assert result1.description == "Description 1"
      assert result1.updated_at == ~N[2022-09-13 09:14:21]

      assert result2.id == 222
      assert result2.contact_id == 3
      assert result2.contact_sub_id == 4
      assert result2.description == "Description 2"
      assert result2.updated_at == ~N[2023-09-13 09:14:21]
    end
  end

  describe "searching contact relations" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact_relation/search"} = conn ->
          json(conn, [
            %{
              "id" => 111,
              "contact_id" => 1,
              "contact_sub_id" => 2,
              "description" => "Description 1",
              "updated_at" => "2022-09-13 09:14:21"
            },
            %{
              "id" => 222,
              "contact_id" => 3,
              "contact_sub_id" => 4,
              "description" => "Description 2",
              "updated_at" => "2023-09-13 09:14:21"
            }
          ])
      end)

      :ok
    end

    test "shows found results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} =
               BexioApiClient.Contacts.search_contact_relations(client, [
                 SearchCriteria.nil?(:name_2),
                 SearchCriteria.part_of(:name_1, ["fred", "queen"])
               ])

      assert result1.id == 111
      assert result1.contact_id == 1
      assert result1.contact_sub_id == 2
      assert result1.description == "Description 1"
      assert result1.updated_at == ~N[2022-09-13 09:14:21]

      assert result2.id == 222
      assert result2.contact_id == 3
      assert result2.contact_sub_id == 4
      assert result2.description == "Description 2"
      assert result2.updated_at == ~N[2023-09-13 09:14:21]
    end
  end

  describe "fetching a single contact relation" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/contact_relation/111"} = conn ->
          json(conn, %{
            "id" => 111,
            "contact_id" => 1,
            "contact_sub_id" => 2,
            "description" => "Description 1",
            "updated_at" => "2022-09-13 09:14:21"
          })

        %{method: "GET", request_path: "/2.0/contact_relation/99"} = conn ->
          send_resp(conn, 404, "Contact Relation does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, result} = BexioApiClient.Contacts.fetch_contact_relation(client, 111)
      assert result.id == 111
      assert result.contact_id == 1
      assert result.contact_sub_id == 2
      assert result.description == "Description 1"
      assert result.updated_at == ~N[2022-09-13 09:14:21]
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Contact Relation does not exist"} =
               BexioApiClient.Contacts.fetch_contact_relation(client, 99)
    end
  end

  describe "fetching a list of contact groups" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/contact_group"} = conn ->
          json(conn, [
            %{
              "id" => 111,
              "name" => "Contact Group 1"
            },
            %{
              "id" => 222,
              "name" => "Contact Group 2"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Contacts.fetch_contact_groups(client)

      assert result[111] == "Contact Group 1"
      assert result[222] == "Contact Group 2"
    end
  end

  describe "searching contact groups" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact_group/search"} = conn ->
          json(conn, [
            %{
              "id" => 111,
              "name" => "Contact Group 1"
            },
            %{
              "id" => 222,
              "name" => "Contact Group 2"
            }
          ])
      end)

      :ok
    end

    test "shows found results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Contacts.search_contact_groups(client, [
                 SearchCriteria.part_of(:name, ["fred", "queen"])
               ])

      assert result[111] == "Contact Group 1"
      assert result[222] == "Contact Group 2"
    end
  end

  describe "fetching a single contact group" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/contact_group/111"} = conn ->
          json(conn, %{
            "id" => 111,
            "name" => "Contact Group 1"
          })

        %{method: "GET", request_path: "/2.0/contact_group/99"} = conn ->
          send_resp(conn, 404, "Contact group does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, result} = BexioApiClient.Contacts.fetch_contact_group(client, 111)
      assert result.id == 111
      assert result.name == "Contact Group 1"
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Contact group does not exist"} =
               BexioApiClient.Contacts.fetch_contact_group(client, 99)
    end
  end

  describe "fetching a list of contact sectors" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/contact_branch"} = conn ->
          json(conn, [
            %{
              "id" => 111,
              "name" => "Contact Sector 1"
            },
            %{
              "id" => 222,
              "name" => "Contact Sector 2"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Contacts.fetch_contact_sectors(client)

      assert result[111] == "Contact Sector 1"
      assert result[222] == "Contact Sector 2"
    end
  end

  describe "searching contact sectors" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact_branch/search"} = conn ->
          json(conn, [
            %{
              "id" => 111,
              "name" => "Contact Sector 1"
            },
            %{
              "id" => 222,
              "name" => "Contact Sector 2"
            }
          ])
      end)

      :ok
    end

    test "shows found results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Contacts.search_contact_sectors(client, [
                 SearchCriteria.part_of(:name, ["fred", "queen"])
               ])

      assert result[111] == "Contact Sector 1"
      assert result[222] == "Contact Sector 2"
    end
  end

  describe "fetching a list of additional addresses" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/contact/3/additional_address"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "My new address",
              "name_addition" => nil,
              "address" => "Walter Street 22",
              "street_name" => "Teststrasse",
              "house_number" => "999",
              "address_addition" => nil,
              "postcode" => 9000,
              "city" => "St. Gallen",
              "country_id" => 1,
              "subject" => "Additional address",
              "description" => "This is an internal description"
            },
            %{
              "id" => 2,
              "name" => "My new address",
              "name_addition" => nil,
              "address" => "Walter Street 22",
              "street_name" => "Teststrasse",
              "house_number" => "999",
              "address_addition" => nil,
              "postcode" => 9000,
              "city" => "St. Gallen",
              "country_id" => 1,
              "subject" => "Additional address",
              "description" => "This is an internal description"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} =
               BexioApiClient.Contacts.fetch_additional_addresses(client, 3)

      assert result1.id == 1
      assert result1.name == "My new address"
      assert result1.address == "Walter Street 22"
      assert result1.postcode == 9000
      assert result1.city == "St. Gallen"
      assert result1.country_id == 1
      assert result1.subject == "Additional address"
      assert result1.description == "This is an internal description"

      assert result2.id == 2
    end
  end

  describe "searching additional addresses" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/contact/3/additional_address/search"
        } = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "My new address",
              "name_addition" => nil,
              "address" => "Walter Street 22",
              "street_name" => "Teststrasse",
              "house_number" => "999",
              "address_addition" => nil,
              "postcode" => 9000,
              "city" => "St. Gallen",
              "country_id" => 1,
              "subject" => "Additional address",
              "description" => "This is an internal description"
            },
            %{
              "id" => 2,
              "name" => "My new address",
              "name_addition" => nil,
              "address" => "Walter Street 22",
              "street_name" => "Teststrasse",
              "house_number" => "999",
              "address_addition" => nil,
              "postcode" => 9000,
              "city" => "St. Gallen",
              "country_id" => 1,
              "subject" => "Additional address",
              "description" => "This is an internal description"
            }
          ])
      end)

      :ok
    end

    test "shows found results" do
      client = BexioApiClient.new("123")

      assert {:ok, [result1, result2]} =
               BexioApiClient.Contacts.search_additional_addresses(client, 3, [
                 SearchCriteria.part_of(:name, ["fred", "queen"])
               ])

      assert result1.id == 1
      assert result1.name == "My new address"
      assert result1.address == "Walter Street 22"
      assert result1.postcode == 9000
      assert result1.city == "St. Gallen"
      assert result1.country_id == 1
      assert result1.subject == "Additional address"
      assert result1.description == "This is an internal description"

      assert result2.id == 2
    end
  end

  describe "fetching a single additional address" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/contact/3/additional_address/1"} = conn ->
          json(conn, %{
            "id" => 1,
            "name" => "My new address",
            "name_addition" => nil,
            "address" => "Walter Street 22",
            "street_name" => "Teststrasse",
            "house_number" => "999",
            "address_addition" => nil,
            "postcode" => 9000,
            "city" => "St. Gallen",
            "country_id" => 1,
            "subject" => "Additional address",
            "description" => "This is an internal description"
          })

        %{method: "GET", request_path: "/2.0/contact/3/additional_address/3"} = conn ->
          send_resp(conn, 404, "Additional Address does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, result} = BexioApiClient.Contacts.fetch_additional_address(client, 3, 1)
      assert result.id == 1
      assert result.name == "My new address"
      assert result.address == "Walter Street 22"
      assert result.postcode == 9000
      assert result.city == "St. Gallen"
      assert result.country_id == 1
      assert result.subject == "Additional address"
      assert result.description == "This is an internal description"
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Additional Address does not exist"} =
               BexioApiClient.Contacts.fetch_additional_address(client, 3, 3)
    end
  end

  describe "fetching a list of salutations" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/salutation"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "Herr"
            },
            %{
              "id" => 2,
              "name" => "Frau"
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Contacts.fetch_salutations(client)

      assert result[1] == "Herr"
      assert result[2] == "Frau"
    end
  end

  describe "searching salutations" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/salutation/search"
        } = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "Herr"
            },
            %{
              "id" => 2,
              "name" => "Frau"
            }
          ])
      end)

      :ok
    end

    test "shows found results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Contacts.search_salutations(client, [
                 SearchCriteria.part_of(:name, ["fred", "queen"])
               ])

      assert result[1] == "Herr"
      assert result[2] == "Frau"
    end
  end

  describe "fetching a single salutation" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/salutation/1"} = conn ->
          json(conn, %{
            "id" => 1,
            "name" => "Herr"
          })

        %{method: "GET", request_path: "/2.0/salutation/2"} = conn ->
          send_resp(conn, 404, "Salutation does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, result} = BexioApiClient.Contacts.fetch_salutation(client, 1)
      assert result.id == 1
      assert result.name == "Herr"
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Salutation does not exist"} =
               BexioApiClient.Contacts.fetch_salutation(client, 2)
    end
  end

  describe "fetching a list of titles" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/title"} = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "Dr."
            },
            %{
              "id" => 2,
              "name" => "Prof."
            }
          ])
      end)

      :ok
    end

    test "lists valid results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} = BexioApiClient.Contacts.fetch_titles(client)

      assert result[1] == "Dr."
      assert result[2] == "Prof."
    end
  end

  describe "searching titles" do
    setup do
      mock_request(fn
        %{
          method: "POST",
          request_path: "/2.0/title/search"
        } = conn ->
          json(conn, [
            %{
              "id" => 1,
              "name" => "Dr."
            },
            %{
              "id" => 2,
              "name" => "Prof."
            }
          ])
      end)

      :ok
    end

    test "shows found results" do
      client = BexioApiClient.new("123")

      assert {:ok, result} =
               BexioApiClient.Contacts.search_titles(client, [
                 SearchCriteria.part_of(:name, ["fred", "queen"])
               ])

      assert result[1] == "Dr."
      assert result[2] == "Prof."
    end
  end

  describe "fetching a single title" do
    setup do
      mock_request(fn
        %{method: "GET", request_path: "/2.0/title/1"} = conn ->
          json(conn, %{
            "id" => 1,
            "name" => "Dr."
          })

        %{method: "GET", request_path: "/2.0/title/2"} = conn ->
          send_resp(conn, 404, "Contact group does not exist")
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123")
      assert {:ok, result} = BexioApiClient.Contacts.fetch_title(client, 1)
      assert result.id == 1
      assert result.name == "Dr."
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Contact group does not exist"} =
               BexioApiClient.Contacts.fetch_title(client, 2)
    end
  end

  # response samples from docs/reference/contacts.md
  defp contact_response do
    %{
      "id" => 4,
      "nr" => nil,
      "contact_type_id" => 1,
      "name_1" => "Example Company",
      "name_2" => nil,
      "salutation_id" => 2,
      "salutation_form" => nil,
      "title_id" => nil,
      "birthday" => nil,
      "address" => "Smith Street 22",
      "street_name" => "Smith Street",
      "house_number" => "77",
      "address_addition" => "Building C",
      "postcode" => "8004",
      "city" => "Zurich",
      "country_id" => 1,
      "mail" => "contact@example.org",
      "mail_second" => "",
      "phone_fixed" => "",
      "phone_fixed_second" => "",
      "phone_mobile" => "",
      "fax" => "",
      "url" => "",
      "skype_name" => "",
      "remarks" => "",
      "language_id" => nil,
      "is_lead" => false,
      "contact_group_ids" => "1,2",
      "contact_branch_ids" => nil,
      "user_id" => 1,
      "owner_id" => 1,
      "updated_at" => "2019-04-08 13:17:32",
      "profile_image" => "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
    }
  end

  defp contact_without_profile_image do
    Map.delete(contact_response(), "profile_image")
  end

  defp contact_to_create do
    Contact.new(%{
      contact_type: :company,
      name_1: "Example Company",
      birthday: ~D[2019-04-08],
      street_name: "Smith Street",
      house_number: "77",
      address_addition: "Building C",
      postcode: "8004",
      city: "Zurich",
      country_id: 1,
      mail: "contact@example.org",
      contact_group_ids: [1, 2],
      user_id: 1,
      owner_id: 1
    })
  end

  defp assert_contact_created(contact) do
    assert contact.id == 4
    assert contact.nr == nil
    assert contact.contact_type == :company
    assert contact.name_1 == "Example Company"
    assert contact.salutation_id == 2
    assert contact.birthday == nil
    assert contact.street_name == "Smith Street"
    assert contact.house_number == "77"
    assert contact.address_addition == "Building C"
    assert contact.postcode == "8004"
    assert contact.city == "Zurich"
    assert contact.country_id == 1
    assert contact.mail == "contact@example.org"
    assert contact.contact_group_ids == [1, 2]
    assert contact.contact_branch_ids == []
    assert contact.user_id == 1
    assert contact.owner_id == 1
    assert contact.updated_at == ~N[2019-04-08 13:17:32]
  end

  describe "creating a contact" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json == %{
                   "nr" => nil,
                   "contact_type_id" => 1,
                   "name_1" => "Example Company",
                   "name_2" => nil,
                   "salutation_id" => nil,
                   "salutation_form" => nil,
                   "title_id" => nil,
                   "birthday" => "2019-04-08",
                   "street_name" => "Smith Street",
                   "house_number" => "77",
                   "address_addition" => "Building C",
                   "postcode" => "8004",
                   "city" => "Zurich",
                   "country_id" => 1,
                   "mail" => "contact@example.org",
                   "mail_second" => nil,
                   "phone_fixed" => nil,
                   "phone_fixed_second" => nil,
                   "phone_mobile" => nil,
                   "fax" => nil,
                   "url" => nil,
                   "skype_name" => nil,
                   "remarks" => nil,
                   "language_id" => nil,
                   "contact_group_ids" => "1,2",
                   "contact_branch_ids" => nil,
                   "user_id" => 1,
                   "owner_id" => 1
                 }

          json(conn, contact_response())
      end)

      :ok
    end

    test "creates the contact" do
      client = BexioApiClient.new("123")

      assert {:ok, contact} = BexioApiClient.Contacts.create_contact(client, contact_to_create())
      assert_contact_created(contact)
      assert contact.profile_image == "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
    end

    test "returns a validation error on 422" do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact"} = conn ->
          send_resp(conn, 422, "Validation error")
      end)

      client = BexioApiClient.new("123")

      assert {:error, :could_not_be_saved, "Validation error"} =
               BexioApiClient.Contacts.create_contact(client, contact_to_create())
    end
  end

  describe "editing a contact" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact/4"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["name_1"] == "Example Company"
          assert body_json["contact_type_id"] == 1

          json(conn, contact_response())
      end)

      :ok
    end

    test "edits the contact" do
      client = BexioApiClient.new("123")
      contact = Contact.new(%{contact_to_create() | id: 4})

      assert {:ok, contact} = BexioApiClient.Contacts.edit_contact(client, contact)
      assert_contact_created(contact)
    end
  end

  describe "deleting a contact" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/contact/4"} = conn ->
          json(conn, %{"success" => true})

        %{method: "DELETE", request_path: "/2.0/contact/99"} = conn ->
          send_resp(conn, 404, "Contact does not exist")
      end)

      :ok
    end

    test "deletes the contact" do
      client = BexioApiClient.new("123")
      assert {:ok, true} = BexioApiClient.Contacts.delete_contact(client, 4)
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123")

      assert {:error, :not_found, "Contact does not exist"} =
               BexioApiClient.Contacts.delete_contact(client, 99)
    end
  end

  describe "bulk creating contacts" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact/_bulk_create"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert length(body_json) == 2
          assert Enum.at(body_json, 0)["name_1"] == "Example Company"
          assert Enum.at(body_json, 0)["contact_type_id"] == 1
          assert Enum.at(body_json, 1)["name_1"] == "Jane Doe"
          assert Enum.at(body_json, 1)["contact_type_id"] == 2

          json(conn, [contact_without_profile_image()])
      end)

      :ok
    end

    test "creates all contacts" do
      client = BexioApiClient.new("123")

      assert {:ok, [contact]} =
               BexioApiClient.Contacts.bulk_create_contacts(client, [
                 contact_to_create(),
                 Contact.new(%{
                   contact_type: :person,
                   name_1: "Jane Doe",
                   user_id: 1,
                   owner_id: 1
                 })
               ])

      assert_contact_created(contact)
      assert contact.profile_image == nil
    end
  end

  describe "restoring a contact" do
    setup do
      mock_request(fn
        %{method: "PATCH", request_path: "/2.0/contact/4/restore"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "restores the contact" do
      client = BexioApiClient.new("123")
      assert {:ok, true} = BexioApiClient.Contacts.restore_contact(client, 4)
    end
  end

  describe "creating a contact relation" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact_relation"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json == %{"contact_id" => 2, "contact_sub_id" => 3, "description" => "CEO"}

          json(conn, %{
            "id" => 4,
            "contact_id" => 2,
            "contact_sub_id" => 3,
            "description" => "CEO",
            "updated_at" => "2019-04-08 13:17:32"
          })
      end)

      :ok
    end

    test "creates the contact relation" do
      client = BexioApiClient.new("123")

      assert {:ok, relation} =
               BexioApiClient.Contacts.create_contact_relation(
                 client,
                 ContactRelation.new(%{contact_id: 2, contact_sub_id: 3, description: "CEO"})
               )

      assert relation.id == 4
      assert relation.contact_id == 2
      assert relation.contact_sub_id == 3
      assert relation.description == "CEO"
      assert relation.updated_at == ~N[2019-04-08 13:17:32]
    end
  end

  describe "editing a contact relation" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact_relation/4"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["contact_id"] == 2
          assert body_json["contact_sub_id"] == 3
          assert body_json["description"] == "CEO"

          json(conn, %{
            "id" => 4,
            "contact_id" => 2,
            "contact_sub_id" => 3,
            "description" => "CEO",
            "updated_at" => "2019-04-08 13:17:32"
          })
      end)

      :ok
    end

    test "edits the contact relation" do
      client = BexioApiClient.new("123")

      assert {:ok, relation} =
               BexioApiClient.Contacts.edit_contact_relation(
                 client,
                 ContactRelation.new(%{
                   id: 4,
                   contact_id: 2,
                   contact_sub_id: 3,
                   description: "CEO"
                 })
               )

      assert relation.id == 4
      assert relation.description == "CEO"
    end
  end

  describe "deleting a contact relation" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/contact_relation/4"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the contact relation" do
      client = BexioApiClient.new("123")
      assert {:ok, true} = BexioApiClient.Contacts.delete_contact_relation(client, 4)
    end
  end

  describe "creating a contact group" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact_group"} = conn ->
          {:ok, body, _} = read_body(conn)
          assert Jason.decode!(body) == %{"name" => "Suppliers"}

          json(conn, %{"id" => 1, "name" => "Suppliers"})
      end)

      :ok
    end

    test "creates the contact group" do
      client = BexioApiClient.new("123")

      assert {:ok, %{id: 1, name: "Suppliers"}} =
               BexioApiClient.Contacts.create_contact_group(client, "Suppliers")
    end
  end

  describe "editing a contact group" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact_group/1"} = conn ->
          {:ok, body, _} = read_body(conn)
          assert Jason.decode!(body) == %{"name" => "Suppliers"}

          json(conn, %{"id" => 1, "name" => "Suppliers"})
      end)

      :ok
    end

    test "edits the contact group" do
      client = BexioApiClient.new("123")

      assert {:ok, %{id: 1, name: "Suppliers"}} =
               BexioApiClient.Contacts.edit_contact_group(client, 1, "Suppliers")
    end
  end

  describe "deleting a contact group" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/contact_group/1"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the contact group" do
      client = BexioApiClient.new("123")
      assert {:ok, true} = BexioApiClient.Contacts.delete_contact_group(client, 1)
    end
  end

  describe "creating an additional address" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact/3/additional_address"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)

          assert body_json == %{
                   "name" => "My new address",
                   "name_addition" => "Name addition",
                   "street_name" => "Walter Street",
                   "house_number" => "22",
                   "address_addition" => "Building C",
                   "postcode" => "9000",
                   "city" => "St. Gallen",
                   "country_id" => 1,
                   "subject" => "Additional address",
                   "description" => "This is an internal description"
                 }

          json(conn, additional_address_response())
      end)

      :ok
    end

    test "creates the additional address" do
      client = BexioApiClient.new("123")

      assert {:ok, address} =
               BexioApiClient.Contacts.create_additional_address(
                 client,
                 3,
                 additional_address_to_create()
               )

      assert address.id == 1
      assert address.name == "My new address"
      assert address.name_addition == "Name addition"
      assert address.address == "Walter Street 22"
      assert address.street_name == "Walter Street"
      assert address.house_number == "22"
      assert address.address_addition == "Building C"
      assert address.postcode == "9000"
      assert address.city == "St. Gallen"
      assert address.country_id == 1
      assert address.subject == "Additional address"
      assert address.description == "This is an internal description"
    end
  end

  describe "editing an additional address" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/contact/3/additional_address/1"} = conn ->
          {:ok, body, _} = read_body(conn)
          body_json = Jason.decode!(body)
          assert body_json["name"] == "My new address"
          assert body_json["subject"] == "Additional address"

          json(conn, additional_address_response())
      end)

      :ok
    end

    test "edits the additional address" do
      client = BexioApiClient.new("123")
      address = AdditionalAddress.new(%{additional_address_to_create() | id: 1})

      assert {:ok, address} =
               BexioApiClient.Contacts.edit_additional_address(client, 3, address)

      assert address.id == 1
      assert address.name == "My new address"
    end
  end

  describe "deleting an additional address" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/contact/3/additional_address/1"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the additional address" do
      client = BexioApiClient.new("123")
      assert {:ok, true} = BexioApiClient.Contacts.delete_additional_address(client, 3, 1)
    end
  end

  defp additional_address_response do
    %{
      "id" => 1,
      "name" => "My new address",
      "name_addition" => "Name addition",
      "address" => "Walter Street 22",
      "street_name" => "Walter Street",
      "house_number" => "22",
      "address_addition" => "Building C",
      "postcode" => "9000",
      "city" => "St. Gallen",
      "country_id" => 1,
      "subject" => "Additional address",
      "description" => "This is an internal description"
    }
  end

  defp additional_address_to_create do
    AdditionalAddress.new(%{
      name: "My new address",
      name_addition: "Name addition",
      street_name: "Walter Street",
      house_number: "22",
      address_addition: "Building C",
      postcode: "9000",
      city: "St. Gallen",
      country_id: 1,
      subject: "Additional address",
      description: "This is an internal description"
    })
  end

  describe "creating a salutation" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/salutation"} = conn ->
          {:ok, body, _} = read_body(conn)
          assert Jason.decode!(body) == %{"name" => "Herr"}

          json(conn, %{"id" => 1, "name" => "Herr"})
      end)

      :ok
    end

    test "creates the salutation" do
      client = BexioApiClient.new("123")

      assert {:ok, %{id: 1, name: "Herr"}} =
               BexioApiClient.Contacts.create_salutation(client, "Herr")
    end
  end

  describe "editing a salutation" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/salutation/1"} = conn ->
          {:ok, body, _} = read_body(conn)
          assert Jason.decode!(body) == %{"name" => "Herr"}

          json(conn, %{"id" => 1, "name" => "Herr"})
      end)

      :ok
    end

    test "edits the salutation" do
      client = BexioApiClient.new("123")

      assert {:ok, %{id: 1, name: "Herr"}} =
               BexioApiClient.Contacts.edit_salutation(client, 1, "Herr")
    end
  end

  describe "deleting a salutation" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/salutation/1"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the salutation" do
      client = BexioApiClient.new("123")
      assert {:ok, true} = BexioApiClient.Contacts.delete_salutation(client, 1)
    end
  end

  describe "creating a title" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/title"} = conn ->
          {:ok, body, _} = read_body(conn)
          assert Jason.decode!(body) == %{"name" => "Dr."}

          json(conn, %{"id" => 1, "name" => "Dr."})
      end)

      :ok
    end

    test "creates the title" do
      client = BexioApiClient.new("123")

      assert {:ok, %{id: 1, name: "Dr."}} = BexioApiClient.Contacts.create_title(client, "Dr.")
    end
  end

  describe "editing a title" do
    setup do
      mock_request(fn
        %{method: "POST", request_path: "/2.0/title/1"} = conn ->
          {:ok, body, _} = read_body(conn)
          assert Jason.decode!(body) == %{"name" => "Dr."}

          json(conn, %{"id" => 1, "name" => "Dr."})
      end)

      :ok
    end

    test "edits the title" do
      client = BexioApiClient.new("123")
      assert {:ok, %{id: 1, name: "Dr."}} = BexioApiClient.Contacts.edit_title(client, 1, "Dr.")
    end
  end

  describe "deleting a title" do
    setup do
      mock_request(fn
        %{method: "DELETE", request_path: "/2.0/title/1"} = conn ->
          json(conn, %{"success" => true})
      end)

      :ok
    end

    test "deletes the title" do
      client = BexioApiClient.new("123")
      assert {:ok, true} = BexioApiClient.Contacts.delete_title(client, 1)
    end
  end
end
