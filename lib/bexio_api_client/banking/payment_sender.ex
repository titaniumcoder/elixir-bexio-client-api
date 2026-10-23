defmodule BexioApiClient.Banking.PaymentSender do
  @moduledoc """
  Sender (the paying bank account) of a bexio payment.
  """

  @typedoc """
  Sender of a payment.

  ## Fields:

    * `:id` - id of the sending bank account
    * `:uuid` - uuid of the sending bank account
    * `:iban` - IBAN of the sending bank account
  """
  @type t :: %__MODULE__{
          id: integer() | String.t() | nil,
          uuid: String.t() | nil,
          iban: String.t() | nil
        }
  defstruct [:id, :uuid, :iban]
end
