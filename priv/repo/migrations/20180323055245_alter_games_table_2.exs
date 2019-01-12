defmodule Fechgo.Repo.Migrations.AlterGamesTable do
  use Ecto.Migration

  def change do
    alter table(:games) do
      remove :white
      remove :black
      remove :winner
      add :winner, references(:players, on_delete: :nothing)
      add :loser, references(:players, on_delete: :nothing)
    end

    create index(:games, [:winner])
    create index(:games, [:loser])
  end
end
