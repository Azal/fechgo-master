defmodule Fechgo.TournamentsTest do
  use Fechgo.DataCase

  alias Fechgo.Tournaments

  describe "tournaments" do
    alias Fechgo.Tournaments.Tournament

    @valid_attrs %{date: ~N[2010-04-17 14:00:00.000000], name: "some name"}
    @update_attrs %{date: ~N[2011-05-18 15:01:01.000000], name: "some updated name"}
    @invalid_attrs %{date: nil, name: nil}

    def tournament_fixture(attrs \\ %{}) do
      {:ok, tournament} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tournaments.create_tournament()

      tournament
    end

    test "list_tournaments/0 returns all tournaments" do
      tournament = tournament_fixture()
      assert Tournaments.list_tournaments() == [tournament]
    end

    test "get_tournament!/1 returns the tournament with given id" do
      tournament = tournament_fixture()
      assert Tournaments.get_tournament!(tournament.id) == tournament
    end

    test "create_tournament/1 with valid data creates a tournament" do
      assert {:ok, %Tournament{} = tournament} = Tournaments.create_tournament(@valid_attrs)
      assert tournament.date == ~N[2010-04-17 14:00:00.000000]
      assert tournament.name == "some name"
    end

    test "create_tournament/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament(@invalid_attrs)
    end

    test "update_tournament/2 with valid data updates the tournament" do
      tournament = tournament_fixture()
      assert {:ok, tournament} = Tournaments.update_tournament(tournament, @update_attrs)
      assert %Tournament{} = tournament
      assert tournament.date == ~N[2011-05-18 15:01:01.000000]
      assert tournament.name == "some updated name"
    end

    test "update_tournament/2 with invalid data returns error changeset" do
      tournament = tournament_fixture()
      assert {:error, %Ecto.Changeset{}} = Tournaments.update_tournament(tournament, @invalid_attrs)
      assert tournament == Tournaments.get_tournament!(tournament.id)
    end

    test "delete_tournament/1 deletes the tournament" do
      tournament = tournament_fixture()
      assert {:ok, %Tournament{}} = Tournaments.delete_tournament(tournament)
      assert_raise Ecto.NoResultsError, fn -> Tournaments.get_tournament!(tournament.id) end
    end

    test "change_tournament/1 returns a tournament changeset" do
      tournament = tournament_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament(tournament)
    end
  end

  describe "rounds" do
    alias Fechgo.Tournaments.Round

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def round_fixture(attrs \\ %{}) do
      {:ok, round} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tournaments.create_round()

      round
    end

    test "list_rounds/0 returns all rounds" do
      round = round_fixture()
      assert Tournaments.list_rounds() == [round]
    end

    test "get_round!/1 returns the round with given id" do
      round = round_fixture()
      assert Tournaments.get_round!(round.id) == round
    end

    test "create_round/1 with valid data creates a round" do
      assert {:ok, %Round{} = round} = Tournaments.create_round(@valid_attrs)
      assert round.name == "some name"
    end

    test "create_round/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_round(@invalid_attrs)
    end

    test "update_round/2 with valid data updates the round" do
      round = round_fixture()
      assert {:ok, round} = Tournaments.update_round(round, @update_attrs)
      assert %Round{} = round
      assert round.name == "some updated name"
    end

    test "update_round/2 with invalid data returns error changeset" do
      round = round_fixture()
      assert {:error, %Ecto.Changeset{}} = Tournaments.update_round(round, @invalid_attrs)
      assert round == Tournaments.get_round!(round.id)
    end

    test "delete_round/1 deletes the round" do
      round = round_fixture()
      assert {:ok, %Round{}} = Tournaments.delete_round(round)
      assert_raise Ecto.NoResultsError, fn -> Tournaments.get_round!(round.id) end
    end

    test "change_round/1 returns a round changeset" do
      round = round_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_round(round)
    end
  end

  describe "games" do
    alias Fechgo.Tournaments.Game

    @valid_attrs %{draw: true, winner: true}
    @update_attrs %{draw: false, winner: false}
    @invalid_attrs %{draw: nil, winner: nil}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tournaments.create_game()

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Tournaments.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Tournaments.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Tournaments.create_game(@valid_attrs)
      assert game.draw == true
      assert game.winner == true
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, game} = Tournaments.update_game(game, @update_attrs)
      assert %Game{} = game
      assert game.draw == false
      assert game.winner == false
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Tournaments.update_game(game, @invalid_attrs)
      assert game == Tournaments.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Tournaments.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Tournaments.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_game(game)
    end
  end

  describe "tournament_types" do
    alias Fechgo.Tournaments.TournamentType

    @valid_attrs %{name: "some name", weight: 120.5}
    @update_attrs %{name: "some updated name", weight: 456.7}
    @invalid_attrs %{name: nil, weight: nil}

    def tournament_type_fixture(attrs \\ %{}) do
      {:ok, tournament_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tournaments.create_tournament_type()

      tournament_type
    end

    test "list_tournament_types/0 returns all tournament_types" do
      tournament_type = tournament_type_fixture()
      assert Tournaments.list_tournament_types() == [tournament_type]
    end

    test "get_tournament_type!/1 returns the tournament_type with given id" do
      tournament_type = tournament_type_fixture()
      assert Tournaments.get_tournament_type!(tournament_type.id) == tournament_type
    end

    test "create_tournament_type/1 with valid data creates a tournament_type" do
      assert {:ok, %TournamentType{} = tournament_type} = Tournaments.create_tournament_type(@valid_attrs)
      assert tournament_type.name == "some name"
      assert tournament_type.weight == 120.5
    end

    test "create_tournament_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament_type(@invalid_attrs)
    end

    test "update_tournament_type/2 with valid data updates the tournament_type" do
      tournament_type = tournament_type_fixture()
      assert {:ok, tournament_type} = Tournaments.update_tournament_type(tournament_type, @update_attrs)
      assert %TournamentType{} = tournament_type
      assert tournament_type.name == "some updated name"
      assert tournament_type.weight == 456.7
    end

    test "update_tournament_type/2 with invalid data returns error changeset" do
      tournament_type = tournament_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Tournaments.update_tournament_type(tournament_type, @invalid_attrs)
      assert tournament_type == Tournaments.get_tournament_type!(tournament_type.id)
    end

    test "delete_tournament_type/1 deletes the tournament_type" do
      tournament_type = tournament_type_fixture()
      assert {:ok, %TournamentType{}} = Tournaments.delete_tournament_type(tournament_type)
      assert_raise Ecto.NoResultsError, fn -> Tournaments.get_tournament_type!(tournament_type.id) end
    end

    test "change_tournament_type/1 returns a tournament_type changeset" do
      tournament_type = tournament_type_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament_type(tournament_type)
    end
  end
end
