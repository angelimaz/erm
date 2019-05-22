defmodule Erm.Entities.Approval do
  use Ecto.Schema
  import Ecto.Changeset
  alias Erm.Entities.Approval
  alias Erm.Entities.Entity

  embedded_schema do
    embeds_many :steps, Step
    field :date_from, :utc_datetime
    field :date_to, :utc_datetime
    field :description, :string
    field :status, :string
    field :title, :string
    field :type, :string
  end

  @doc false
  def changeset(%Approval{} = approval, attrs) do
    approval
    |> cast(attrs, [:type, :status, :title, :description, :date_from, :date_to])
    |> validate_required([:type, :status, :title, :description, :date_from, :date_to])
    #|> Entity.cast_content(attrs)
  end

  defmodule Step do
    use Ecto.Schema

    embedded_schema do
      field :text, :string
      field :approver, :string
      field :next_step, :string
      field :type, :string
    end
  end
end
