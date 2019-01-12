defmodule Fechgo.Repo.Migrations.CreateScoreboardTable do
  use Ecto.Migration

  def change do
    create table(:scoreboards) do
      add :placement, :integer
      add :victories, :integer
      add :defeats, :integer
      add :draws, :integer
      add :tournament_id, references(:tournaments, on_delete: :delete_all)
      add :player_id, references(:players, on_delete: :nothing)

      timestamps()
    end

    create index(:scoreboards, [:tournament_id])
    create index(:scoreboards, [:player_id])
  end
end

