defmodule Fechgo.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :club_id, references(:clubs, on_delete: :nothing)

      timestamps()
    end

    create index(:players, [:club_id])
  end
end
