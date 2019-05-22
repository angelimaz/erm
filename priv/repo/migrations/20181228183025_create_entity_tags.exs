defmodule Erm.Repo.Migrations.CreateEntityTags do
  use Ecto.Migration

  def change do
    create table(:entity_tags) do
      add :entity_id, references(:entities, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)

      timestamps()
    end

    create index(:entity_tags, [:entity_id])
    create index(:entity_tags, [:tag_id])
  end
end
