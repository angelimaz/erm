defmodule Erm.Repo.Migrations.CreateFlows do
  use Ecto.Migration

  def change do
    create table(:flows) do
      add :type, :string
      add :name, :string
      add :process, :string
      add :steps, {:array, :map}, default: []

      timestamps()
    end

  end
end
