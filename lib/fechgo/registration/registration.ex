defmodule Fechgo.Registration do
  @moduledoc """
  The Registration context.
  """

  import Ecto.Query, warn: false
  alias Fechgo.Repo

  alias Fechgo.Registration.Club
  alias Fechgo.RegionEnum
  require IEx

  # Returns a list of tuple: [{region_name, index}]
  def get_regions do
    RegionEnum.__enum_map__() |> Enum.map(fn({x,y})-> {to_string(x), y} end)
  end

  @doc """
  Returns the list of clubs.

  ## Examples

      iex> list_clubs()
      [%Club{}, ...]

  """
  def list_clubs do
    Repo.all(Club)
    |> Repo.preload(:players)
  end

  @doc """
  Gets a single club.

  Raises `Ecto.NoResultsError` if the Club does not exist.

  ## Examples

      iex> get_club!(123)
      %Club{}

      iex> get_club!(456)
      ** (Ecto.NoResultsError)

  """
  def get_club!(id), do: Repo.get!(Club, id) |> Repo.preload(:players)

  def get_club_by_name(name) do
    Repo.get_by(Club, name: name)
  end
  @doc """
  Creates a club.

  ## Examples

      iex> create_club(%{field: value})
      {:ok, %Club{}}

      iex> create_club(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_club(attrs \\ %{}) do
    %Club{}
    |> Club.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a club.

  ## Examples

      iex> update_club(club, %{field: new_value})
      {:ok, %Club{}}

      iex> update_club(club, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_club(%Club{} = club, attrs) do
    club
    |> Club.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Club.

  ## Examples

      iex> delete_club(club)
      {:ok, %Club{}}

      iex> delete_club(club)
      {:error, %Ecto.Changeset{}}

  """
  def delete_club(%Club{} = club) do
    Repo.delete(club)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking club changes.

  ## Examples

      iex> change_club(club)
      %Ecto.Changeset{source: %Club{}}

  """
  def change_club(%Club{} = club) do
    Club.changeset(club, %{})
  end

  alias Fechgo.Registration.Player

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players do
    Repo.all(Player) |> Repo.preload([:club, :scoreboards])
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id) |> Repo.preload([:club, :scoreboards])

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    club = get_club!(attrs["club_id"])
    attrs = Map.put(attrs, "club", club)
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    club = get_club!(attrs["club_id"])
    attrs = Map.put(attrs, "club", club)
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{source: %Player{}}

  """
  def change_player(%Player{} = player) do
    Player.changeset(player, %{club: nil})
  end

  def parse_xls_to_map(path) do
    result_map = Xlsxir.multi_extract(path)[:ok]
                |> Xlsxir.get_mda

    Xlsxir.close(Xlsxir.multi_extract(path)[:ok])
    result_map
  end
  # Returns:
  # {:ok, result} , with result:
  # {:error, reason}, with reason:
  # players_map: %{[0] => %{[0] => "first_name", [1] => "last_name", [2] => "email" ...}}
  # ... see below for more details
  def create_players_from_file(attrs \\ %{}) do
    players_map = parse_xls_to_map(attrs["file"].path)

    save_players(players_map)
  end

  def save_players(players_map) do

    players_map
        |> Enum.reject(fn({k, _}) -> k == 0 end)
        |> Enum.map(fn({_, v}) ->
            club_id = case v[4] do
                        nil -> nil
                        _   ->
                          case get_club_by_name(v[4]) do
                            nil -> nil
                            %{id: id} -> id # Matching id from Club Struct
                          end
                      end
            birthday = case v[5] do
                        nil -> nil
                        {year, month, day}   -> %{year: year, month: month, day: day}
                      end
            started_go = case v[6] do
                        nil -> nil
                        year -> %{year: year, month: 1, day: 1}
                      end
            Player.changeset_file_import(%Player{}, %{
                "first_name"   => v[1],
                "last_name"    => v[2],
                "email"        => v[3],
                "club_id"      => club_id,
                "birthday"     => birthday,
                "started_go" => started_go,
                "city"         => v[7]
            })
        end)
        |> Enum.reduce({Ecto.Multi.new, 0}, fn(p_changeset, {multi, index}) ->
                {Ecto.Multi.insert(multi, index, p_changeset), index + 1}
            end)
        |> elem(0)
        |> Repo.transaction
  end
end
