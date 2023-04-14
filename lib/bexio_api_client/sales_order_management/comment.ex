defmodule BexioApiClient.SalesOrderManagement.Comment do
  @moduledoc """
  Comment
  """

  @typedoc """
  Comment

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:text` - text
    * `:user_id` - references a user object
    * `:user_email` - email
    * `:user_name` - user name
    * `:date` - date and time of the comment
    * `:public?` - if the comment is public viewable
    * `:image` - base64 encoded image file content
    * `:image_path` - path of the image

  """
  @type t :: %__MODULE__{
          id: integer(),
          text: String.t(),
          user_id: integer() | nil,
          user_email: String.t() | nil,
          user_name: String.t() | nil,
          date: NaiveDateTime.t(),
          public?: boolean(),
          image: String.t() | nil,
          image_path: String.t() | nil
        }
  @enforce_keys [
    :id,
    :text,
    :date,
    :public?
  ]
  defstruct [
    :id,
    :text,
    :user_id,
    :user_email,
    :user_name,
    :date,
    :public?,
    :image,
    :image_path
  ]
end
