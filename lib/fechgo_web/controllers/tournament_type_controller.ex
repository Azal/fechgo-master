defmodule FechgoWeb.TournamentTypeController do
  use FechgoWeb, :controller

  alias Fechgo.Tournaments
  alias Fechgo.Tournaments.TournamentType

  def index(conn, _params) do
    tournament_types = Tournaments.list_tournament_types()
    render(conn, "index.html", tournament_types: tournament_types)
  end

  def new(conn, _params) do
    changeset = Tournaments.change_tournament_type(%TournamentType{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tournament_type" => tournament_type_params}) do
    case Tournaments.create_tournament_type(tournament_type_params) do
      {:ok, tournament_type} ->
        conn
        |> put_flash(:info, "Tournament type created successfully.")
        |> redirect(to: tournament_type_path(conn, :show, tournament_type))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tournament_type = Tournaments.get_tournament_type!(id)
    render(conn, "show.html", tournament_type: tournament_type)
  end

  def edit(conn, %{"id" => id}) do
    tournament_type = Tournaments.get_tournament_type!(id)
    changeset = Tournaments.change_tournament_type(tournament_type)
    render(conn, "edit.html", tournament_type: tournament_type, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tournament_type" => tournament_type_params}) do
    tournament_type = Tournaments.get_tournament_type!(id)

    case Tournaments.update_tournament_type(tournament_type, tournament_type_params) do
      {:ok, tournament_type} ->
        conn
        |> put_flash(:info, "Tournament type updated successfully.")
        |> redirect(to: tournament_type_path(conn, :show, tournament_type))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tournament_type: tournament_type, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tournament_type = Tournaments.get_tournament_type!(id)
    {:ok, _tournament_type} = Tournaments.delete_tournament_type(tournament_type)

    conn
    |> put_flash(:info, "Tournament type deleted successfully.")
    |> redirect(to: tournament_type_path(conn, :index))
  end
end
