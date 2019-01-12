defmodule FechgoWeb.PlayerController do
  use FechgoWeb, :controller

  alias Fechgo.Registration
  alias Fechgo.Registration.Player
  alias Fechgo.Tournaments
  alias Fechgo.PointSystem
  require IEx

  def compare(conn, _params) do
    players = Registration.list_players()
    render(conn, "compare.html", players: players)
  end

  def show_compare(conn, %{"player_id" => player_id, "opponent_id" => opponent_id}) do
    players = Registration.list_players()
    player = Registration.get_player!(player_id)
    opponent = Registration.get_player!(opponent_id)
    opp_stats = Tournaments.get_opponent_stats_by_player!(player, opponent)
    common_tournaments = Tournaments.get_common_tournaments(player, opponent)
    ranking_history = PointSystem.get_ranking_history()

    render(conn, "show_compare.html", players: players,
                                      player: player,
                                      opponent: opponent,
                                      opp_stats: opp_stats,
                                      common_tournaments: common_tournaments,
                                      ranking_history: ranking_history)
  end
  # Needs to be an excel file
  def new_file_import(conn, _params) do
    render(conn, "new_file_import.html")
  end

  def create_players_from_file(conn, params) do
    case Registration.create_players_from_file(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Players created successfully.")
        |> redirect(to: player_path(conn, :index))
      {:error, invalid_players} ->
        render(conn, "new_excel_import.html", invalid_players: invalid_players)
    end
  end

  def index(conn, _params) do
    players = Registration.list_players()
    ranking_history = PointSystem.get_ranking_history()
    clubs = Registration.list_clubs()
    render(conn, "index.html", players: players, ranking_history: ranking_history, clubs: clubs)
  end

  def new(conn, _params) do
    changeset = Registration.change_player(%Player{})
    clubs = Registration.list_clubs()
            |> Enum.map(fn(club) -> [key: club.name, value: club.id ] end)
    render(conn, "new.html", changeset: changeset, clubs: clubs)
  end

  def create(conn, %{"player" => player_params}) do
    case Registration.create_player(player_params) do
      {:ok, player} ->
        conn
        |> put_flash(:info, "Player created successfully.")
        |> redirect(to: player_path(conn, :show, player))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    player = Registration.get_player!(id)
    tournaments = Tournaments.list_tournaments_by_player!(id)
    opponents = Tournaments.list_oponents_by_player!(player)
    # Ranking can be implemented better (need to improve performance in the future => with DB new table)
    # [%{tournament: tournament, ranking: [player, points, rank]}]
    ranking_history = PointSystem.get_ranking_history()

    render(conn, "show.html", player: player,
                              tournaments: tournaments,
                              opponents: opponents,
                              ranking_history: ranking_history)
  end

  def edit(conn, %{"id" => id}) do
    player = Registration.get_player!(id)
    changeset = Registration.change_player(player)
    clubs = Registration.list_clubs()
            |> Enum.map(fn(club) -> [key: club.name, value: club.id ] end)
    render(conn, "edit.html", player: player, changeset: changeset, clubs: clubs)
  end

  def update(conn, %{"id" => id, "player" => player_params}) do
    player = Registration.get_player!(id)
    # To delete existing image: image key present and tournament needs to have an image already
    if(Map.has_key?(player_params, "avatar") and player.avatar) do
      path = Fechgo.FileHelper.path("#{player.avatar}")
      File.rm!(path) # Raises exception in case of failure
    end

    case Registration.update_player(player, player_params) do
      {:ok, player} ->
        conn
        |> put_flash(:info, "Player updated successfully.")
        |> redirect(to: player_path(conn, :show, player))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", player: player, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    player = Registration.get_player!(id)
    # >>> Checking best way to call and remove static files....
    path = Fechgo.FileHelper.path("#{player.avatar}")
    # Check if player has an associated img
    case player.avatar do
      nil -> Registration.delete_player(player)
        conn
          |> put_flash(:info, "Player deleted successfully.")
          |> redirect(to: player_path(conn, :index))

      _   ->
        # Check if the file is possible to remove exists
        case File.rm(path) do
          :ok -> Registration.delete_player(player)
            conn
            |> put_flash(:info, "Player deleted successfully.")
            |> redirect(to: player_path(conn, :index))
          {:error, reason} ->
              conn
            |> put_flash(:error, "Error(#{reason}) while deleting Player.")
            |> redirect(to: player_path(conn, :index))
        end
    end
  end
end
