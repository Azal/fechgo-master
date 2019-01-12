defmodule Fechgo.Tournaments.Round do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fechgo.Tournaments.Round


  schema "rounds" do
    field :name, :string
    field :index, :integer
    belongs_to :tournament, Fechgo.Tournaments.Tournament
    has_many :games, Fechgo.Tournaments.Game, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(%Round{} = round, attrs) do
    round
    |> cast(attrs, [:name, :index])
    |> put_assoc(:games, attrs.games) # generates belongs_to assoc
    |> validate_required([:name, :index])
  end
end
