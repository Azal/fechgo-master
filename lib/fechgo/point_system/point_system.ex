defmodule Fechgo.PointSystem do
  @moduledoc """
  The PointSystem context.
  """

  import Ecto.Query, warn: false
  alias Fechgo.Repo

  alias Fechgo.PointSystem.PointHistory
  alias Fechgo.Tournaments
  alias Fechgo.Tournaments.Tournament
  alias Fechgo.Registration
  require IEx

  @doc """
  Returns the list of points_history.

  ## Examples

      iex> list_points_history()
      [%PointHistory{}, ...]

  """
  def list_points_history do
    Repo.all(PointHistory)
  end

  @doc """
  Gets a single point_history.

  Raises `Ecto.NoResultsError` if the Point history does not exist.

  ## Examples

      iex> get_point_history!(123)
      %PointHistory{}

      iex> get_point_history!(456)
      ** (Ecto.NoResultsError)

  """
  def get_point_history!(id), do: Repo.get!(PointHistory, id)

  @doc """
  Creates a point_history.

  ## Examples

      iex> create_point_history(%{field: value})
      {:ok, %PointHistory{}}

      iex> create_point_history(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_point_history(attrs \\ %{}) do
    attrs = Map.new(attrs, fn {k, v} -> {String.to_atom(k), v} end)
            |> Map.put(:player, Fechgo.Registration.get_player!(attrs["player_id"]))
            |> Map.put(:tournament, nil)
    %PointHistory{}
    |> PointHistory.changeset(attrs)
    |> Repo.insert()
  end
  # If a tournament is valid for points it calls this method.
  def create_point_history_for_tournament(attrs \\ %{}) do
    %PointHistory{}
    |> PointHistory.changeset(attrs)
    |> Repo.insert()
  end
  @doc """
  Updates a point_history.

  ## Examples

      iex> update_point_history(point_history, %{field: new_value})
      {:ok, %PointHistory{}}

      iex> update_point_history(point_history, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_point_history(%PointHistory{} = point_history, attrs) do
    point_history
    |> PointHistory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PointHistory.

  ## Examples

      iex> delete_point_history(point_history)
      {:ok, %PointHistory{}}

      iex> delete_point_history(point_history)
      {:error, %Ecto.Changeset{}}

  """
  def delete_point_history(%PointHistory{} = point_history) do
    Repo.delete(point_history)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking point_history changes.

  ## Examples

      iex> change_point_history(point_history)
      %Ecto.Changeset{source: %PointHistory{}}

  """
  def change_point_history(%PointHistory{} = point_history) do
    PointHistory.changeset(point_history, %{player: nil, tournament: nil})
  end
  # Calculates the ranking history of every player for every tournametn within a timespan of 1 year
  # In the future, a better approach is to calculate the ranking at a given datespan (Ex: every week)
  def get_ranking_history do
    players = Registration.list_players
    tournaments = Tournaments.list_point_valid_tournaments

    Enum.map(tournaments, fn(t) ->
      # Get every 'point valid' tournament before 'tournament' and with one year difference
      prev_tournaments  = tournaments
                          |> Enum.filter(fn(x) -> Date.diff(t.date, x.date) >= 0 end)
                          |> Enum.filter(fn(x) -> Date.diff(t.date, x.date) <= 365  end)
                          |> Enum.filter(fn(x) -> x.point_valid end)
      # Calculates ranking, based of the sum of points in every prev tourmanet
      # to tournament 't', for each known player.
      ranking = Enum.map(players, fn(player) ->
                  points = Enum.reduce(prev_tournaments, 0, fn(prev_t, acc) ->
                            scoreboard = Enum.find(prev_t.scoreboards, &(&1.player_id == player.id))
                            case scoreboard do
                              nil -> 0.0 + acc # Player did not play this prev_t tournament (needs to be float)
                              _   -> scoreboard.points + acc
                            end
                          end)
                played_tournaments = Enum.count(player.scoreboards, fn(x) ->
                  Enum.any?(prev_tournaments, &(&1.id == x.tournament_id))
                end)
                participation = played_tournaments/Enum.count(prev_tournaments)
                %{player: player, points: points, participation: participation}
               end)
               |> Enum.sort(&(&1.points >= &2.points)) # sorts players based of the acc points
               |> Enum.with_index(1) # [{%{player: player, points: points}, 1 }... ]
               |> Enum.map(fn({x, i}) -> %{player: x.player,
                                           points: x.points,
                                           participation: x.participation,
                                           rank: i} end)
      %{tournament: t, ranking: ranking}
    end)
    |> Enum.sort_by(&(Date.to_erl(&1.tournament.date)))
    |> Enum.reverse
  end
  def process_points_for_tournament(%Tournament{} = tournament) do
    results = tournament.scoreboards
      |> Enum.zip(1..Enum.count(tournament.scoreboards))
      |> Enum.map(fn({x, index}) -> %{player_id: x.player_id,
                             placement: x.placement,
                             num: index } end) # maps players in correct format
      |> Fechgo.PointSystem.CLI.main(tournament.tournament_type.weight) # Assigns points for players in this tournament

    # Save points history for every player in tournament
    results.players
    |> Enum.each(fn(player) ->
        create_point_history_for_tournament(
            %{player: Registration.get_player!(player.player_id),
              tournament: tournament,
              amount: player.points,
              reason: tournament.name,
              date: tournament.date})
    end)

    # Update scoreboards of tournament to add points for every scoreboard(player)
    results.players
    |> Enum.each(fn(player) ->
        Enum.find(tournament.scoreboards, fn(scoreboard) ->
          player.player_id == scoreboard.player_id
        end)
        |> Ecto.Changeset.change(points: player.points)
        |> Repo.update
    end)
    # Update tournament attrs: total_points and ih_index
    total_points = Enum.reduce(results.players, 0, fn(x, acc) -> x.points + acc end)
    tournament
    |> Ecto.Changeset.change(ih_index: results.ih_index,
                             total_points: total_points,
                             points_criteria: results.points_criteria)
    |> Repo.update
  end
end
