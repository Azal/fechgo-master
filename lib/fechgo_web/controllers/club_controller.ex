defmodule FechgoWeb.ClubController do
  use FechgoWeb, :controller

  alias Fechgo.Registration
  alias Fechgo.Registration.Club
  require IEx

  def index(conn, _params) do
    clubs = Registration.list_clubs()
    render(conn, "index.html", clubs: clubs)
  end

  def new(conn, _params) do
    regions = Registration.get_regions()
            |> Enum.map(fn({name, index}) -> [key: name, value: index ] end)
    changeset = Registration.change_club(%Club{})
    render(conn, "new.html", changeset: changeset, regions: regions)
  end

  def create(conn, %{"club" => club_params}) do
    # Region needs to be integer (RegionEnum)
    club_params = Map.put(club_params, "region", String.to_integer(club_params["region"]))
    case Registration.create_club(club_params) do
      {:ok, club} ->
        conn
        |> put_flash(:info, "Club created successfully.")
        |> redirect(to: club_path(conn, :show, club))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    club = Registration.get_club!(id)
    render(conn, "show.html", club: club)
  end

  def edit(conn, %{"id" => id}) do
    club = Registration.get_club!(id)
    regions = Registration.get_regions()
            |> Enum.map(fn({name, index}) -> [key: name, value: index ] end)
    changeset = Registration.change_club(club)
    render(conn, "edit.html", club: club, changeset: changeset, regions: regions)
  end

  def update(conn, %{"id" => id, "club" => club_params}) do
    club = Registration.get_club!(id)
    # Region needs to be integer (RegionEnum)
    club_params = Map.put(club_params, "region", String.to_integer(club_params["region"]))
    regions = Registration.get_regions()
            |> Enum.map(fn({name, index}) -> [key: name, value: index ] end)
    case Registration.update_club(club, club_params) do
      {:ok, club} ->
        conn
        |> put_flash(:info, "Club updated successfully.")
        |> redirect(to: club_path(conn, :show, club))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", club: club, changeset: changeset, regions: regions)
    end
  end

  def delete(conn, %{"id" => id}) do
    club = Registration.get_club!(id)
    {:ok, _club} = Registration.delete_club(club)

    conn
    |> put_flash(:info, "Club deleted successfully.")
    |> redirect(to: club_path(conn, :index))
  end
end
