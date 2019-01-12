defmodule Fechgo.Repo.Migrations.AlterGamesTable do
  use Ecto.Migration

  def change do
    alter table(:games) do
      remove :white_id
      remove :black_id
      add :white, references(:players, on_delete: :nothing)
      add :black, references(:players, on_delete: :nothing)
    end

    create index(:games, [:white])
    create index(:games, [:black])
  end
end
