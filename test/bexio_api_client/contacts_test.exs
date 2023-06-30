defmodule BexioApiClient.ContactsTest do
  use ExUnit.Case, async: true
  doctest BexioApiClient.Contacts

  alias BexioApiClient.SearchCriteria

  import Tesla.Mock

  describe "fetching a list of contacts" do
    setup do
      mock(fn
        %{
          method: :get,
          url: "https://api.bexio.com/2.0/contact",
          query: [show_archived: true, limit: 100, offset: 50, order_by: :id]
        } ->
          json([
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
              "language_id" => nil,
              "is_lead" => false,
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/contact/search",
          body: _body,
          query: [show_archived: true, limit: 100, offset: 50, order_by: :id]
        } ->
          json([
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
              "language_id" => nil,
              "is_lead" => false,
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/contact/33", query: [show_archived: true]} ->
          json(%{
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

        %{method: :get, url: "https://api.bexio.com/2.0/contact/33", query: [show_archived: nil]} ->
          json(%{
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

        %{method: :get, url: "https://api.bexio.com/2.0/contact/99"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:ok, result} = BexioApiClient.Contacts.fetch_contact(client, 33, true)
      assert result.id == 33
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found, "Contact does not exist"} =
               BexioApiClient.Contacts.fetch_contact(client, 99)
    end
  end

  describe "fetching a list of contact relations" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/contact_relation"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/contact_relation/search", body: _body} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/contact_relation/111"} ->
          json(%{
            "id" => 111,
            "contact_id" => 1,
            "contact_sub_id" => 2,
            "description" => "Description 1",
            "updated_at" => "2022-09-13 09:14:21"
          })

        %{method: :get, url: "https://api.bexio.com/2.0/contact_relation/99"} ->
          %Tesla.Env{status: 404, body: "Contact Relation does not exist"}
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:ok, result} = BexioApiClient.Contacts.fetch_contact_relation(client, 111)
      assert result.id == 111
      assert result.contact_id == 1
      assert result.contact_sub_id == 2
      assert result.description == "Description 1"
      assert result.updated_at == ~N[2022-09-13 09:14:21]
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found, "Contact Relation does not exist"} =
               BexioApiClient.Contacts.fetch_contact_relation(client, 99)
    end
  end

  describe "fetching a list of contact groups" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/contact_group"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, result} = BexioApiClient.Contacts.fetch_contact_groups(client)

      assert result[111] == "Contact Group 1"
      assert result[222] == "Contact Group 2"
    end
  end

  describe "searching contact groups" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/contact_group/search", body: _body} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/contact_group/111"} ->
          json(%{
            "id" => 111,
            "name" => "Contact Group 1"
          })

        %{method: :get, url: "https://api.bexio.com/2.0/contact_group/99"} ->
          %Tesla.Env{status: 404, body: "Contact group does not exist"}
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:ok, result} = BexioApiClient.Contacts.fetch_contact_group(client, 111)
      assert result.id == 111
      assert result.name == "Contact Group 1"
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found, "Contact group does not exist"} =
               BexioApiClient.Contacts.fetch_contact_group(client, 99)
    end
  end

  describe "fetching a list of contact sectors" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/contact_branch"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, result} = BexioApiClient.Contacts.fetch_contact_sectors(client)

      assert result[111] == "Contact Sector 1"
      assert result[222] == "Contact Sector 2"
    end
  end

  describe "searching contact sectors" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/contact_branch/search", body: _body} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/contact/3/additional_address"} ->
          json([
            %{
              "id" => 1,
              "name" => "My new address",
              "address" => "Walter Street 22",
              "postcode" => 9000,
              "city" => "St. Gallen",
              "country_id" => 1,
              "subject" => "Additional address",
              "description" => "This is an internal description"
            },
            %{
              "id" => 2,
              "name" => "My new address",
              "address" => "Walter Street 22",
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/contact/3/additional_address/search",
          body: _body
        } ->
          json([
            %{
              "id" => 1,
              "name" => "My new address",
              "address" => "Walter Street 22",
              "postcode" => 9000,
              "city" => "St. Gallen",
              "country_id" => 1,
              "subject" => "Additional address",
              "description" => "This is an internal description"
            },
            %{
              "id" => 2,
              "name" => "My new address",
              "address" => "Walter Street 22",
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/contact/3/additional_address/1"} ->
          json(%{
            "id" => 1,
            "name" => "My new address",
            "address" => "Walter Street 22",
            "postcode" => 9000,
            "city" => "St. Gallen",
            "country_id" => 1,
            "subject" => "Additional address",
            "description" => "This is an internal description"
          })

        %{method: :get, url: "https://api.bexio.com/2.0/contact/3/additional_address/3"} ->
          %Tesla.Env{status: 404, body: "Additional Address does not exist"}
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found, "Additional Address does not exist"} =
               BexioApiClient.Contacts.fetch_additional_address(client, 3, 3)
    end
  end

  describe "fetching a list of salutations" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/salutation"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, result} = BexioApiClient.Contacts.fetch_salutations(client)

      assert result[1] == "Herr"
      assert result[2] == "Frau"
    end
  end

  describe "searching salutations" do
    setup do
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/salutation/search",
          body: _body
        } ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/salutation/1"} ->
          json(%{
            "id" => 1,
            "name" => "Herr"
          })

        %{method: :get, url: "https://api.bexio.com/2.0/salutation/2"} ->
          %Tesla.Env{status: 404, body: "Salutation does not exist"}
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:ok, result} = BexioApiClient.Contacts.fetch_salutation(client, 1)
      assert result.id == 1
      assert result.name == "Herr"
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found, "Salutation does not exist"} =
               BexioApiClient.Contacts.fetch_salutation(client, 2)
    end
  end

  describe "fetching a list of titles" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/title"} ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, result} = BexioApiClient.Contacts.fetch_titles(client)

      assert result[1] == "Dr."
      assert result[2] == "Prof."
    end
  end

  describe "searching titles" do
    setup do
      mock(fn
        %{
          method: :post,
          url: "https://api.bexio.com/2.0/title/search",
          body: _body
        } ->
          json([
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
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

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
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/title/1"} ->
          json(%{
            "id" => 1,
            "name" => "Dr."
          })

        %{method: :get, url: "https://api.bexio.com/2.0/title/2"} ->
          %Tesla.Env{status: 404, body: "Contact group does not exist"}
      end)

      :ok
    end

    test "shows valid result" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:ok, result} = BexioApiClient.Contacts.fetch_title(client, 1)
      assert result.id == 1
      assert result.name == "Dr."
    end

    test "fails on unknown id" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:error, :not_found, "Contact group does not exist"} =
               BexioApiClient.Contacts.fetch_title(client, 2)
    end
  end
end
