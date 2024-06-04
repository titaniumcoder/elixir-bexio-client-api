defmodule BexioApiClient.Others do
  @moduledoc """
  Bexio API for the other endpoints.
  """

  import BexioApiClient.Helpers
  alias BexioApiClient.SearchCriteria

  alias BexioApiClient.Others.{
    CompanyProfile,
    Country,
    Language,
    Permission,
    Todo,
    User,
    FictionalUser,
    Note
  }

  alias BexioApiClient.GlobalArguments
  import BexioApiClient.GlobalArguments, only: [opts_to_query: 1]

  @type api_error_type :: BexioApiClient.Helpers.api_error_type()

  @doc """
  Fetch a list of company profiles.
  """
  @spec fetch_company_profiles(req :: Req.Request.t()) ::
          {:ok, [CompanyProfile.t()]} | api_error_type()
  def fetch_company_profiles(req) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/company_profile")
      end,
      &map_from_company_profiles/2
    )
  end

  @doc """
  Fetch a single company profile
  """
  @spec fetch_company_profile(req :: Req.Request.t(), id :: non_neg_integer()) ::
          {:ok, CompanyProfile.t()} | api_error_type()
  def fetch_company_profile(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/company_profile/#{id}")
      end,
      &map_from_company_profile/2
    )
  end

  defp map_from_company_profiles(company_profiles, _env),
    do: Enum.map(company_profiles, &map_from_company_profile/1)

  defp map_from_company_profile(
         %{
           "id" => id,
           "name" => name,
           "address" => address,
           "address_nr" => address_nr,
           "postcode" => postcode,
           "city" => city,
           "country_id" => country_id,
           "legal_form" => legal_form,
           "country_name" => country_name,
           "mail" => mail,
           "phone_fixed" => phone_fixed,
           "phone_mobile" => phone_mobile,
           "fax" => fax,
           "url" => url,
           "skype_name" => skype_name,
           "facebook_name" => facebook_name,
           "twitter_name" => twitter_name,
           "description" => description,
           "ust_id_nr" => ust_id_nr,
           "mwst_nr" => mwst_nr,
           "trade_register_nr" => trade_register_nr,
           "has_own_logo" => own_logo?,
           "is_public_profile" => public_profile?,
           "is_logo_public" => logo_public?,
           "is_address_public" => address_public?,
           "is_phone_public" => phone_public?,
           "is_mobile_public" => mobile_public?,
           "is_fax_public" => fax_public?,
           "is_mail_public" => mail_public?,
           "is_url_public" => url_public?,
           "is_skype_public" => skype_public?,
           "logo_base64" => logo_base64
         },
         _env \\ nil
       ) do
    %CompanyProfile{
      id: id,
      name: name,
      address: address,
      address_nr: address_nr,
      postcode: postcode,
      city: city,
      country_id: country_id,
      legal_form: String.to_atom(legal_form),
      country_name: country_name,
      mail: mail,
      phone_fixed: phone_fixed,
      phone_mobile: phone_mobile,
      fax: fax,
      url: url,
      skype_name: skype_name,
      facebook_name: facebook_name,
      twitter_name: twitter_name,
      description: description,
      ust_id_nr: ust_id_nr,
      mwst_nr: mwst_nr,
      trade_register_nr: trade_register_nr,
      own_logo?: own_logo?,
      public_profile?: public_profile?,
      logo_public?: logo_public?,
      address_public?: address_public?,
      phone_public?: phone_public?,
      mobile_public?: mobile_public?,
      fax_public?: fax_public?,
      mail_public?: mail_public?,
      url_public?: url_public?,
      skype_public?: skype_public?,
      logo_base64: logo_base64
    }
  end

  @doc """
  Fetch a list of countries.
  """
  @spec fetch_countries(req :: Req.Request.t()) ::
          {:ok, [Country.t()]} | api_error_type()
  def fetch_countries(req) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/country")
      end,
      &map_from_countries/2
    )
  end

  @doc """
  Search countries via query.
  The following search fields are supported:

  * name
  * name_short
  """
  @spec search_countries(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Country.t()]} | api_error_type()
  def search_countries(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/country/search", json: criteria, params: opts_to_query(opts))
      end,
      &map_from_countries/2
    )
  end

  @doc """
  Fetch a single country
  """
  @spec fetch_country(req :: Req.Request.t(), id :: non_neg_integer()) ::
          {:ok, Country.t()} | api_error_type()
  def fetch_country(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/country/#{id}")
      end,
      &map_from_country/2
    )
  end

  defp map_from_countries(countries, _env), do: Enum.map(countries, &map_from_country/1)

  defp map_from_country(
         %{
           "id" => id,
           "name" => name,
           "name_short" => name_short,
           "iso_3166_alpha2" => iso_3166_alpha2
         },
         _env \\ nil
       ) do
    %Country{
      id: id,
      name: name,
      name_short: name_short,
      iso_3166_alpha2: iso_3166_alpha2
    }
  end

  @doc """
  Fetch a list of languages.
  """
  @spec fetch_languages(req :: Req.Request.t()) ::
          {:ok, [Language.t()]} | api_error_type()
  def fetch_languages(req) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/language")
      end,
      &map_from_languages/2
    )
  end

  @doc """
  Search languages via query.
  The following search fields are supported:

  * name
  * iso_639_1
  """
  @spec search_languages(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Language.t()]} | api_error_type()
  def search_languages(
        req,
        criteria,
        opts \\ []
      ) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/language/search", json: criteria, params: opts_to_query(opts))
      end,
      &map_from_languages/2
    )
  end

  defp map_from_languages(languages, _env), do: Enum.map(languages, &map_from_language/1)

  defp map_from_language(
         %{
           "id" => id,
           "name" => name,
           "decimal_point" => decimal_point,
           "thousands_separator" => thousands_separator,
           "date_format_id" => date_format_id_bexio,
           "date_format" => date_format,
           "iso_639_1" => iso_639_1
         },
         _env \\ nil
       ) do
    %Language{
      id: id,
      name: name,
      decimal_point: decimal_point,
      thousands_separator: thousands_separator,
      date_format: date_format,
      date_format_id: date_format_id(date_format_id_bexio),
      iso_639_1: iso_639_1
    }
  end

  defp date_format_id(1), do: :dmy
  defp date_format_id(2), do: :mdy

  @doc """
  Fetch a list of users.
  """
  @spec fetch_users(req :: Req.Request.t()) ::
          {:ok, [User.t()]} | api_error_type()
  def fetch_users(req) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/users")
      end,
      &map_from_users/2
    )
  end

  @doc """
  Fetch a single user.
  """
  @spec fetch_user(req :: Req.Request.t(), user_id :: non_neg_integer()) ::
          {:ok, User.t()} | api_error_type()
  def fetch_user(req, user_id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/users/#{user_id}")
      end,
      &map_from_user/2
    )
  end

  @doc """
  Fetch a list of fictional users.
  """
  @spec fetch_fictional_users(req :: Req.Request.t()) ::
          {:ok, [FictionalUser.t()]} | api_error_type()
  def fetch_fictional_users(req) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/fictional_users")
      end,
      &map_from_fictional_users/2
    )
  end

  @doc """
  Fetch a fictional user.
  """
  @spec fetch_fictional_user(req :: Req.Request.t(), id :: integer()) ::
          {:ok, FictionalUser.t()} | api_error_type()
  def fetch_fictional_user(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/fictional_users/#{id}")
      end,
      &map_from_fictional_user/2
    )
  end

  @doc """
  Create a fictional user, the id of the fictional user will be ignored!
  """
  @spec create_fictional_user(req :: Req.Request.t(), finctional_user :: FictionalUser.t()) ::
          {:ok, FictionalUser.t()} | api_error_type()
  def create_fictional_user(req, fictional_user) do
    bexio_body_handling(
      fn ->
        Req.post(
          req,
          url: "/3.0/fictional_users",
          json:
            Map.take(fictional_user, [:salutation_type, :firstname, :lastname, :email, :title_id])
        )
      end,
      &map_from_fictional_user/2
    )
  end

  @doc """
  Create a fictional user
  """
  @spec update_fictional_user(req :: Req.Request.t(), fictional_user :: FictionalUser.t()) ::
          {:ok, FictionalUser.t()} | api_error_type()
  def update_fictional_user(req, fictional_user) do
    bexio_body_handling(
      fn ->
        Req.patch(
          req,
          url: "/3.0/fictional_users/#{fictional_user.id}",
          json:
            Map.take(fictional_user, [:salutation_type, :firstname, :lastname, :email, :title_id])
        )
      end,
      &map_from_fictional_user/2
    )
  end

  @doc """
  Create a fictional user
  """
  @spec delete_fictional_user(req :: Req.Request.t(), id :: integer()) ::
          {:ok, true | false} | api_error_type()
  def delete_fictional_user(req, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/3.0/fictional_users/#{id}")
      end,
      &success_response/2
    )
  end

  defp map_from_users(users, _env), do: Enum.map(users, &map_from_user/1)

  defp map_from_user(
         %{
           "id" => id,
           "salutation_type" => salutation_type,
           "firstname" => firstname,
           "lastname" => lastname,
           "email" => email,
           "is_superadmin" => superadmin?,
           "is_accountant" => accountant?
         },
         _env \\ nil
       ) do
    %User{
      id: id,
      salutation_type: String.to_atom(salutation_type),
      firstname: firstname,
      lastname: lastname,
      email: email,
      superadmin?: superadmin?,
      accountant?: accountant?
    }
  end

  defp map_from_fictional_users(fictional_users, _env),
    do: Enum.map(fictional_users, &map_from_fictional_user/1)

  defp map_from_fictional_user(
         %{
           "id" => id,
           "salutation_type" => salutation_type,
           "firstname" => firstname,
           "lastname" => lastname,
           "email" => email,
           "title_id" => title_id
         },
         _env \\ nil
       ) do
    %FictionalUser{
      id: id,
      salutation_type: String.to_atom(salutation_type),
      firstname: firstname,
      lastname: lastname,
      email: email,
      title_id: title_id
    }
  end

  @doc """
  Get access information of logged in user
  """
  @spec get_access_information(req :: Req.Request.t()) ::
          {:ok, Permission.t()} | api_error_type()
  def get_access_information(req) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/3.0/permissions")
      end,
      &map_from_permission_response/2
    )
  end

  defp map_from_permission_response(
         %{"components" => components, "permissions" => permissions},
         _env
       ) do
    %Permission{
      components: components,
      permissions: permissions |> Enum.map(&map_permission/1) |> Enum.into(%{})
    }
  end

  defp map_permission({k, properties}) do
    map_part(String.to_atom(k), properties, %{})
  end

  defp map_part(k, %{"activation" => activation} = map, acc) do
    map_part(k, Map.delete(map, "activation"), Map.put(acc, :activation, enabled(activation)))
  end

  defp map_part(k, %{"edit" => edit} = map, acc) do
    map_part(k, Map.delete(map, "edit"), Map.put(acc, :edit, restriction(edit)))
  end

  defp map_part(k, %{"view" => view} = map, acc) do
    map_part(k, Map.delete(map, "view"), Map.put(acc, :view, restriction(view)))
  end

  defp map_part(k, %{"show" => show} = map, acc) do
    map_part(k, Map.delete(map, "show"), Map.put(acc, :show, restriction(show)))
  end

  defp map_part(k, %{}, acc), do: {k, acc}

  def enabled("disabled"), do: :disabled
  def enabled("enabled"), do: :enabled

  def restriction("none"), do: :none
  def restriction("all"), do: :all
  def restriction("own"), do: :own

  @doc """
  Fetch a list of tasks.
  """
  @spec fetch_tasks(req :: Req.Request.t(), opts :: [GlobalArguments.offset_arg()]) ::
          {:ok, [Task.t()]} | api_error_type()
  def fetch_tasks(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/task", params: opts_to_query(opts))
      end,
      &map_from_tasks/2
    )
  end

  @doc """
  Search a task

  Following fields are supported:

  * `subject`
  * `updated_at`
  * `user_id`
  * `contact_id`
  * `todo_status_id`
  * `module_id`
  * `entry_id`
  """
  @spec search_tasks(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Task.t()]} | api_error_type()
  def search_tasks(req, criteria, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/task/search", json: criteria, params: opts_to_query(opts))
      end,
      &map_from_tasks/2
    )
  end

  @doc """
  Fetch a  task.
  """
  @spec fetch_task(req :: Req.Request.t(), id :: integer()) ::
          {:ok, Task.t()} | api_error_type()
  def fetch_task(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/task/#{id}")
      end,
      &map_from_task/2
    )
  end

  @doc """
  Create a  task.
  """
  @spec create_task(req :: Req.Request.t(), task :: Task.t()) ::
          {:ok, Task.t()} | api_error_type()
  def create_task(req, task) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/task", json: remap_task(task))
      end,
      &map_from_task/2
    )
  end

  @doc """
  Edut a  task.
  """
  @spec edit_task(req :: Req.Request.t(), task :: Task.t()) ::
          {:ok, Task.t()} | api_error_type()
  def edit_task(req, task) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/task/#{task.id}", json: remap_task(task))
      end,
      &map_from_task/2
    )
  end

  @doc """
  Delete a  task.
  """
  @spec delete_task(req :: Req.Request.t(), id :: integer()) ::
          {:ok, Task.t()} | api_error_type()
  def delete_task(req, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/task/#{id}")
      end,
      &success_response/2
    )
  end

  defp remap_task(task) do
    task
    |> Map.take([
      :user_id,
      :subject,
      :info,
      :contact_id,
      :sub_contact_id,
      :entry_id,
      :module_id,
      :todo_status_id,
      :todo_priority_id,
      :remember_type_id,
      :remember_time_id,
      :communication_kind_id
    ])
    |> Map.put(:finish_date, to_iso8601(Map.get(task, :finish_date)))
    |> Map.put(:have_remember, Map.get(task, :reminder?))
    |> Map.put(:pr_project_id, Map.get(task, :project_id))
  end

  defp map_from_tasks(tasks, _env), do: Enum.map(tasks, &map_from_task/1)

  defp map_from_task(
         %{
           "id" => id,
           "user_id" => user_id,
           "finish_date" => finish_date,
           "subject" => subject,
           "place" => place,
           "info" => info,
           "contact_id" => contact_id,
           "sub_contact_id" => sub_contact_id,
           "project_id" => project_id,
           "entry_id" => entry_id,
           "module_id" => module_id,
           "todo_status_id" => todo_status_id,
           "todo_priority_id" => todo_priority_id,
           "has_reminder" => reminder?,
           "remember_type_id" => remember_type_id,
           "remember_time_id" => remember_time_id,
           "communication_kind_id" => communication_kind_id
         },
         _env \\ nil
       ) do
    %Todo{
      id: id,
      user_id: user_id,
      finish_date: to_datetime(finish_date),
      subject: subject,
      place: place,
      info: info,
      contact_id: contact_id,
      sub_contact_id: sub_contact_id,
      project_id: project_id,
      entry_id: entry_id,
      module_id: module_id,
      todo_status_id: todo_status_id,
      todo_priority_id: todo_priority_id,
      reminder?: to_boolean(reminder?),
      remember_time_id: remember_time_id,
      remember_type_id: remember_type_id,
      communication_kind_id: communication_kind_id
    }
  end

  defp to_boolean(b) when is_boolean(b), do: b
  defp to_boolean("true"), do: true
  defp to_boolean("false"), do: false

  @doc """
  Fetch a list of task priorities.
  """
  @spec fetch_task_priorities(req :: Req.Request.t(), opts :: [GlobalArguments.offset_arg()]) ::
          {:ok, map()} | api_error_type()
  def fetch_task_priorities(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/todo_priority", params: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  Fetch a list of task status.
  """
  @spec fetch_task_status(req :: Req.Request.t(), opts :: [GlobalArguments.offset_arg()]) ::
          {:ok, map()} | api_error_type()
  def fetch_task_status(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/todo_status", params: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  Fetch a list of notes.
  """
  @spec fetch_notes(req :: Req.Request.t(), opts :: [GlobalArguments.offset_arg()]) ::
          {:ok, [Note.t()]} | api_error_type()
  def fetch_notes(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/note", params: opts_to_query(opts))
      end,
      &map_from_notes/2
    )
  end

  @doc """
  Search a note

  Following fields are supported:

  * `event_start`
  * `contact_id`
  * `user_id`
  * `subject`
  * `module_id`
  * `entry_id`
  """
  @spec search_notes(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, [Note.t()]} | api_error_type()
  def search_notes(req, criteria, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/note/search", json: criteria, params: opts_to_query(opts))
      end,
      &map_from_notes/2
    )
  end

  @doc """
  Fetch a  note.
  """
  @spec fetch_note(req :: Req.Request.t(), id :: integer()) ::
          {:ok, Note.t()} | api_error_type()
  def fetch_note(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/note/#{id}")
      end,
      &map_from_note/2
    )
  end

  @doc """
  Create a  note.
  """
  @spec create_note(req :: Req.Request.t(), note :: Note.t()) ::
          {:ok, Task.t()} | api_error_type()
  def create_note(req, note) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/note", json: remap_note(note))
      end,
      &map_from_note/2
    )
  end

  @doc """
  Edit a  note.
  """
  @spec edit_note(req :: Req.Request.t(), note :: Note.t()) ::
          {:ok, Note.t()} | api_error_type()
  def edit_note(req, note) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/note/#{note.id}", json: remap_note(note))
      end,
      &map_from_note/2
    )
  end

  @doc """
  Delete a  note.
  """
  @spec delete_note(req :: Req.Request.t(), id :: integer()) ::
          {:ok, boolean()} | api_error_type()
  def delete_note(req, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/note/#{id}")
      end,
      &success_response/2
    )
  end

  defp remap_note(note) do
    note
    |> Map.take([
      :user_id,
      :subject,
      :info,
      :contact_id,
      :entry_id,
      :module_id,
      :event_start
    ])
    |> Map.put(:event_start, to_iso8601(Map.get(note, :event_start)))
    |> Map.put(:pr_project_id, Map.get(note, :project_id))
  end

  defp map_from_notes(notes, _env), do: Enum.map(notes, &map_from_note/1)

  defp map_from_note(
         %{
           "id" => id,
           "user_id" => user_id,
           "event_start" => event_start,
           "subject" => subject,
           "info" => info,
           "contact_id" => contact_id,
           "project_id" => project_id,
           "entry_id" => entry_id,
           "module_id" => module_id
         },
         _env \\ nil
       ) do
    %Note{
      id: id,
      user_id: user_id,
      event_start: to_datetime(event_start),
      subject: subject,
      info: info,
      contact_id: contact_id,
      project_id: project_id,
      entry_id: entry_id,
      module_id: module_id
    }
  end

  @doc """
  Fetch a list of units.
  """
  @spec fetch_units(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, map()} | api_error_type()
  def fetch_units(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/unit", params: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  Search a unit

  Following fields are supported:

  * `name`
  """
  @spec search_units(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, map()} | api_error_type()
  def search_units(req, criteria, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/unit/search", json: criteria, params: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  Fetch a unit.
  """
  @spec fetch_unit(req :: Req.Request.t(), id :: integer()) ::
          {:ok, %{id: integer(), name: String.t()}} | api_error_type()
  def fetch_unit(req, id) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/unit/#{id}")
      end,
      &id_name/2
    )
  end

  @doc """
  Create a unit.
  """
  @spec create_unit(req :: Req.Request.t(), name :: String.t()) ::
          {:ok, %{id: integer(), name: String.t()}} | api_error_type()
  def create_unit(req, name) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/unit", json: %{name: name})
      end,
      &id_name/2
    )
  end

  @doc """
  Edit a unit.
  """
  @spec edit_unit(req :: Req.Request.t(), id :: integer(), name :: String.t()) ::
          {:ok, %{id: integer(), name: String.t()}} | api_error_type()
  def edit_unit(req, id, name) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/unit/#{id}", json: %{name: name})
      end,
      &id_name/2
    )
  end

  @doc """
  Delete a unit.
  """
  @spec delete_unit(req :: Req.Request.t(), id :: integer()) ::
          {:ok, Task.t()} | api_error_type()
  def delete_unit(req, id) do
    bexio_body_handling(
      fn ->
        Req.delete(req, url: "/2.0/unit/#{id}")
      end,
      &success_response/2
    )
  end

  @doc """
  Fetch a list of payment types.
  """
  @spec fetch_payment_types(
          req :: Req.Request.t(),
          opts :: [GlobalArguments.offset_without_order_by_arg()]
        ) :: {:ok, map()} | api_error_type()
  def fetch_payment_types(req, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.get(req, url: "/2.0/payment_type", params: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

  @doc """
  Search a payment type

  Following fields are supported:

  * `name`
  """
  @spec search_payment_types(
          req :: Req.Request.t(),
          criteria :: list(SearchCriteria.t()),
          opts :: [GlobalArguments.offset_arg()]
        ) :: {:ok, map()} | api_error_type()
  def search_payment_types(req, criteria, opts \\ []) do
    bexio_body_handling(
      fn ->
        Req.post(req, url: "/2.0/payment_type/search", json: criteria, params: opts_to_query(opts))
      end,
      &body_to_map/2
    )
  end

end
