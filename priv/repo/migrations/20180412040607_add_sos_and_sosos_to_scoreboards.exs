defmodule Fechgo.Repo.Migrations.AddSosAndSososToScoreboards do
  use Ecto.Migration

  def change do
    alter table(:scoreboards) do
      add :sos, :integer
      add :sosos, :integer
    end
  end
end
