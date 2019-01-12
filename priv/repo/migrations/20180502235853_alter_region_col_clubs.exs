defmodule Fechgo.Repo.Migrations.AlterRegionColClubs do
  use Ecto.Migration

  def change do
    alter table(:clubs) do
      remove :region
      add :region, :integer
    end
  end
end
