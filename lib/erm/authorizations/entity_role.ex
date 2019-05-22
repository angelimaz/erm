defmodule Erm.Authorizations.EntityRole do
  use Ecto.Schema

  schema "entity_roles" do
    belongs_to :entity, Erm.Entities.Entity
    belongs_to :role, Erm.Authorizations.Role

    timestamps()
  end
end
