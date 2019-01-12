defmodule Fechgo.Repo.Migrations.CreateTournamentTypes do
  use Ecto.Migration

  def change do
    create table(:tournament_types) do
      add :name, :string
      add :weight, :float

      timestamps()
    end

  end
end
