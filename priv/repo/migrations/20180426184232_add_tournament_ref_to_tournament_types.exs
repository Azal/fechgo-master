defmodule Fechgo.Repo.Migrations.AddTournamentRefToTournamentTypes do
  use Ecto.Migration

  def change do
    alter table(:tournament_types) do
      add :tournament_id, references(:tournaments, on_delete: :nothing)
    end
  end
end
