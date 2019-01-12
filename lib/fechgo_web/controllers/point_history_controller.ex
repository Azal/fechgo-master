defmodule FechgoWeb.PointHistoryController do
  use FechgoWeb, :controller

  alias Fechgo.PointSystem
  alias Fechgo.PointSystem.PointHistory
  alias Fechgo.Registration.Player
  require IEx

  def index(conn, _params) do
    points_history = PointSystem.list_points_history()
    render(conn, "index.html", points_history: points_history)
  end

  def new(conn, _params) do
    changeset = PointSystem.change_point_history(%PointHistory{})
    players = Fechgo.Registration.list_players
              |> Enum.map(fn(player) -> [key: Player.get_full_name(player),
                                         value: player.id] end)
    render(conn, "new.html", changeset: changeset, players: players)
  end

  def create(conn, %{"point_history" => point_history_params}) do
    case PointSystem.create_point_history(point_history_params) do
      {:ok, point_history} ->
        conn
        |> put_flash(:info, "Point history created successfully.")
        |> redirect(to: point_history_path(conn, :show, point_history))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    point_history = PointSystem.get_point_history!(id)
    render(conn, "show.html", point_history: point_history)
  end

  def edit(conn, %{"id" => id}) do
    point_history = PointSystem.get_point_history!(id)
    changeset = PointSystem.change_point_history(point_history)
    render(conn, "edit.html", point_history: point_history, changeset: changeset)
  end

  def update(conn, %{"id" => id, "point_history" => point_history_params}) do
    point_history = PointSystem.get_point_history!(id)

    case PointSystem.update_point_history(point_history, point_history_params) do
      {:ok, point_history} ->
        conn
        |> put_flash(:info, "Point history updated successfully.")
        |> redirect(to: point_history_path(conn, :show, point_history))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", point_history: point_history, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    point_history = PointSystem.get_point_history!(id)
    {:ok, _point_history} = PointSystem.delete_point_history(point_history)

    conn
    |> put_flash(:info, "Point history deleted successfully.")
    |> redirect(to: point_history_path(conn, :index))
  end
end
