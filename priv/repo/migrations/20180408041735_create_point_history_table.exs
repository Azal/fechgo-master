defmodule Fechgo.Repo.Migrations.CreatePointHistoryTable do
  use Ecto.Migration

  def change do
    create table(:points_history) do
      add :reason, :string
      add :date, :date
      add :amount, :float
      add :player_id, references(:players, on_delete: :nothing)
      add :tournament_id, references(:tournaments, on_delete: :nothing)

      timestamps()
    end
    create index(:points_history, [:player_id])
    create index(:points_history, [:tournament_id])
  end
end
