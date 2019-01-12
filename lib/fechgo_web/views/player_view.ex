defmodule FechgoWeb.PlayerView do
  use FechgoWeb, :view
  alias Fechgo.Registration.Player

  def list_players(players) do
    players
    |> Enum.map(&([Player.get_full_name(&1), &1.id]))
  end

  def process_perfomance_index(victories, defeats, draws) do
    case (victories + defeats + draws) do
      0 -> 0
      _ -> Float.round(victories/(victories + defeats + draws) * 100, 1)
    end
  end
  # Returns: [tournament date, player points, tournament name, player rank ]
  def process_ranking_history_for_chart(player, ranking_history) do
    ranking_history
    |> Enum.map(fn(x)->
      result = Enum.find(x.ranking, &(&1.player.id == player.id)) # Ranking History of all tournaments
      [x.tournament.date,
       Float.round(result.points, 1),
       x.tournament.name,
       result.rank] end)
  end

  def process_ranking_history(player, ranking_history) do
    ranking_history
    |> Enum.map(fn(x)->
      result = Enum.find(x.ranking, &(&1.player.id == player.id)) # Ranking History of all tournaments
      %{tournament: x.tournament,
        points: Float.round(result.points, 1),
        rank: result.rank,
        participation: result.participation * 100 } end)
  end

  def get_players_sorted_by_rank(players, ranking_history) do
    players
    |> Enum.map(fn(p) -> Map.put(p, :rank, Player.get_current_rank(p, ranking_history)) end)
    |> Enum.sort(&(&1.rank <= &2.rank))
  end

  def get_players_sorted_by_points(players, ranking_history) do
    players
    |> Enum.map(fn(p) -> Map.put(p, :points, Player.get_current_points(p, ranking_history)) end)
    |> Enum.sort(&(&1.points >= &2.points))
  end

  # Needs to check participation over 1 year from today (or from last tournmanet)
  def get_current_participation(player, ranking_history) do

    participation = ranking_history
    |> List.first # %{ranking: ranking(list of(%{player, points, rank})), tournament: tournament}
    |> Map.get(:ranking)
    |> Enum.find(&(&1.player.id == player.id)) # %{player, points, rank}
    |> Map.get(:participation)

    participation * 100
  end

  def get_points_by_scoreboard(scoreboard) do
    case scoreboard.points do
      0.0 -> "-"
      _   -> "+ #{Float.round(scoreboard.points, 1)}"
    end
  end

  def get_places_at(player, place) do
    Enum.count(player.scoreboards, fn(x) -> x.placement == place end)
  end

  def get_placement_for_tournament(player, tournament) do
    player.scoreboards
    |> Enum.find(&(&1.tournament_id == tournament.id))
    |> Map.get(:placement)
  end

  def get_total_played_games(player) do
    get_victories(player) + get_defeats(player) + get_draws(player)
  end

  def get_victories(player) do
    Enum.reduce(player.scoreboards, 0, fn(x, acc) -> x.victories + acc end)
  end

  def get_defeats(player) do
    Enum.reduce(player.scoreboards, 0, fn(x, acc) -> x.defeats + acc end)
  end

  def get_draws(player) do
    Enum.reduce(player.scoreboards, 0, fn(x, acc) -> x.draws + acc end)
  end
end
