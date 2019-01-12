defmodule Fechgo.Registration.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fechgo.Registration.Player
  alias Fechgo.Registration.Club
  alias Fechgo.Tournaments.Scoreboard


  schema "players" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :avatar, :string
    field :club_id, :integer
    field :birthday, :date
    field :started_go, :date
    field :city, :string
    belongs_to :club, Club, define_field: false, on_replace: :nilify
    has_many :scoreboards, Scoreboard
    has_many :points_history, Fechgo.PointSystem.PointHistory, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(%Player{} = player, attrs) do
    player
    |> cast(attrs, [:first_name, :last_name, :email, :birthday, :city, :started_go])
    |> put_assoc(:club, attrs["club"])
    |> Upload.Ecto.cast_upload(:avatar, prefix: ["avatars"])
    |> validate_required([:first_name, :last_name])
  end

  @doc false
  def changeset_file_import(%Player{} = player, attrs) do
    player
    |> cast(attrs, [:first_name, :last_name, :email, :club_id, :birthday, :city, :started_go])
    |> validate_required([:first_name, :last_name])
  end

  def get_full_name(%Player{} = player) do
    "#{player.first_name} #{player.last_name}"
  end

  def get_club_name(%Player{} = player) do
    case player.club do
      nil -> "Sin Afiliación"
      _   -> player.club.name
    end
  end

  def get_started_go_year(%Player{} = player) do
    case player.started_go do
      nil -> nil
      _   -> player.started_go.year
    end
  end

  def get_age(%Player{} = player) do
    case player.birthday do
      nil -> nil
      _   -> Integer.floor_div(Date.diff(Date.utc_today(), player.birthday), 365)
    end
  end

  # Filters players that have completed information. Players with not completed information
  # can't be selected for ranking
  def get_current_rank(player, ranking_history) do
    ranking_history
      |> List.first # %{ranking: ranking(list of(%{player, points, rank})), tournament: tournament}
      |> Map.get(:ranking)
      |> Enum.find(&(&1.player.id == player.id)) # %{player, points, rank}
      |> Map.get(:rank)
  end

  def get_current_points(player, ranking_history) do
    ranking_history
    |> List.first # %{ranking: ranking(list of(%{player, points, rank})), tournament: tournament}
    |> Map.get(:ranking)
    |> Enum.find(&(&1.player.id == player.id)) # %{player, points, rank}
    |> Map.get(:points)
    |> Float.round(1)
  end

  def valid?(%Player{} = player) do
    if email?(player) and birthday?(player) and started_go?(player) and city?(player) , do: true, else: false
  end

  def email?(%Player{} = player) do
    case player.email do
      nil -> false
      _   -> true
    end
  end

  def birthday?(%Player{} = player) do
    case player.birthday do
      nil -> false
      _   -> true
    end
  end

  def started_go?(%Player{} = player) do
    case player.started_go do
      nil -> false
      _   -> true
    end
  end

  def city?(%Player{} = player) do
    case player.city do
      nil -> false
      _   -> true
    end
  end
end
