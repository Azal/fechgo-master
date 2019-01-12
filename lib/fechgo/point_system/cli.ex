defmodule Fechgo.PointSystem.CLI do

	require Integer

	@moduledoc"""
	PointSystem.CLI handles every action to compute the final points
	values of every player that participated in a given Go tournament.
	Rules:
	1) Total points to distributes corresponde to 10*(players).
	2) The points formula computes the points for every player.
	   You can find this formula en our web page.
	3) The 70% of the sum of the points needs to be in the 50%,
	   or less, of the best players.
	"""

	@doc"""
	'players' must be a list similar to:
	[%{num: 1, player_id: 72, placement: 1},
	%{num: 2, player_id: 61, placement: 2 },
	%{num: 3, player_id: 61, placement: 3 }]
	With some players there could be a tie between them. They would have the same placement.
	Returns: %{players(list), ih_index(float), points_criteria(float)}
	"""
	def main(players, weight) do
		result = players
							|> process_points(weight)

 		# Calculate ties between players if there players share the same placement
		Map.put(result, :players, process_ties(result.players))
	end

	def process_points(players, weight) do

		compute_ih_index(players, 0, 1, weight)
	end

	@doc"""
	Recurisve function to determine homogenic index for a given set of players.
	It checks if the points criteria (sum of points) is in the players criteria
	percentage.
	First step is to calculate the points for an arbitrary index. Then it iterates
	over that homogenic index to fulfill the points criteria.
	Returns: {players, h_index}
	"""
	def compute_ih_index(players, ih_index, points_criteria, _) when points_criteria <= 0.7 do
		%{players: players,
		  ih_index: ih_index - 0.1,
		  points_criteria: points_criteria}
	end
	def compute_ih_index(players, ih_index, _, weight) do

		compute_points(players, ih_index, weight)
		|> compute_points(ih_index, weight)
		|> compute_points_criteria()
		|> (&compute_ih_index(&1.players,
							ih_index + 0.1,
							&1.points_criteria, weight)).()
	end

	def compute_points(players, ih_index, weight) do
		total_points = Enum.count(players) * weight
		sum_of_pp = Enum.reduce(players, 0,
						fn(x, acc) -> total_points/(x.num + ih_index) + acc  end)
		players
		|> Enum.map( fn(x) -> Map.put(x, :points,
						(:math.pow(total_points, 2))/((x.num + ih_index)*sum_of_pp))  end)
	end
	@doc"""
	The points criteria and the sum of the resulting points for a given ih_index diveded
	by the sum of the nth first players to match it with the players criteria (50%).
	Actually, this index, needs to be <= 0.7 to fulfill the criterias of the points system.

	If there are odd number of players. The sum of points to fulfill the criteria takes
	half points of the points of the "next player"
	"""
	def compute_points_criteria(players) do
		sum_of_points = Enum.reduce(players, 0, fn(x, acc) -> x.points + acc end)

		floor_size = round(Float.floor(Enum.count(players)/2, 0))
		sum_of_n_points =
			case Integer.is_even(players) do
				 true ->
						players
						|> Enum.take(floor_size) # Should not affect because it's even
						|> Enum.reduce(0, fn(x, acc) -> x.points + acc end)
				 false ->
						players
						|> Enum.take(floor_size)
						|> Enum.reduce(0, fn(x, acc) -> x.points + acc end)
						|> (fn(x) -> x + (Enum.find(players, &(&1.placement == floor_size + 1))).points/2 end).() # Takes half points of the next player
			end

		%{players: players, points_criteria: sum_of_n_points/sum_of_points}
	end

	def process_ties(players) do
		players
		|> Enum.group_by(&(&1.placement)) # Groups players by placement
		|> Enum.map(fn({_, group}) ->
				sum = Enum.reduce(group, 0, fn(x, acc) -> x.points + acc  end)
				Enum.map(group, fn(x) -> Map.put(x, :points, sum/Enum.count(group)) end)
			end)
		|> Enum.concat # concatenates the enumerables into a single list
	end
end
