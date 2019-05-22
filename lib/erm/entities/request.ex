defmodule Erm.Entities.Request do
  use Ecto.Schema
  import Ecto.Changeset
  alias Erm.Entities.Request
  #alias Erm.Entities.Entity

  embedded_schema do
    field :name, :string
    field :street, :string
    field :street_number, :string
    field :postal_code, :string
    field :country, :string
    field :language, :string
    field :tax_type, :string
    field :tax_id
  end

  @doc false
  def changeset(%Request{} = activity, attrs) do
    activity
    |> cast(attrs, [:name, :street, :street_number, :postal_code, :country, :language, :tax_type, :tax_id])
    #|> validate_required([:type, :status, :title, :description, :content, :date_from, :date_to])
    #|> Entity.cast_content(attrs)
  end
end
