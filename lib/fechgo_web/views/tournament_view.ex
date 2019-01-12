defmodule FechgoWeb.TournamentView do
  use FechgoWeb, :view
  alias Fechgo.Registration.Player

  def get_scoreboards_sorted_by_placement(tournament) do
    tournament.scoreboards
    |> Enum.sort(&(&1.placement <= &2.placement))
  end

  def get_club_by_scoreboard(scoreboard, clubs) do
    clubs
    |> Enum.find(fn(club) -> Enum.any?(club.players, &(&1.id == scoreboard.player_id)) end)
  end

  def get_player_by_scoreboard(scoreboard, players) do
    players
    |> Enum.find(&(&1.id == scoreboard.player_id))
  end

  def get_n_places_by_tournament(tournament, place) do
    tournament.scoreboards
    |> Enum.filter(&(&1.placement == place))
  end

  def get_members_grouped_by_clubs(tournament, players) do
    tournament.scoreboards
    |> Enum.map(fn(s) ->
        p = Enum.find(players, &(&1.id == s.player_id))
        Map.put(s, :club_id, p.club_id )
       end)
    |> Enum.group_by(&(&1.club_id))
  end

  def get_sorted_tournaments_by_date(tournaments) do
    tournaments
    |> Enum.sort_by(&(Date.to_erl(&1.date)))
    |> Enum.reverse
  end

  def get_total_points(tournament) do
    case tournament.point_valid do
      true -> Float.round(tournament.total_points, 1)
      false -> "-"
    end
  end

  def get_points_by_scoreboard(scoreboard) do
    case scoreboard.points do
      0.0 -> "-"
      _   -> Float.round(scoreboard.points, 1)
    end
  end
end
