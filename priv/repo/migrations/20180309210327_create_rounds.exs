defmodule Fechgo.Repo.Migrations.CreateRounds do
  use Ecto.Migration

  def change do
    create table(:rounds) do
      add :name, :string
      add :tournament_id, references(:tournaments, on_delete: :nothing)

      timestamps()
    end

    create index(:rounds, [:tournament_id])
  end
end
