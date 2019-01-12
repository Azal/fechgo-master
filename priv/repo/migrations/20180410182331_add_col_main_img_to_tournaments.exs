defmodule Fechgo.Repo.Migrations.AddColMainImgToTournaments do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :main_img, :string
    end
  end
end
