defmodule Erm.Entities.Tag do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tags" do
    field :colour, :string
    field :icon, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :icon, :colour])
    |> validate_required([:name, :icon, :colour])
  end
end
