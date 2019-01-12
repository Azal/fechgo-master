defmodule FechgoWeb.TournamentControllerTest do
  use FechgoWeb.ConnCase

  alias Fechgo.Tournaments

  @create_attrs %{date: ~N[2010-04-17 14:00:00.000000], name: "some name"}
  @update_attrs %{date: ~N[2011-05-18 15:01:01.000000], name: "some updated name"}
  @invalid_attrs %{date: nil, name: nil}

  def fixture(:tournament) do
    {:ok, tournament} = Tournaments.create_tournament(@create_attrs)
    tournament
  end

  describe "index" do
    test "lists all tournaments", %{conn: conn} do
      conn = get conn, tournament_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Tournaments"
    end
  end

  describe "new tournament" do
    test "renders form", %{conn: conn} do
      conn = get conn, tournament_path(conn, :new)
      assert html_response(conn, 200) =~ "New Tournament"
    end
  end

  describe "create tournament" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, tournament_path(conn, :create), tournament: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == tournament_path(conn, :show, id)

      conn = get conn, tournament_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Tournament"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, tournament_path(conn, :create), tournament: @invalid_attrs
      assert html_response(conn, 200) =~ "New Tournament"
    end
  end

  describe "edit tournament" do
    setup [:create_tournament]

    test "renders form for editing chosen tournament", %{conn: conn, tournament: tournament} do
      conn = get conn, tournament_path(conn, :edit, tournament)
      assert html_response(conn, 200) =~ "Edit Tournament"
    end
  end

  describe "update tournament" do
    setup [:create_tournament]

    test "redirects when data is valid", %{conn: conn, tournament: tournament} do
      conn = put conn, tournament_path(conn, :update, tournament), tournament: @update_attrs
      assert redirected_to(conn) == tournament_path(conn, :show, tournament)

      conn = get conn, tournament_path(conn, :show, tournament)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, tournament: tournament} do
      conn = put conn, tournament_path(conn, :update, tournament), tournament: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Tournament"
    end
  end

  describe "delete tournament" do
    setup [:create_tournament]

    test "deletes chosen tournament", %{conn: conn, tournament: tournament} do
      conn = delete conn, tournament_path(conn, :delete, tournament)
      assert redirected_to(conn) == tournament_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, tournament_path(conn, :show, tournament)
      end
    end
  end

  defp create_tournament(_) do
    tournament = fixture(:tournament)
    {:ok, tournament: tournament}
  end
end
