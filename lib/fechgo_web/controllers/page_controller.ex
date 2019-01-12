defmodule FechgoWeb.PageController do
  use FechgoWeb, :controller
  alias Fechgo.Tournaments
  alias Fechgo.PointSystem
  def index(conn, _params) do
    tournaments = Tournaments.list_tournaments
                  |> Enum.sort_by(&(Date.to_erl(&1.date)))
                  |> Enum.reverse
                  |> Enum.take(4)
    ranking_history = PointSystem.get_ranking_history()

    render(conn, "index.html", tournaments: tournaments, ranking_history: ranking_history)
  end

  def admin_index(conn, _params) do
    render(conn, "admin_index.html")
  end
end
