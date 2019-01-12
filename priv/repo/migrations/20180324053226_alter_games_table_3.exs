defmodule Fechgo.Repo.Migrations.AlterGamesTable do
  use Ecto.Migration

  def change do
    alter table(:games) do
      remove :winner
      remove :loser
      add :winner_id, references(:players, on_delete: :nothing)
      add :loser_id, references(:players, on_delete: :nothing)
    end

    create index(:games, [:winner_id])
    create index(:games, [:loser_id])
  end
end
