defmodule Fechgo.Tournaments.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fechgo.Tournaments.Game
  alias Fechgo.Registration.Player
  alias Fechgo.Tournaments.Round


  schema "games" do
    field :result, :string
    field :handicap, :integer
    field :round_id, :integer
    field :white_id, :integer
    field :black_id, :integer
    belongs_to :white, Player, define_field: false
    belongs_to :black, Player, define_field: false
    belongs_to :round, Round, define_field: false

    timestamps()
  end

  @doc false
  def changeset(%Game{} = game, attrs) do
    game
    |> cast(attrs, [:result])
    |> put_assoc(:white, attrs.white)
    |> put_assoc(:black, attrs.black)
  end
end
