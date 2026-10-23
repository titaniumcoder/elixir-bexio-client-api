defmodule BexioApiClient.Accounting.ManualEntryFile do
  @moduledoc """
  Bexio Manual Entry File Module.

  A file attached to a manual entry (or to a single manual entry line).
  Same shape as `BexioApiClient.Files.File`, but the show responses of the
  manual entry file endpoints additionally contain the base64 encoded content.
  """

  @typedoc """
  Bexio Manual Entry File

  ## Fields:

    * `:id` - automatic id given by bexio
    * `:uuid` - the uuid of the file
    * `:name` - the name of the file
    * `:size_in_bytes` - the size of the file in bytes
    * `:extension` - the file extension
    * `:mime_type` - the mime type of the file
    * `:uploader_email` - email of the uploader (if available)
    * `:user_id` - the id of the uploading user
    * `:archived?` - whether the file is archived
    * `:source_type` - how the file was uploaded (`:web`, `:email` or `:mobile`)
    * `:source_id` - deprecated by bexio in favor of `:source_type`
    * `:referenced?` - whether the file is referenced
    * `:created_at` - creation date of the file
    * `:data` - base64 encoded file content (only part of the show responses)
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
          source_id: integer() | nil,
          referenced?: boolean(),
          created_at: DateTime.t(),
          data: String.t() | nil
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
    # deprecated by bexio in favor of `:source_type`
    :source_id,
    :referenced?,
    :created_at,
    :data
  ]
end
