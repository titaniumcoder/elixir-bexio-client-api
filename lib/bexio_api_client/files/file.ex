defmodule BexioApiClient.Files.File do
  @moduledoc """
  Bexio File Module.
  """

  @typedoc """
  Bexio File
  """
  @type t :: %__MODULE__{
          id: integer(),
          uuid: String.t(),
          name: String.t(),
          size_in_bytes: non_neg_integer(),
          extension: :atom,
          mime_type: String.t(),
          uploader_email: String.t() | nil,
          user_id: integer(),
          archived?: boolean(),
          source_type: :web | :email | :mobile | nil,
          referenced?: boolean(),
          created_at: DateTime.t()
        }
  @enforce_keys [
    :id,
    :uuid,
    :name,
    :size_in_bytes,
    :extension,
    :mime_type,
    :user_id,
    :archived?,
    :referenced?,
    :created_at
  ]
  defstruct [
    :id,
    :uuid,
    :name,
    :size_in_bytes,
    :extension,
    :mime_type,
    :uploader_email,
    :user_id,
    :archived?,
    :source_type,
    :referenced?,
    :created_at
  ]
end
