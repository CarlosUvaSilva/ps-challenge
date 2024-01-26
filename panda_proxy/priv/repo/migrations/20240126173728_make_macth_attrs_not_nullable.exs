defmodule Panda.Repo.Migrations.MakeMacthAttrsNotNullable do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      modify :ps_id, :integer, null: false
      modify :name, :string, null: false
    end
  end
end
