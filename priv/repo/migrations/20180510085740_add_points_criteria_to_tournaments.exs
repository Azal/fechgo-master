defmodule Fechgo.Repo.Migrations.AddPointsCriteriaToTournaments do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :points_criteria, :float
    end
  end
end
