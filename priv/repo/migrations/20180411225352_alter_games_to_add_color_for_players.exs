defmodule Fechgo.Repo.Migrations.AlterGamesToAddColorForPlayers do
  use Ecto.Migration

  def change do
    alter table(:games) do
      remove :winner_id
      remove :loser_id
      remove :draw
      add :white_id, references(:players, on_delete: :nothing)
      add :black_id, references(:players, on_delete: :nothing)
      add :result, :string
      add :handicap, :integer
    end

    create index(:games, [:white_id])
    create index(:games, [:black_id])
  end
end
