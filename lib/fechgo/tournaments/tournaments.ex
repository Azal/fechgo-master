defmodule Fechgo.Tournaments do
  @moduledoc """
  The Tournaments context.
  """

  import Ecto.Query, warn: false
  alias Fechgo.Repo

  alias Fechgo.Tournaments.Tournament
  alias Fechgo.Registration.Player
  alias Fechgo.Tournaments.Scoreboard
  alias Fechgo.Registration
  alias Fechgo.Tournaments.Game
  require IEx

  # Return [%{opponent: Player, victories: victories, defeats: defeats, draws: draws}]
  def list_oponents_by_player!(player) do
    players = Registration.list_players

    query = from g in Game,
             where: g.white_id == ^player.id or g.black_id == ^player.id

    games = Repo.all(query)

    players
    |> Enum.reject(&(&1.id == player.id)) # Discards current Player to get all opponents
    |> Enum.map(fn(opponent) ->
        opp_games = Enum.filter(games, &(&1.black_id == opponent.id or &1.white_id == opponent.id))
        draws = Enum.reduce(opp_games, 0, fn(game, acc) ->
                if game.result == "draw", do: acc + 1, else: acc
                end)
        victories = Enum.reduce(opp_games, 0, fn(game, acc) ->
                        cond do
                            game.black_id == player.id and game.result == "black" -> acc + 1
                            game.white_id == player.id and game.result == "white" -> acc + 1
                            true -> acc
                        end
                    end)
        defeats = Enum.count(opp_games) - victories - draws
        %{opponent: opponent, victories: victories, defeats: defeats, draws: draws}
       end)
    |> Enum.reject(&(&1.victories == 0 and &1.draws == 0 and &1.defeats == 0 )) # Discards players without record
    |> Enum.sort(&(&1.opponent.first_name <= &2.opponent.first_name))
  end
  # Return %{opponent: Player, victories: victories, defeats: defeats, draws: draws}
  def get_opponent_stats_by_player!(player, opponent) do
    query = from g in Game,
             where: g.white_id == ^player.id or g.black_id == ^player.id,
             where: g.white_id == ^opponent.id or g.black_id == ^opponent.id

    games = Repo.all(query)

    draws = Enum.reduce(games, 0, fn(game, acc) ->
                 if game.result == "draw", do: acc + 1, else: acc
             end)
    victories = Enum.reduce(games, 0, fn(game, acc) ->
                    cond do
                        game.black_id == player.id and game.result == "black" -> acc + 1
                        game.white_id == player.id and game.result == "white" -> acc + 1
                        true -> acc
                    end
                end)
    defeats = Enum.count(games) - victories - draws

    %{opponent: opponent, victories: victories, defeats: defeats, draws: draws}
  end
  # Return a list of tournaments where both players played (not necessary against each other)
  def get_common_tournaments(player, opponent) do
    list_tournaments()
    |> Enum.filter(fn(tournament)->
        Enum.any?(player.scoreboards, &(&1.tournament_id == tournament.id)) # Needs to be true
        and
        Enum.any?(opponent.scoreboards, &(&1.tournament_id == tournament.id)) # Needs to be true
       end)
    |> Enum.sort_by(&(Date.to_erl(&1.date)))
    |> Enum.reverse
  end
  @doc """
  Returns the list of tournaments.

  ## Examples

      iex> list_tournaments()
      [%Tournament{}, ...]

  """
  def list_tournaments do
    Repo.all(Tournament)
    |> Repo.preload([:organizer, :rounds, :scoreboards, :tournament_type])
  end

  def list_point_valid_tournaments do
    Repo.all(Tournament)
    |> Enum.filter(&(&1.point_valid))
    |> Repo.preload(:scoreboards)
  end

  @doc """
  Gets a single tournament.

  Raises `Ecto.NoResultsError` if the Tournament does not exist.

  ## Examples

      iex> get_tournament!(123)
      %Tournament{}

      iex> get_tournament!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament!(id) do
    Repo.get!(Tournament, id)
    |> Repo.preload([ [rounds: [games: [:white, :black]]],
                    :scoreboards,
                    :organizer,
                    :tournament_type])
  end

  def list_tournaments_by_player!(id) do
    query = from t in Tournament,
             join: s in assoc(t, :scoreboards),
             where: s.player_id == ^id,
             order_by: [desc: t.date],
             preload: [scoreboards: s]
    Repo.all(query)
    |> Repo.preload(:rounds)
    |> Repo.preload(:tournament_type)
  end

  @doc """
  Creates a tournament.

  ## Examples

      iex> create_tournament(%{field: value})
      {:ok, %Tournament{}}

      iex> create_tournament(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament(attrs \\ %{}) do
    %Tournament{}
    |> Tournament.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tournament.

  ## Examples

      iex> update_tournament(tournament, %{field: new_value})
      {:ok, %Tournament{}}

      iex> update_tournament(tournament, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament(%Tournament{} = tournament, attrs) do
    attrs = Map.put(attrs, "organizer", Registration.get_club!(attrs["organizer_id"]))
            |> Map.put("tournament_type", get_tournament_type!(attrs["tournament_type_id"]))


    tournament
    |> Tournament.changeset_update(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tournament.

  ## Examples

      iex> delete_tournament(tournament)
      {:ok, %Tournament{}}

      iex> delete_tournament(tournament)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament(%Tournament{} = tournament) do
    Repo.delete(tournament)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament changes.

  ## Examples

      iex> change_tournament(tournament)
      %Ecto.Changeset{source: %Tournament{}}

  """
  def change_tournament(%Tournament{} = tournament) do
    Tournament.changeset(tournament, %{rounds: nil, scoreboards: nil, organizer: nil})
  end

  alias Fechgo.Tournaments.Round

  @doc """
  Returns the list of rounds.

  ## Examples

      iex> list_rounds()
      [%Round{}, ...]

  """
  def list_rounds do
    Repo.all(Round)
  end

  @doc """
  Gets a single round.

  Raises `Ecto.NoResultsError` if the Round does not exist.

  ## Examples

      iex> get_round!(123)
      %Round{}

      iex> get_round!(456)
      ** (Ecto.NoResultsError)

  """
  def get_round!(id), do: Repo.get!(Round, id)

  @doc """
  Creates a round.

  ## Examples

      iex> create_round(%{field: value})
      {:ok, %Round{}}

      iex> create_round(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_round(attrs \\ %{}) do
    %Round{}
    |> Round.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a round.

  ## Examples

      iex> update_round(round, %{field: new_value})
      {:ok, %Round{}}

      iex> update_round(round, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_round(%Round{} = round, attrs) do
    round
    |> Round.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Round.

  ## Examples

      iex> delete_round(round)
      {:ok, %Round{}}

      iex> delete_round(round)
      {:error, %Ecto.Changeset{}}

  """
  def delete_round(%Round{} = round) do
    Repo.delete(round)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking round changes.

  ## Examples

      iex> change_round(round)
      %Ecto.Changeset{source: %Round{}}

  """
  def change_round(%Round{} = round) do
    Round.changeset(round, %{})
  end

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{source: %Game{}}

  """
  def change_game(%Game{} = game) do
    Game.changeset(game, %{})
  end

  alias Fechgo.Tournaments.TournamentType

  @doc """
  Returns the list of tournament_types.

  ## Examples

      iex> list_tournament_types()
      [%TournamentType{}, ...]

  """
  def list_tournament_types do
    Repo.all(TournamentType)
  end

  @doc """
  Gets a single tournament_type.

  Raises `Ecto.NoResultsError` if the Tournament type does not exist.

  ## Examples

      iex> get_tournament_type!(123)
      %TournamentType{}

      iex> get_tournament_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament_type!(id), do: Repo.get!(TournamentType, id)

  @doc """
  Creates a tournament_type.

  ## Examples

      iex> create_tournament_type(%{field: value})
      {:ok, %TournamentType{}}

      iex> create_tournament_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament_type(attrs \\ %{}) do
    %TournamentType{}
    |> TournamentType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tournament_type.

  ## Examples

      iex> update_tournament_type(tournament_type, %{field: new_value})
      {:ok, %TournamentType{}}

      iex> update_tournament_type(tournament_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament_type(%TournamentType{} = tournament_type, attrs) do
    tournament_type
    |> TournamentType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TournamentType.

  ## Examples

      iex> delete_tournament_type(tournament_type)
      {:ok, %TournamentType{}}

      iex> delete_tournament_type(tournament_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament_type(%TournamentType{} = tournament_type) do
    Repo.delete(tournament_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament_type changes.

  ## Examples

      iex> change_tournament_type(tournament_type)
      %Ecto.Changeset{source: %TournamentType{}}

  """
  def change_tournament_type(%TournamentType{} = tournament_type) do
    TournamentType.changeset(tournament_type, %{})
  end

  def parse_xls_to_map(path) do
    result_map = Xlsxir.multi_extract(path)[:ok]
                |> Xlsxir.get_mda

    Xlsxir.close(Xlsxir.multi_extract(path)[:ok])
    result_map
  end

  def create_tournament_from_file(attrs \\ %{}) do
    tournament_map = parse_xls_to_map(attrs["file"].path)

    players = Repo.all(Player)
    # Checks if the players of the file are already registered
    case validate_players(tournament_map, players) do # Should be a method
        {:ok, tournament_map} -> {:ok, save_tournament(tournament_map, players, attrs)}
        {:error, invalid_players} -> {:error, invalid_players}
    end
  end
  # Returns saved Tournament
  def save_tournament(tournament_map, players, attrs_tournament) do
    organizer = Registration.get_club!(attrs_tournament["organizer_id"])
    tournament_type = get_tournament_type!(attrs_tournament["tournament_type_id"])
    rounds_list = Enum.slice(tournament_map[0],4..
                  (Enum.count(tournament_map[0]) -3))
                  |> Enum.into(%{}) # Converts the tuple to map

    rounds = create_rounds_for_tournament(rounds_list)
             |> Enum.map(fn(round) ->
                Map.put(round, :games, create_games_for_round(tournament_map, players, round))
                |> (&Round.changeset(%Round{}, &1)).() # Adds games to round
             end)
    scoreboards = create_scoreboard_from_map(tournament_map, players)
    tournament_map = Map.put(attrs_tournament, "rounds", rounds) # Adds rounds to tournament_map
                     |> Map.put("scoreboards", scoreboards) # Adds scoreboard to tournament_map
                     |> Map.put("organizer", organizer) # Adds organizer to tournament_map
                     |> Map.put("total_players", Enum.count(scoreboards)) # Adds total participants
                     |> Map.put("tournament_type", tournament_type) # Adds tournament type
    %Tournament{}
    |> Tournament.changeset(tournament_map)
    |> Repo.insert
  end

  def create_scoreboard_from_map(tournament_map, players) do
    tournament_map
    |> Enum.take(1 - Enum.count(tournament_map))
    |> Enum.map(fn({_, player}) ->
        {_, sos} = Enum.at(player, -2)
        {_, sosos} = Enum.at(player, -1)

        Scoreboard.changeset(%Scoreboard{},
            %{placement: player[1],
                player: Enum.find(players, fn(x) -> Player.get_full_name(x) == player[2] end ),
                victories: Enum.count(player, fn({_, v}) -> String.contains?("#{v}", "+") end),
                defeats: Enum.count(player, fn({_, v}) -> String.contains?("#{v}", "-") end),
                draws: Enum.count(player, fn({_, v}) -> String.contains?("#{v}", "=") end),
                points: 0, # Set all points to 0. PointSystem sets the correct value if needed
                sos: sos,
                sosos: sosos})
        end)
  end
  @doc """
  Returns {:ok, tournament_map} if players of file are registered on database.
  Returns {:error, not_valid_players} if players of file are not registered.
  => not_valid_players corresponds sto the players that are not registered.
  """
  def validate_players(tournament_map, players) do
    players = Enum.map(players, fn(x) ->
                Player.get_full_name(x) end)
    players_from_file = Enum.take(tournament_map, 1 - Enum.count(tournament_map))
                        |> Enum.map(fn({_, v}) -> v[2] end)
    # Get difference of both list if any. The difference indicates invalid players
    difference = players_from_file -- players
    case difference do
        [] -> {:ok, tournament_map} # returns valid map
        _ -> {:error, difference} # returns not validated players
    end
  end

  def create_rounds_for_tournament(rounds_list) do
    rounds_list
    |> Enum.map(fn({k,v}) -> %{name: v, index: k - 3} end) # minus 3 because of format
  end

  # Returns list of lists:
  # [[white(Player), black(Player), result] .. [white, black, result]]
  # result can be: draw, black or white
  # Game result could be: "8+/w0" or 0- (handle "/")
  # Becareful with whitespaces in excel (rows and cols)
  def get_games_list(tournament_map, players, r_index) do
    tournament_map |> Enum.map(fn({_, v}) ->
        case String.first(String.trim(v[r_index])) do
            "0" -> nil # Player did not play against other player

            _ -> # Player played against other player
                game_def = String.split(String.trim(v[r_index]), "/") # Ex: ["8+", "w0"], ["0-"]
                IO.inspect game_def
                color = String.first(Enum.at(game_def, 1)) # Ex: "w"
                result = case String.last(Enum.at(game_def, 0)) do # Determines result
                    "+" -> if color == "w", do: "white", else: "black"
                    "-" -> if color == "w", do: "black", else: "white"
                    "=" -> "draw"
                end

                player1 = Enum.find(players, fn(x) ->
                    Player.get_full_name(x) == v[2] end) # compares against name (could be id)
                p2_index = String.to_integer(String.slice(Enum.at(game_def,0), 0..-2))
                player2 = Enum.find(players, fn(x) ->
                    Player.get_full_name(x) == tournament_map[p2_index][2] end) # compares against name (could be id)

                case color do
                    "w" -> [player1, player2, result]
                    "b" -> [player2, player1, result]
                end
        end
    end)
  end
  # list: list of lists [[%Player{}, %Player{}] .. [winner, loser]]
  def create_games_for_round(tournament_map, players, round) do
    tournament_map
    |> Enum.take(1 - Enum.count(tournament_map)) # Returns a list
    |> Enum.into(%{}) # Converts it again to map
    |> get_games_list(players, round.index + 3) # sum 3 because of format
    |> Enum.reject(&(&1 == nil)) # Remove games with no 2 players (nil)
    |> Enum.uniq
    |> Enum.map(fn(game) ->
        Game.changeset(%Game{}, %{white: Enum.find(players, fn(x) -> Enum.at(game, 0) == x end),
                                  black: Enum.find(players, fn(x) -> Enum.at(game, 1) == x end),
                                  result: Enum.at(game, 2) })
        end)
  end
end
