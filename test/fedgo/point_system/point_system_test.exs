defmodule Fechgo.PointSystemTest do
  use Fechgo.DataCase

  alias Fechgo.PointSystem

  use ExUnit.Case

  import Fechgo.PointSystem.CLI
  import Fechgo.PointSystemTest.Seed

  describe "Results for players with same 'placement'" do
    setup do
  		[
  			players: data_players_same_placement(),
  			results: data_results_same_placement()
  		]
    end

    test "Return correct output", fixture do
      players = main(fixture.players).players
                |> Enum.map(fn(x) -> Map.put(x, :points, Float.round(x.points, 1)) end)
      assert players == fixture.results.players
    end
  end
  describe "Results for 'even' number of players" do
  	setup do
  		[
  			players: data_players(),
  			results: data_results()
  		]
  	end

  	test "assign correct points (not normalized) for players", fixture do
  		players = compute_points(fixture.players, fixture.results[:ih_index])
  				  |> Enum.map(fn(x) ->
  				  		Map.put(x, :points, Float.round(x.points, 1)) end)

  		assert players == fixture.results[:players]
  	end

  	test "compute correct points criteria", fixture do
  		points_criteria = compute_points_criteria(fixture.results[:players])[:points_criteria]
  						  |> Float.round(3)
  		assert points_criteria == fixture.results[:points_criteria]
  	end

  	test "compute correct ih_index", fixture do
  		results = process_points(fixture.players)
  		players = results[:players]
				  |> Enum.map(fn(x) ->
				  		Map.put(x, :points, Float.round(x.points, 1)) end)
		ih_index = Float.round(results[:ih_index], 1)
		points_criteria = Float.round(results[:points_criteria], 3)
		to_assert = %{players: players, ih_index: ih_index, points_criteria: points_criteria }
  		assert to_assert == fixture.results
  	end
  end

  describe "Results for 'odd' number of players" do
  	setup do
  		[
  			players: Enum.drop(data_players(), -1),
  			results: data_results_odd()
  		]
  	end

  	test "assign correct points (not normalized) for players", fixture do
  		players = compute_points(fixture.players, fixture.results[:ih_index])
  				  |> Enum.map(fn(x) ->
  				  		Map.put(x, :points, Float.round(x.points, 1)) end)

  		assert players == fixture.results[:players]
  	end

  	test "compute correct points criteria", fixture do
  		points_criteria = compute_points_criteria(fixture.results[:players])[:points_criteria]
  						  |> Float.round(3)
  		assert points_criteria == fixture.results[:points_criteria]
  	end

  	test "compute correct ih_index", fixture do
  		results = process_points(fixture.players)
  		players = results[:players]
				  |> Enum.map(fn(x) ->
				  		Map.put(x, :points, Float.round(x.points, 1)) end)
		ih_index = Float.round(results[:ih_index], 1)
		points_criteria = Float.round(results[:points_criteria], 3)
		to_assert = %{players: players, ih_index: ih_index, points_criteria: points_criteria }
  		assert to_assert == fixture.results
  	end
  end

  describe "points_history" do
    alias Fechgo.PointSystem.PointHistory

    @valid_attrs %{amount: 120.5, date: ~D[2010-04-17], reason: "some reason"}
    @update_attrs %{amount: 456.7, date: ~D[2011-05-18], reason: "some updated reason"}
    @invalid_attrs %{amount: nil, date: nil, reason: nil}

    def point_history_fixture(attrs \\ %{}) do
      {:ok, point_history} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PointSystem.create_point_history()

      point_history
    end

    test "list_points_history/0 returns all points_history" do
      point_history = point_history_fixture()
      assert PointSystem.list_points_history() == [point_history]
    end

    test "get_point_history!/1 returns the point_history with given id" do
      point_history = point_history_fixture()
      assert PointSystem.get_point_history!(point_history.id) == point_history
    end

    test "create_point_history/1 with valid data creates a point_history" do
      assert {:ok, %PointHistory{} = point_history} = PointSystem.create_point_history(@valid_attrs)
      assert point_history.amount == 120.5
      assert point_history.date == ~D[2010-04-17]
      assert point_history.reason == "some reason"
    end

    test "create_point_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PointSystem.create_point_history(@invalid_attrs)
    end

    test "update_point_history/2 with valid data updates the point_history" do
      point_history = point_history_fixture()
      assert {:ok, point_history} = PointSystem.update_point_history(point_history, @update_attrs)
      assert %PointHistory{} = point_history
      assert point_history.amount == 456.7
      assert point_history.date == ~D[2011-05-18]
      assert point_history.reason == "some updated reason"
    end

    test "update_point_history/2 with invalid data returns error changeset" do
      point_history = point_history_fixture()
      assert {:error, %Ecto.Changeset{}} = PointSystem.update_point_history(point_history, @invalid_attrs)
      assert point_history == PointSystem.get_point_history!(point_history.id)
    end

    test "delete_point_history/1 deletes the point_history" do
      point_history = point_history_fixture()
      assert {:ok, %PointHistory{}} = PointSystem.delete_point_history(point_history)
      assert_raise Ecto.NoResultsError, fn -> PointSystem.get_point_history!(point_history.id) end
    end

    test "change_point_history/1 returns a point_history changeset" do
      point_history = point_history_fixture()
      assert %Ecto.Changeset{} = PointSystem.change_point_history(point_history)
    end
  end
end
