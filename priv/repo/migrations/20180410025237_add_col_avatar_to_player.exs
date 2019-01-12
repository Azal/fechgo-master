defmodule Fechgo.Repo.Migrations.AddColAvatarToPlayer do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :avatar, :string
    end
  end
end
