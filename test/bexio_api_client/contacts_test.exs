defmodule BexioApiClient.ContactsTest do
  use ExUnit.Case, async: true
  doctest BexioApiClient.Contacts

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
      client = BexioApiClient.create_client("123", adapter: Tesla.Mock)
      assert {:ok, [contact1, contact2]} = BexioApiClient.Contacts.fetch_contacts(client)
      assert contact1.id == 111
      assert contact1.nr == "998776"
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
      assert contact1.updated_at == ~U[2022-09-13 07:14:21Z]

      assert contact2.id == 311
      assert contact2.nr == "103370"
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
      assert contact2.updated_at == ~U[2012-01-21 10:56:55Z]
    end
  end
end
