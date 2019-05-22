defmodule Erm.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :icon, :string
      add :colour, :string

      timestamps()
    end

  end
end
