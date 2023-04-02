defmodule BexioApiClient.ContactsTest do
  use ExUnit.Case, async: true
  doctest BexioApiClient.Contacts

  alias BexioApiClient.SearchCriteria

  import Tesla.Mock

  describe "valid contact list" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/contact"} ->
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

    test "lists valid contacts" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:ok, [contact1, contact2]} = BexioApiClient.Contacts.fetch_contacts(client)
      assert contact1.id == 111
      assert contact1.nr == 998_776
      assert contact1.contact_type == :company
      assert contact1.name_1 == "Tester AG"
      assert contact1.name_2 == "Die Testing Firma"
      assert contact1.salutation_id == 0
      assert contact1.salutation_form == 1
      assert contact1.title_id == 2
      assert contact1.birthday == nil
      assert contact1.address == "Teststrasse 999"
      assert contact1.postcode == "9999"
      assert contact1.city == "Testcity"
      assert contact1.country_id == 3
      assert contact1.mail == "unknown@testing-ag.inv"
      assert contact1.mail_second == "unknown2@testing-ag.inv"
      assert contact1.phone_fixed == "099 999 99 99"
      assert contact1.phone_fixed_second == "088 888 88 88"
      assert contact1.phone_mobile == "077 777 77 77"
      assert contact1.fax == "066 666 66 66"
      assert contact1.url == "http://unbekannte.url"
      assert contact1.skype_name == "ich.bin.in.skype"
      assert contact1.remarks == "Lange schoene Bemerkungen"
      assert contact1.language_id == 4
      assert contact1.contact_group_ids == [2, 3, 22]
      assert contact1.contact_branch_ids == [3, 33, 99]
      assert contact1.updated_at == ~N[2022-09-13 09:14:21]

      assert contact2.id == 311
      assert contact2.nr == 103_370
      assert contact2.contact_type == :person
      assert contact2.name_1 == "Mueller"
      assert contact2.name_2 == nil
      assert contact2.salutation_id == nil
      assert contact2.salutation_form == nil
      assert contact2.title_id == nil
      assert contact2.birthday == ~D[1973-06-29]
      assert contact2.address == nil
      assert contact2.postcode == nil
      assert contact2.city == nil
      assert contact2.country_id == nil
      assert contact2.mail == nil
      assert contact2.mail_second == nil
      assert contact2.phone_fixed == nil
      assert contact2.phone_fixed_second == nil
      assert contact2.phone_mobile == nil
      assert contact2.fax == nil
      assert contact2.url == nil
      assert contact2.skype_name == nil
      assert contact2.remarks == nil
      assert contact2.language_id == nil
      assert contact2.contact_group_ids == []
      assert contact2.contact_branch_ids == []
      assert contact2.updated_at == ~N[2012-01-21 11:56:55]
    end
  end

  describe "search contacts" do
    setup do
      mock(fn
        %{method: :post, url: "https://api.bexio.com/2.0/contact/search", body: _body} ->
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

    test "lists contacts" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [contact1, contact2]} =
               BexioApiClient.Contacts.search_contacts(client, [
                 SearchCriteria.nil?(:name_2),
                 SearchCriteria.part_of(:name_1, ["fred", "queen"])
               ])

      assert contact1.id == 111
      assert contact1.nr == 998_776
      assert contact1.contact_type == :company
      assert contact1.name_1 == "Tester AG"
      assert contact1.name_2 == "Die Testing Firma"
      assert contact1.salutation_id == 0
      assert contact1.salutation_form == 1
      assert contact1.title_id == 2
      assert contact1.birthday == nil
      assert contact1.address == "Teststrasse 999"
      assert contact1.postcode == "9999"
      assert contact1.city == "Testcity"
      assert contact1.country_id == 3
      assert contact1.mail == "unknown@testing-ag.inv"
      assert contact1.mail_second == "unknown2@testing-ag.inv"
      assert contact1.phone_fixed == "099 999 99 99"
      assert contact1.phone_fixed_second == "088 888 88 88"
      assert contact1.phone_mobile == "077 777 77 77"
      assert contact1.fax == "066 666 66 66"
      assert contact1.url == "http://unbekannte.url"
      assert contact1.skype_name == "ich.bin.in.skype"
      assert contact1.remarks == "Lange schoene Bemerkungen"
      assert contact1.language_id == 4
      assert contact1.contact_group_ids == [2, 3, 22]
      assert contact1.contact_branch_ids == [3, 33, 99]
      assert contact1.updated_at == ~N[2022-09-13 09:14:21]

      assert contact2.id == 311
      assert contact2.nr == 103_370
      assert contact2.contact_type == :person
      assert contact2.name_1 == "Mueller"
      assert contact2.name_2 == nil
      assert contact2.salutation_id == nil
      assert contact2.salutation_form == nil
      assert contact2.title_id == nil
      assert contact2.birthday == ~D[1973-06-29]
      assert contact2.address == nil
      assert contact2.postcode == nil
      assert contact2.city == nil
      assert contact2.country_id == nil
      assert contact2.mail == nil
      assert contact2.mail_second == nil
      assert contact2.phone_fixed == nil
      assert contact2.phone_fixed_second == nil
      assert contact2.phone_mobile == nil
      assert contact2.fax == nil
      assert contact2.url == nil
      assert contact2.skype_name == nil
      assert contact2.remarks == nil
      assert contact2.language_id == nil
      assert contact2.contact_group_ids == []
      assert contact2.contact_branch_ids == []
      assert contact2.updated_at == ~N[2012-01-21 11:56:55]
    end
  end

  describe "single contact" do
    setup do
      mock(fn
        %{method: :get, url: "https://api.bexio.com/2.0/contact/33"} ->
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

        %{method: :get, url: "https://api.bexio.com/2.0/contact/99"} ->
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "fetches a single valid contact" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:ok, contact} = BexioApiClient.Contacts.fetch_contact(client, 33)
      assert contact.id == 33
      assert contact.nr == 998_776
      assert contact.contact_type == :company
      assert contact.name_1 == "Tester AG"
      assert contact.name_2 == "Die Testing Firma"
      assert contact.salutation_id == 0
      assert contact.salutation_form == 1
      assert contact.title_id == 2
      assert contact.birthday == nil
      assert contact.address == "Teststrasse 999"
      assert contact.postcode == "9999"
      assert contact.city == "Testcity"
      assert contact.country_id == 3
      assert contact.mail == "unknown@testing-ag.inv"
      assert contact.mail_second == "unknown2@testing-ag.inv"
      assert contact.phone_fixed == "099 999 99 99"
      assert contact.phone_fixed_second == "088 888 88 88"
      assert contact.phone_mobile == "077 777 77 77"
      assert contact.fax == "066 666 66 66"
      assert contact.url == "http://unbekannte.url"
      assert contact.skype_name == "ich.bin.in.skype"
      assert contact.remarks == "Lange schoene Bemerkungen"
      assert contact.language_id == 4
      assert contact.contact_group_ids == [2, 3, 22]
      assert contact.contact_branch_ids == [3, 33, 99]
      assert contact.updated_at == ~N[2022-09-13 09:14:21]
    end

    test "fetches an unknown contact" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:error, :not_found} = BexioApiClient.Contacts.fetch_contact(client, 99)
    end
  end

  describe "valid contact relation list" do
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

    test "lists valid contact relations" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [contact_relation1, contact_relation2]} =
               BexioApiClient.Contacts.fetch_contact_relations(client)

      assert contact_relation1.id == 111
      assert contact_relation1.contact_id == 1
      assert contact_relation1.contact_sub_id == 2
      assert contact_relation1.description == "Description 1"
      assert contact_relation1.updated_at == ~N[2022-09-13 09:14:21]

      assert contact_relation2.id == 222
      assert contact_relation2.contact_id == 3
      assert contact_relation2.contact_sub_id == 4
      assert contact_relation2.description == "Description 2"
      assert contact_relation2.updated_at == ~N[2023-09-13 09:14:21]
    end
  end

  describe "search contact relations" do
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

    test "lists contact relations" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)

      assert {:ok, [contact_relation1, contact_relation2]} =
               BexioApiClient.Contacts.search_contact_relations(client, [
                 SearchCriteria.nil?(:name_2),
                 SearchCriteria.part_of(:name_1, ["fred", "queen"])
               ])

      assert contact_relation1.id == 111
      assert contact_relation1.contact_id == 1
      assert contact_relation1.contact_sub_id == 2
      assert contact_relation1.description == "Description 1"
      assert contact_relation1.updated_at == ~N[2022-09-13 09:14:21]

      assert contact_relation2.id == 222
      assert contact_relation2.contact_id == 3
      assert contact_relation2.contact_sub_id == 4
      assert contact_relation2.description == "Description 2"
      assert contact_relation2.updated_at == ~N[2023-09-13 09:14:21]
    end
  end

  describe "single contact relation" do
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
          %Tesla.Env{status: 404, body: "Contact does not exist"}
      end)

      :ok
    end

    test "fetches a single valid contact relation" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:ok, contact_relation} = BexioApiClient.Contacts.fetch_contact_relation(client, 111)
      assert contact_relation.id == 111
      assert contact_relation.contact_id == 1
      assert contact_relation.contact_sub_id == 2
      assert contact_relation.description == "Description 1"
      assert contact_relation.updated_at == ~N[2022-09-13 09:14:21]
    end

    test "fetches an unknown contact relation" do
      client = BexioApiClient.new("123", adapter: Tesla.Mock)
      assert {:error, :not_found} = BexioApiClient.Contacts.fetch_contact_relation(client, 99)
    end
  end
end
