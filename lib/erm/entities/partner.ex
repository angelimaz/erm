defmodule Erm.Entities.Partner do
  use Ecto.Schema
  import Ecto.Changeset
  alias Erm.Entities.Partner

  embedded_schema do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :password_confirmation, :string
  end

  @doc false
  def changeset(%Partner{} = partner, attrs) do
    partner
    |> cast(attrs, [:first_name, :last_name, :email, :password, :password_confirmation])
    |> validate_required([:first_name, :last_name, :email, :password, :password_confirmation])
    |> validate_confirmation(:password)
  end
end
