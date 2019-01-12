defmodule Fechgo.Repo.Migrations.CreateTournaments do
  use Ecto.Migration

  def change do
    create table(:tournaments) do
      add :name, :string
      add :date, :naive_datetime

      timestamps()
    end

  end
end
