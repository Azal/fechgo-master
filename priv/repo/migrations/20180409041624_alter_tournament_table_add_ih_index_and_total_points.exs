defmodule Fechgo.Repo.Migrations.AlterTournamentTableAddIhIndexAndTotalPoints do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :total_points, :float
      add :ih_index, :float
    end
  end
end
