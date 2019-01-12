defmodule Fechgo.Repo.Migrations.CreateClubs do
  use Ecto.Migration

  def change do
    create table(:clubs) do
      add :name, :string
      add :region, :string

      timestamps()
    end

  end
end
