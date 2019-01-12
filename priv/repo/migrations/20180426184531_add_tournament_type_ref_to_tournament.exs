defmodule Fechgo.Repo.Migrations.AddTournamentTypeRefToTournament do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :tournament_type_id, references(:tournament_types, on_delete: :nothing)
    end
    alter table(:tournament_types) do
      remove :tournament_id
    end
  end
end
