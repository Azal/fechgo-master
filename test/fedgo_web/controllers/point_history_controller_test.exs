defmodule FechgoWeb.PointHistoryControllerTest do
  use FechgoWeb.ConnCase

  alias Fechgo.PointSystem

  @create_attrs %{amount: 120.5, date: ~D[2010-04-17], reason: "some reason"}
  @update_attrs %{amount: 456.7, date: ~D[2011-05-18], reason: "some updated reason"}
  @invalid_attrs %{amount: nil, date: nil, reason: nil}

  def fixture(:point_history) do
    {:ok, point_history} = PointSystem.create_point_history(@create_attrs)
    point_history
  end

  describe "index" do
    test "lists all points_history", %{conn: conn} do
      conn = get conn, point_history_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Points history"
    end
  end

  describe "new point_history" do
    test "renders form", %{conn: conn} do
      conn = get conn, point_history_path(conn, :new)
      assert html_response(conn, 200) =~ "New Point history"
    end
  end

  describe "create point_history" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, point_history_path(conn, :create), point_history: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == point_history_path(conn, :show, id)

      conn = get conn, point_history_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Point history"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, point_history_path(conn, :create), point_history: @invalid_attrs
      assert html_response(conn, 200) =~ "New Point history"
    end
  end

  describe "edit point_history" do
    setup [:create_point_history]

    test "renders form for editing chosen point_history", %{conn: conn, point_history: point_history} do
      conn = get conn, point_history_path(conn, :edit, point_history)
      assert html_response(conn, 200) =~ "Edit Point history"
    end
  end

  describe "update point_history" do
    setup [:create_point_history]

    test "redirects when data is valid", %{conn: conn, point_history: point_history} do
      conn = put conn, point_history_path(conn, :update, point_history), point_history: @update_attrs
      assert redirected_to(conn) == point_history_path(conn, :show, point_history)

      conn = get conn, point_history_path(conn, :show, point_history)
      assert html_response(conn, 200) =~ "some updated reason"
    end

    test "renders errors when data is invalid", %{conn: conn, point_history: point_history} do
      conn = put conn, point_history_path(conn, :update, point_history), point_history: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Point history"
    end
  end

  describe "delete point_history" do
    setup [:create_point_history]

    test "deletes chosen point_history", %{conn: conn, point_history: point_history} do
      conn = delete conn, point_history_path(conn, :delete, point_history)
      assert redirected_to(conn) == point_history_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, point_history_path(conn, :show, point_history)
      end
    end
  end

  defp create_point_history(_) do
    point_history = fixture(:point_history)
    {:ok, point_history: point_history}
  end
end
