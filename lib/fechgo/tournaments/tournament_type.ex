defmodule Fechgo.Tournaments.TournamentType do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fechgo.Tournaments.TournamentType
  alias Fechgo.Tournaments.Tournament


  schema "tournament_types" do
    field :name, :string
    field :weight, :float
    has_many :tournaments, Tournament

    timestamps()
  end

  @doc false
  def changeset(%TournamentType{} = tournament_type, attrs) do
    tournament_type
    |> cast(attrs, [:name, :weight])
    |> validate_required([:name, :weight])
  end
end
