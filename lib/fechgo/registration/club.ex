defmodule Fechgo.Registration.Club do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fechgo.Registration.Club


  schema "clubs" do
    field :name, :string
    field :region, Fechgo.RegionEnum
    has_many :players, Fechgo.Registration.Player

    timestamps()
  end

  @doc false
  def changeset(%Club{} = club, attrs) do
    club
    |> cast(attrs, [:name, :region])
    |> validate_required([:name, :region])
  end
end
