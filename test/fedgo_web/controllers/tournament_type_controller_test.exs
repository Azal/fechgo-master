defmodule FechgoWeb.TournamentTypeControllerTest do
  use FechgoWeb.ConnCase

  alias Fechgo.Tournaments

  @create_attrs %{name: "some name", weight: 120.5}
  @update_attrs %{name: "some updated name", weight: 456.7}
  @invalid_attrs %{name: nil, weight: nil}

  def fixture(:tournament_type) do
    {:ok, tournament_type} = Tournaments.create_tournament_type(@create_attrs)
    tournament_type
  end

  describe "index" do
    test "lists all tournament_types", %{conn: conn} do
      conn = get conn, tournament_type_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Tournament types"
    end
  end

  describe "new tournament_type" do
    test "renders form", %{conn: conn} do
      conn = get conn, tournament_type_path(conn, :new)
      assert html_response(conn, 200) =~ "New Tournament type"
    end
  end

  describe "create tournament_type" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, tournament_type_path(conn, :create), tournament_type: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == tournament_type_path(conn, :show, id)

      conn = get conn, tournament_type_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Tournament type"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, tournament_type_path(conn, :create), tournament_type: @invalid_attrs
      assert html_response(conn, 200) =~ "New Tournament type"
    end
  end

  describe "edit tournament_type" do
    setup [:create_tournament_type]

    test "renders form for editing chosen tournament_type", %{conn: conn, tournament_type: tournament_type} do
      conn = get conn, tournament_type_path(conn, :edit, tournament_type)
      assert html_response(conn, 200) =~ "Edit Tournament type"
    end
  end

  describe "update tournament_type" do
    setup [:create_tournament_type]

    test "redirects when data is valid", %{conn: conn, tournament_type: tournament_type} do
      conn = put conn, tournament_type_path(conn, :update, tournament_type), tournament_type: @update_attrs
      assert redirected_to(conn) == tournament_type_path(conn, :show, tournament_type)

      conn = get conn, tournament_type_path(conn, :show, tournament_type)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, tournament_type: tournament_type} do
      conn = put conn, tournament_type_path(conn, :update, tournament_type), tournament_type: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Tournament type"
    end
  end

  describe "delete tournament_type" do
    setup [:create_tournament_type]

    test "deletes chosen tournament_type", %{conn: conn, tournament_type: tournament_type} do
      conn = delete conn, tournament_type_path(conn, :delete, tournament_type)
      assert redirected_to(conn) == tournament_type_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, tournament_type_path(conn, :show, tournament_type)
      end
    end
  end

  defp create_tournament_type(_) do
    tournament_type = fixture(:tournament_type)
    {:ok, tournament_type: tournament_type}
  end
end
