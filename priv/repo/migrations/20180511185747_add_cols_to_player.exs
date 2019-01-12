defmodule Fechgo.Repo.Migrations.AddColsToPlayer do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :city, :string
      add :started_go, :date
      add :birthday, :date
    end
  end
end
