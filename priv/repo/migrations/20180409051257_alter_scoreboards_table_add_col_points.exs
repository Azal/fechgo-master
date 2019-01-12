defmodule Fechgo.Repo.Migrations.AlterScoreboardsTableAddColPoints do
  use Ecto.Migration

  def change do
    alter table(:scoreboards) do
      add :points, :float
    end
  end
end
