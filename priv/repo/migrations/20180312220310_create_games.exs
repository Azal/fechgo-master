defmodule Fechgo.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :winner, :boolean, default: false, null: false
      add :draw, :boolean, default: false, null: false
      add :round_id, references(:rounds, on_delete: :nothing)
      add :white_id, references(:players, on_delete: :nothing)
      add :black_id, references(:players, on_delete: :nothing)

      timestamps()
    end

    create index(:games, [:round_id])
    create index(:games, [:white_id])
    create index(:games, [:black_id])
  end
end
