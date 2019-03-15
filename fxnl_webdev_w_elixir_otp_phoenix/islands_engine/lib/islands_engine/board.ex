defmodule IslandsEngine.Board do
   alias IslandsEngine.{Coordinate, Island}
   def new(), do: %{}

   # positions an island on the board using a given coordinate and offsets for an island type
   def position_island(board, key, %Island{} = island) do
      case overlaps_existing_island?(board, key, island) do
         true -> {:error, :overlapping_island}
         false -> Map.put(board, key, island)
      end
   end

   # checks to see if a new island will overlap an existing island as selected
   defp overlaps_existing_island?(board, new_key, new_island) do
      Enum.any?(board, fn {key, island} ->
         key != new_key and Island.overlaps?(island, new_island)
      end)
   end

   # checks to see if one of all island types have been positioned on a board
   def all_islands_positioned?(board), do: Enum.all?(Island.types, &(Map.has_key?(board, &1)))

   # checks a guess against the board's island positionings
   def guess(board, %Coordinate{} = coordinate) do
      board
      |> check_all_islands(coordinate)
      |> guess_response(board)
   end

   # used inside of guess to check the coordinates of all the islands
   defp check_all_islands(board, coordinate) do
      Enum.find_value(board, :miss, fn {key, island} ->
         case Island.guess(island, coordinate) do
            {:hit, island} -> {key, island}
            :miss -> false
         end
      end)
   end

   # gives a respective response to a user's guess about their opponent's islands
   defp guess_response({key, island}, board) do
      board = %{board | key => island}
      {:hit, forest_check(board, key), win_check(board), board}
   end
   defp guess_response(:miss, board), do: {:miss, :none, :no_win, board}

   # checks to see if the board has forested islands
   defp forest_check(board, key) do
      case forested?(board, key) do
         true -> key
         false -> :none
      end
   end

   #  used to check each Island to see if they're forested
   defp forested?(board, key) do
      board
      |> Map.fetch!(key)
      |> Island.forested?()
   end

   # given a board, this determines whether the user has won
   defp win_check(board) do
      case all_forested?(board) do
         true -> :win
         false -> :no_win
      end
   end

   # given a board, this cross examines all of its islands to see if all of them have been forested
   defp all_forested?(board), do: Enum.all?(board, fn {_key, island} -> Island.forested?(island) end)
end
