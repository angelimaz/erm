defmodule Erm.Flows.Flow do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flows" do
    field :name, :string
    field :process, :string
    field :type, :string
    embeds_many :steps, Erm.Flows.Step

    timestamps()
  end

  @doc false
  def changeset(flow, attrs) do
    flow
    |> cast(attrs, [:type, :name, :process])
    |> validate_required([:type, :name, :process])
    |> cast_embed(:steps)

    # |> Ecto.Changeset.put_change(:album_art, album_art_params)
  end

  def add_steps_to_changeset(changeset, steps) do
    new_steps = Enum.map(steps, fn {_index, step} ->
      apply_changes(step)
    end)
    |> IO.inspect()

    changeset
    |> Ecto.Changeset.put_change(:steps, new_steps)

  end
end
