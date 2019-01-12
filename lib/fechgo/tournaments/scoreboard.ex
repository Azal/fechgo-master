defmodule Fechgo.Tournaments.Scoreboard do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fechgo.Tournaments.Scoreboard

  schema "scoreboards" do
    field :placement, :integer
    field :victories, :integer
    field :defeats, :integer
    field :draws, :integer
    field :points, :float
    field :sos, :integer
    field :sosos, :integer

    belongs_to :tournament, Fechgo.Tournaments.Tournament
    belongs_to :player, Fechgo.Registration.Player
    timestamps()
  end

  @doc false
  def changeset(%Scoreboard{} = scoreboard, attrs) do
    scoreboard
    |> cast(attrs, [:placement, :victories, :defeats, :draws, :points, :sos, :sosos])
    |> put_assoc(:player, attrs.player)
    |> validate_required([:placement, :victories, :defeats, :draws])
  end

end
