defmodule Fechgo.Repo.Migrations.AlterTournamentsAddColsLocationAndPointValid do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      remove :point_Valid
      add :point_valid, :boolean, default: false, null: false
      add :location, :string
    end
  end
end
