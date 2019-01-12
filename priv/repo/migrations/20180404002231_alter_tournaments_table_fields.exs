defmodule Fechgo.Repo.Migrations.AlterTournamentsTableFields do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      remove :date
      add :online, :boolean, default: false, null: false
      add :point_Valid, :boolean, default: false, null: false
      add :total_players, :integer
      add :organizer_id, references(:clubs, on_delete: :nothing)
    end
  end
end
