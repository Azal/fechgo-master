defmodule Fechgo.PointSystemTest.Seed do
	def data_players() do
		[%{name: "P1", num: 1, placement: 1},
  	 %{name: "P2", num: 2, placement: 2},
		 %{name: "P3", num: 3, placement: 3},
		 %{name: "P4", num: 4, placement: 4},
		 %{name: "P5", num: 5, placement: 5},
		 %{name: "P6", num: 6, placement: 6},
		 %{name: "P7", num: 7, placement: 7},
		 %{name: "P8", num: 8, placement: 8},
		 %{name: "P9", num: 9, placement: 9},
		 %{name: "P10", num: 10, placement: 10},
		 %{name: "P11", num: 11, placement: 11},
		 %{name: "P12", num: 12, placement: 12},
		 %{name: "P13", num: 13, placement: 13},
		 %{name: "P14", num: 14, placement: 14},
		 %{name: "P15", num: 15, placement: 15},
		 %{name: "P16", num: 16, placement: 16}]
	end

	def data_players_same_placement() do
		[%{name: "P1", num: 1, placement: 1},
  	 %{name: "P2", num: 2, placement: 2},
		 %{name: "P3", num: 3, placement: 2},
		 %{name: "P4", num: 4, placement: 2},
		 %{name: "P5", num: 5, placement: 5},
		 %{name: "P6", num: 6, placement: 6},
		 %{name: "P7", num: 7, placement: 6},
		 %{name: "P8", num: 8, placement: 8},
		 %{name: "P9", num: 9, placement: 9},
		 %{name: "P10", num: 10, placement: 10},
		 %{name: "P11", num: 11, placement: 11},
		 %{name: "P12", num: 12, placement: 12},
		 %{name: "P13", num: 13, placement: 13},
		 %{name: "P14", num: 14, placement: 13},
		 %{name: "P15", num: 15, placement: 13},
		 %{name: "P16", num: 16, placement: 16}]
	end

	def data_results() do
		%{players: [
					%{name: "P1", num: 1, points: 24.2, placement: 1 },
					%{name: "P2", num: 2, points: 19.0, placement: 2},
					%{name: "P3", num: 3, points: 15.7, placement: 3},
					%{name: "P4", num: 4, points: 13.4, placement: 4},
					%{name: "P5", num: 5, points: 11.6, placement: 5},
					%{name: "P6", num: 6, points: 10.3, placement: 6},
					%{name: "P7", num: 7, points: 9.2, placement: 7},
					%{name: "P8", num: 8, points: 8.4, placement: 8},
					%{name: "P9", num: 9, points: 7.6, placement: 9},
					%{name: "P10", num: 10, points: 7.0, placement: 10},
					%{name: "P11", num: 11, points: 6.5, placement: 11},
					%{name: "P12", num: 12, points: 6.1, placement: 12},
					%{name: "P13", num: 13, points: 5.7, placement: 13},
					%{name: "P14", num: 14, points: 5.4, placement: 14},
					%{name: "P15", num: 15, points: 5.1, placement: 15},
					%{name: "P16", num: 16, points: 4.8, placement: 16}],
		ih_index: 2.7,
		points_criteria: 0.699}
	end

	def data_results_odd() do
		%{players: [%{name: "P1", num: 1, points: 20.8, placement: 1},
					%{name: "P2", num: 2, points: 17.2, placement: 2},
					%{name: "P3", num: 3, points: 14.7, placement: 3},
					%{name: "P4", num: 4, points: 12.8, placement: 4},
					%{name: "P5", num: 5, points: 11.4, placement: 5},
					%{name: "P6", num: 6, points: 10.2, placement: 6},
					%{name: "P7", num: 7, points: 9.3, placement: 7},
					%{name: "P8", num: 8, points: 8.5, placement: 8},
					%{name: "P9", num: 9, points: 7.8, placement: 9},
					%{name: "P10", num: 10, points: 7.2, placement: 10},
					%{name: "P11", num: 11, points: 6.8, placement: 11},
					%{name: "P12", num: 12, points: 6.3, placement: 12},
					%{name: "P13", num: 13, points: 6.0, placement: 13},
					%{name: "P14", num: 14, points: 5.6, placement: 14},
					%{name: "P15", num: 15, points: 5.3, placement: 15}],
		ih_index: 3.8,
		points_criteria: 0.700}
	end
	def data_results_same_placement() do
		%{players: [
			%{name: "P1", num: 1, points: 24.2, placement: 1 },
			%{name: "P2", num: 2, points: 16.0, placement: 2},
			%{name: "P3", num: 3, points: 16.0, placement: 2},
			%{name: "P4", num: 4, points: 16.0, placement: 2},
			%{name: "P5", num: 5, points: 11.6, placement: 5},
			%{name: "P6", num: 6, points: 9.8, placement: 6},
			%{name: "P7", num: 7, points: 9.8, placement: 6},
			%{name: "P8", num: 8, points: 8.4, placement: 8},
			%{name: "P9", num: 9, points: 7.6, placement: 9},
			%{name: "P10", num: 10, points: 7.0, placement: 10},
			%{name: "P11", num: 11, points: 6.5, placement: 11},
			%{name: "P12", num: 12, points: 6.1, placement: 12},
			%{name: "P13", num: 13, points: 5.4, placement: 13},
			%{name: "P14", num: 14, points: 5.4, placement: 13},
			%{name: "P15", num: 15, points: 5.4, placement: 13},
			%{name: "P16", num: 16, points: 4.8, placement: 16}],
ih_index: 2.7,
points_criteria: 0.699}
	end
end
