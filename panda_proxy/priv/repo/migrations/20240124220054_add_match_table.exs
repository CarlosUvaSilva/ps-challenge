defmodule Exercise.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :ps_id, :integer
      add :name, :string
      add :scheduled_at, :utc_datetime

      timestamps()
    end

    create unique_index(:matches, [:ps_id])
  end
end
