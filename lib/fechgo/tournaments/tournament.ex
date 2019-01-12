defmodule Fechgo.Tournaments.Tournament do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fechgo.Tournaments.Tournament
  alias Fechgo.Tournaments.Round
  alias Fechgo.Registration.Club
  alias Fechgo.Tournaments.Scoreboard
  alias Fechgo.Tournaments.TournamentType

  schema "tournaments" do
    field :date, :date
    field :name, :string
    field :point_valid, :boolean
    field :total_players, :integer
    field :location, :string
    field :ih_index, :float
    field :points_criteria, :float
    field :total_points, :float
    field :main_img, :string
    field :organizer_id, :integer
    field :tournament_type_id, :integer

    belongs_to :organizer, Club, define_field: false, on_replace: :nilify
    has_many :rounds, Round, on_delete: :delete_all, on_replace: :nilify
    has_many :scoreboards, Scoreboard, on_delete: :delete_all, on_replace: :nilify
    belongs_to :tournament_type, TournamentType, define_field: false, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(%Tournament{} = tournament, attrs) do
    tournament
    |> cast(attrs, [:name, :date, :point_valid, :location, :ih_index, :total_points, :total_players, :points_criteria])
    |> put_assoc(:rounds, attrs["rounds"]) # generates has_many assoc
    |> put_assoc(:scoreboards, attrs["scoreboards"]) # generates has_many assoc
    |> put_assoc(:organizer, attrs["organizer"])
    |> put_assoc(:tournament_type, attrs["tournament_type"])
    |> Upload.Ecto.cast_upload(:main_img, prefix: ["tournaments"])
    |> validate_required([:name, :date, :point_valid, :location])
  end
  def changeset_update(%Tournament{} = tournament, attrs) do
    tournament
    |> cast(attrs, [:name, :date, :point_valid, :location])
    |> put_assoc(:organizer, attrs["organizer"])
    |> put_assoc(:tournament_type, attrs["tournament_type"])
    |> Upload.Ecto.cast_upload(:main_img, prefix: ["tournaments"])
    |> validate_required([:name, :date, :point_valid, :location])
  end
end
