defmodule Fechgo.Repo.Migrations.AlterTournamentsAddDateCol do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :date, :date
    end
  end
end
