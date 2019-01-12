defmodule FechgoWeb.PageView do
  use FechgoWeb, :view
  alias Fechgo.Registration.Player

  # Returns: %{name: players names, data: [points1, points2, ..]}
  def process_ranking_history_for_chart(player, ranking_history) do
    data = ranking_history
            |> Enum.map(fn(x)->
                result = Enum.find(x.ranking, &(&1.player.id == player.id)) # Ranking History of all tournaments
                [x.tournament.date, Float.round(result.points, 1)]
              end)
            |> Enum.reverse
    Map.put(%{}, :data, data)
    |> Map.put(:name, Player.get_full_name(player))
  end

  def get_current_top_n_players(ranking_history, n) do
    ranking_list = ranking_history |> List.first() # %{tournament, ranking}

    if ranking_list do
      ranking_list
      |> Map.get(:ranking)
      |> Enum.take(n)
      |> Enum.map(&(&1.player))
    else
      []
    end
  end

  def get_total_points_by_tournament(tournament) do
    case tournament.point_valid do
      true -> Float.round(tournament.total_points, 1)
      false -> "-"
    end
  end
end
