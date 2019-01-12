defmodule FechgoWeb.TournamentController do
  use FechgoWeb, :controller
  require IEx

  alias Fechgo.Tournaments
  alias Fechgo.Tournaments.Tournament
  alias Fechgo.Registration
  alias Fechgo.PointSystem

  def index(conn, _params) do
    tournaments = Tournaments.list_tournaments()
    players = Registration.list_players()
    render(conn, "index.html", tournaments: tournaments, players: players)
  end

  def new(conn, _params) do
    changeset = Tournaments.change_tournament(%Tournament{})
    clubs = Registration.list_clubs()
            |> Enum.map(fn(club) -> [key: club.name, value: club.id ] end)
    tournament_types = Tournaments.list_tournament_types()
            |> Enum.map(fn(t) -> [key: t.name, value: t.id ] end)
    render(conn, "new.html", changeset: changeset,
                             clubs: clubs,
                             tournament_types: tournament_types)
  end

  def create(conn, %{"tournament" => tournament_params}) do
    clubs = Registration.list_clubs()
            |> Enum.map(fn(club) -> [key: club.name, value: club.id ] end)
    tournament_types = Tournaments.list_tournament_types()
            |> Enum.map(fn(t) -> [key: t.name, value: t.id ] end)
    case Tournaments.create_tournament_from_file(tournament_params) do
      {:ok, tournament} -> # Checks if players are valid
        case tournament do
          {:ok, tournament} -> # Checks if all attrs of tournament are valid
          # If tournament is point valid, assign points to players and tournament
          if tournament.point_valid do
            PointSystem.process_points_for_tournament(tournament)
          end
            conn
            |> put_flash(:info, "Tournament created successfully.")
            |> redirect(to: tournament_path(conn, :show, tournament))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset,
                                     clubs: clubs,
                                     tournament_types: tournament_types)
        end
      {:error, invalid_players} ->
        render(conn, "new.html", changeset: Tournament.changeset_update(%Tournament{}, tournament_params),
                                  invalid_players: invalid_players,
                                  clubs: clubs,
                                  tournament_types: tournament_types)
    end
  end

  def show(conn, %{"id" => id}) do
    tournament = Tournaments.get_tournament!(id)
    clubs = Fechgo.Registration.list_clubs
    players = Fechgo.Registration.list_players
    render(conn, "show.html", tournament: tournament, clubs: clubs, players: players)
  end

  def edit(conn, %{"id" => id}) do
    tournament = Tournaments.get_tournament!(id)
    clubs = Registration.list_clubs()
            |> Enum.map(fn(club) -> [key: club.name, value: club.id ] end)
    tournament_types = Tournaments.list_tournament_types()
            |> Enum.map(fn(t) -> [key: t.name, value: t.id ] end)
    changeset = Tournaments.change_tournament(tournament)
    render(conn, "edit.html", tournament: tournament,
                              changeset: changeset,
                              clubs: clubs,
                              tournament_types: tournament_types)
  end

  def update(conn, %{"id" => id, "tournament" => tournament_params}) do
    tournament = Tournaments.get_tournament!(id)
    # To delete existing image: image key present and tournament needs to have an image already
    if(Map.has_key?(tournament_params, "main_img") and tournament.main_img) do
      path = Fechgo.FileHelper.path("#{tournament.main_img}")
      File.rm!(path) # Raises exception in case of failure
    end

    case Tournaments.update_tournament(tournament, tournament_params) do
      {:ok, tournament} ->
        conn
        |> put_flash(:info, "Tournament updated successfully.")
        |> redirect(to: tournament_path(conn, :show, tournament))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tournament: tournament, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tournament = Tournaments.get_tournament!(id)

    # Check if tournament has an associated img
    case tournament.main_img do
      nil -> Tournaments.delete_tournament(tournament)
        conn
          |> put_flash(:info, "Tournament deleted successfully.")
          |> redirect(to: tournament_path(conn, :index))

      _   ->

        path = Fechgo.FileHelper.path("#{tournament.main_img}")
        # Check if the file is possible to remove exists
        case File.rm(path) do
          :ok -> Tournaments.delete_tournament(tournament)
            conn
            |> put_flash(:info, "Tournament deleted successfully.")
            |> redirect(to: tournament_path(conn, :index))

          {:error, reason} ->
              conn
            |> put_flash(:error, "Error(#{reason}) while deleting Tournament.")
            |> redirect(to: tournament_path(conn, :index))
        end
    end
  end
end
