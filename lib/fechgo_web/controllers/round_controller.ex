defmodule FechgoWeb.RoundController do
  use FechgoWeb, :controller

  alias Fechgo.Tournaments
  alias Fechgo.Tournaments.Round

  def index(conn, _params) do
    rounds = Tournaments.list_rounds()
    render(conn, "index.html", rounds: rounds)
  end

  def new(conn, _params) do
    changeset = Tournaments.change_round(%Round{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"round" => round_params}) do
    case Tournaments.create_round(round_params) do
      {:ok, round} ->
        conn
        |> put_flash(:info, "Round created successfully.")
        |> redirect(to: round_path(conn, :show, round))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    round = Tournaments.get_round!(id)
    render(conn, "show.html", round: round)
  end

  def edit(conn, %{"id" => id}) do
    round = Tournaments.get_round!(id)
    changeset = Tournaments.change_round(round)
    render(conn, "edit.html", round: round, changeset: changeset)
  end

  def update(conn, %{"id" => id, "round" => round_params}) do
    round = Tournaments.get_round!(id)

    case Tournaments.update_round(round, round_params) do
      {:ok, round} ->
        conn
        |> put_flash(:info, "Round updated successfully.")
        |> redirect(to: round_path(conn, :show, round))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", round: round, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    round = Tournaments.get_round!(id)
    {:ok, _round} = Tournaments.delete_round(round)

    conn
    |> put_flash(:info, "Round deleted successfully.")
    |> redirect(to: round_path(conn, :index))
  end
end
