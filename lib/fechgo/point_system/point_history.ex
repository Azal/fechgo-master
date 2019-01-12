defmodule Fechgo.PointSystem.PointHistory do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fechgo.PointSystem.PointHistory
  alias Fechgo.Registration.Player
  alias Fechgo.Tournaments.Tournament
  require IEx


  schema "points_history" do
    field :amount, :float
    field :date, :date
    field :reason, :string
    belongs_to :player, Player
    belongs_to :tournament, Tournament

    timestamps()
  end

  @doc false
  def changeset(%PointHistory{} = point_history, attrs) do
    #IEx.pry
    point_history
    |> cast(attrs, [:reason, :amount, :date])
    |> put_assoc(:player, attrs.player)
    |> put_assoc(:tournament, attrs.tournament)
    |> validate_required([:reason, :amount, :date])
  end
end
