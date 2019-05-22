defmodule Erm.Entities.EntityTags do
  use Ecto.Schema
  import Ecto.Changeset


  schema "entity_tags" do
    field :entity_id, :id
    field :tag_id, :id

    timestamps()
  end

  @doc false
  def changeset(entity_tags, attrs) do
    entity_tags
    |> cast(attrs, [])
    |> validate_required([])
  end
end
