defmodule Fechgo.Repo.Migrations.RemoveOnlineColFromTournaments do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      remove :online
    end
  end
end
