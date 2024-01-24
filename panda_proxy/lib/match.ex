defmodule Panda.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    field :scheduled_at, :utc_datetime
    field :ps_id, :integer
    field :name, :string

    timestamps()
  end

  def changeset(match, attrs) do
    match
    |> cast(attrs, [:name, :ps_id, :scheduled_at])
    |> validate_required([:name, :ps_id])
    |> unique_constraint(:ps_id)
  end
end
