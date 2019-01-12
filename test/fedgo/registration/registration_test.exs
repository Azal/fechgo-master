defmodule Fechgo.RegistrationTest do
  use Fechgo.DataCase

  alias Fechgo.Registration

  describe "clubs" do
    alias Fechgo.Registration.Club

    @valid_attrs %{name: "some name", region: "some region"}
    @update_attrs %{name: "some updated name", region: "some updated region"}
    @invalid_attrs %{name: nil, region: nil}

    def club_fixture(attrs \\ %{}) do
      {:ok, club} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Registration.create_club()

      club
    end

    test "list_clubs/0 returns all clubs" do
      club = club_fixture()
      assert Registration.list_clubs() == [club]
    end

    test "get_club!/1 returns the club with given id" do
      club = club_fixture()
      assert Registration.get_club!(club.id) == club
    end

    test "create_club/1 with valid data creates a club" do
      assert {:ok, %Club{} = club} = Registration.create_club(@valid_attrs)
      assert club.name == "some name"
      assert club.region == "some region"
    end

    test "create_club/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Registration.create_club(@invalid_attrs)
    end

    test "update_club/2 with valid data updates the club" do
      club = club_fixture()
      assert {:ok, club} = Registration.update_club(club, @update_attrs)
      assert %Club{} = club
      assert club.name == "some updated name"
      assert club.region == "some updated region"
    end

    test "update_club/2 with invalid data returns error changeset" do
      club = club_fixture()
      assert {:error, %Ecto.Changeset{}} = Registration.update_club(club, @invalid_attrs)
      assert club == Registration.get_club!(club.id)
    end

    test "delete_club/1 deletes the club" do
      club = club_fixture()
      assert {:ok, %Club{}} = Registration.delete_club(club)
      assert_raise Ecto.NoResultsError, fn -> Registration.get_club!(club.id) end
    end

    test "change_club/1 returns a club changeset" do
      club = club_fixture()
      assert %Ecto.Changeset{} = Registration.change_club(club)
    end
  end

  describe "players" do
    alias Fechgo.Registration.Player

    @valid_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name"}
    @update_attrs %{email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name"}
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Registration.create_player()

      player
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Registration.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Registration.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Registration.create_player(@valid_attrs)
      assert player.email == "some email"
      assert player.first_name == "some first_name"
      assert player.last_name == "some last_name"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Registration.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, player} = Registration.update_player(player, @update_attrs)
      assert %Player{} = player
      assert player.email == "some updated email"
      assert player.first_name == "some updated first_name"
      assert player.last_name == "some updated last_name"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Registration.update_player(player, @invalid_attrs)
      assert player == Registration.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Registration.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Registration.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Registration.change_player(player)
    end
  end
end
