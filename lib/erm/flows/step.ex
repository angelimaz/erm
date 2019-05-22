defmodule Erm.Flows.Step do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :value, :string
    field :name, :string
    field :type, :string
    field :next_step, :string
  end

  def changeset(step, attrs) do
    step
    |> cast(attrs, [:value, :name, :type, :next_step])
  end

end
