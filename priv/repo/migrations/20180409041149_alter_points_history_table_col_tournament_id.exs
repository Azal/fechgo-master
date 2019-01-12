defmodule Fechgo.Repo.Migrations.AlterPointsHistoryTableColTournamentId do
  use Ecto.Migration

  def change do
    alter table(:points_history) do
      remove :tournament_id
      add :tournament_id, references(:tournaments, on_delete: :delete_all)
    end
  end
end
