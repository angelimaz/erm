defmodule Erm.Authorizations.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :content, :map
    field :description, :string
    field :name, :string
    field :type, :string
    field :valid_from, :utc_datetime
    field :valid_to, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:type, :name, :description, :valid_from, :valid_to])
    |> cast_content(attrs)
    |> validate_required([:type, :name])
  end

  defp cast_content(changeset, %{"content" => content}) do
    cond do
      content == ":admin" ->
        put_change(changeset, :content, admin_content())

      true ->
        changeset
    end
  end

  defp cast_content(changeset, _) do
    changeset
  end

  defp admin_content() do
    %{
      dashboard: [:all],
      entities: [
        :all
      ],
      relations: [
        :all
      ],
      entity_types: [
        :all
      ],
      relation_types: [
        :all
      ],
      roles: [
        :all
      ],
      map: [
        :all
      ]
    }
  end
end
