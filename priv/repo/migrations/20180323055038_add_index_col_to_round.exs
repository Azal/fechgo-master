defmodule Fechgo.Repo.Migrations.AddIndexColToRound do
  use Ecto.Migration

  def change do
    alter table(:rounds) do
      add :index, :integer
    end
  end
end
