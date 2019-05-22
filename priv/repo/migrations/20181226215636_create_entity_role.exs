defmodule Erm.Repo.Migrations.CreateEntityRole do
  use Ecto.Migration

  def change do
    create table(:entity_roles) do
      add :entity_id, references(:entities), null: false
      add :role_id, references(:roles), null: false

      timestamps()
    end

    create index(:entity_roles, [:entity_id])
    create index(:entity_roles, [:role_id])
    create unique_index(:entity_roles, [:entity_id, :role_id])
  end
end
