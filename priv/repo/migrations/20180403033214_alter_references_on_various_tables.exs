defmodule Fechgo.Repo.Migrations.AlterReferencesOnVariousTables do
  use Ecto.Migration

  def change do
    alter table(:rounds) do
      remove :tournament_id
      add :tournament_id, references(:tournaments, on_delete: :delete_all)
    end
    alter table(:games) do
      remove :round_id
      add :round_id, references(:rounds, on_delete: :delete_all)
    end
  end
end
